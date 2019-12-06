-- rental id of all rentals of water property
CREATE VIEW water_rental AS(
    SELECT rid FROM
    property JOIN water_properties USING (pid)
    JOIN rental USING (pid)
);

CREATE VIEW water_result AS
(
    SELECT * FROM
    (
        SELECT avg(guest_count) AS avg_water_extra_guest FROM 
        (
            SELECT count(userid) guest_count FROM
            water_rental JOIN guest USING (rid)
            GROUP BY rid
        ) a1
    ) b1, 
    (
        SELECT avg(star) AS avg_water_rating FROM
        water_rental JOIN rental_rate USING (rid)
    ) b2
);

-- rental id of all rentals of city property
CREATE VIEW city_rental AS(
    SELECT rid FROM
    property JOIN city_property USING (pid)
    JOIN rental USING (pid)
);

CREATE VIEW city_result AS
(
    SELECT * FROM
    (
        SELECT avg(guest_count) AS avg_city_extra_guest FROM 
        (
            SELECT count(userid) guest_count FROM
            city_rental JOIN guest USING (rid)
            GROUP BY rid
        ) a1
    ) b1, 
    (
        SELECT avg(star) AS avg_city_rating FROM
        city_rental JOIN rental_rate USING (rid)
    ) b2
);

-- rental id of all rentals of property type other than city and water (not including property of
-- city and water at the same time) 
CREATE VIEW other_rental AS(
    SELECT rid FROM
    (
        (SELECT rid FROM rental)
        EXCEPT
        (SELECT rid from water_rental)
        EXCEPT
        (SELECT rid FROM city_rental)
    ) a1
);

CREATE VIEW other_result AS
(
    SELECT * FROM
    (
        SELECT avg(guest_count) AS avg_other_extra_guest FROM 
        (
            SELECT count(userid) guest_count FROM
            other_rental JOIN guest USING (rid)
            GROUP BY rid
        ) a1
    ) b1, 
    (
        SELECT avg(star) AS avg_other_rating FROM
        other_rental JOIN rental_rate USING (rid)
    ) b2
);

SELECT avg_water_extra_guest, avg_city_extra_guest, avg_other_extra_guest
FROM water_result, city_result, other_result;

