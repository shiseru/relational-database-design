





-- How many users for each rental id
CREATE VIEW rental_guest_count AS
(
    SELECT rid, count(userId) AS user_count FROM
    (
        SELECT rid, userId FROM (rental JOIN renter USING (rid) JOIN my_user USING (userId))
        UNION
        (SELECT rid, userId FROM rental JOIN guest USING (rid) JOIN my_user USING (userId))
    ) a1
    GROUP BY (rid)
);



-- What is the capacity of the property associated with each rentalID
CREATE VIEW rental_property_capacity AS
( 
    SELECT rid, capacity
    FROM 
    property JOIN rental USING (pid)
);


CREATE VIEW at_cap_rental AS
(
    SELECT rid FROM 
    rental_guest_count JOIN rental_property_capacity USING (rid)
    WHERE user_count=capacity
);




CREATE VIEW at_cap_result AS
(
    SELECT count(distinct rid) AS at_cap_count, avg(star) AS at_cap_avg_rating FROM 
    at_cap_rental JOIN rental_rate USING (rid)
);


CREATE VIEW below_cap_rental AS
(
    SELECT rid FROM
    (
        (SELECT rid FROM rental) 
        EXCEPT
        (SELECT rid from at_cap_rental)
    ) a1
);



CREATE VIEW below_cap_result AS
(
    SELECT count(distinct rid) AS below_cap_count, avg(star) AS below_cap_avg_rating FROM 
    below_cap_rental JOIN rental_rate USING (rid)
);

-- result
SELECT * FROM at_cap_result , below_cap_result;



