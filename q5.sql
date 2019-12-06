
CREATE VIEW property_price_summary AS
(
    SELECT pid, MAX(price) AS max_price, MIN(price) AS min_price, (MAX(price) - MIN(price)) AS price_range
    FROM property_price
    GROUP BY pid
)
;

CREATE VIEW max_property_price_range AS 
(
    SELECT MAX(price_range) AS price_range, '*'::text AS max_price_range FROM property_price_summary
);


SELECT pid AS property_id, max_price, min_price, price_range, COALESCE(max_price_range, '') AS max_price_range
FROM property_price_summary LEFT OUTER JOIN max_property_price_range USING (price_range);

