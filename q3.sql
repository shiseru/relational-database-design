
CREATE VIEW host_avg_rating AS
(
	SELECT hid, AVG(star) AS avg_rating FROM
	host_rate JOIN rental USING (rid)
	JOIN property USING (pid)
	JOIN host USING (hid)
	GROUP BY hid
);

-- Could be multiple highest rated host
CREATE VIEW highest_rated_host AS
(
	SELECT hid, avg_rating FROM
	host_avg_rating
	WHERE avg_rating = (SELECT MAX(avg_rating) FROM host_avg_rating)
)
;

-- Note that this is the highest price ever booked 
-- (not necessarily the highest price ever listed but not booked)
-- (This also assumes that weekly price does not change
--  for a single rental of multiple weeks)
SELECT email, avg_rating, MAX(price) AS highest_price FROM
highest_rated_host JOIN host USING (hid) 
JOIN property USING (hid)
JOIN rental USING (pid)
JOIN property_price USING (pid, startDate)
GROUP BY hid, email, avg_rating;
