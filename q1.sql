
SELECT l2.name, COUNT(l1.pid) AS num_of_properties
FROM luxury AS l1
LEFT OUTER JOIN luxuries AS l2
ON l1.lid = l2.lid
GROUP BY l2.name
