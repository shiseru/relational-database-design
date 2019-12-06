INSERT INTO host VALUES
(1, 'luke@gmail.com'),
(2, 'leia@gmail.com'),
(3, 'han@gmail.com');

INSERT INTO property VALUES
--(property id, host id, num bedrooms, num bathrooms, capacity, address)
(1, 1, 3, 1, 6, 'Tatooine'), -- its luxuries are: hot tub, daily cleaning. 
(2, 2, 1, 1, 2, 'Alderaan'), -- its luxuries are: hot tub, sauna, and daily cleaning.  This is a water property, with water type 'lake' and does not offer lifeguards. 
(3, 3, 2, 1, 3, 'Corellia'), -- its luxuries are: daily breakfast delivery and concierge service.  This is a city property, with walkability score 20 and 'bus' is the nearest transit. 
(4, 2, 2, 1, 2, 'Verona'),   -- it has just one luxury: laundry service. 
(5, 3, 2, 2, 4, 'Florence'), -- it has just a hot tub.  
(6, 1, 1, 1, 2, 'Toronto');  -- It has many luxuries: hot tub, sauna, laundry service, daily cleaning, and concierge service. 

INSERT INTO water_properties VALUES
(2, 1);

INSERT INTO water_property VALUES
(1, 'lake', FALSE);

INSERT INTO city_property VALUES
(3, 20, 'bus');


INSERT INTO luxuries VALUES
-- lid, name
(1, 'hot tub'),
(2, 'daily cleaning'),
(3, 'sauna'),
(4, 'daily breakfast delivery'),
(5, 'concierge service'),
(6, 'laundry service');

INSERT INTO luxury VALUES
-- pid(propertyId) lid(luxuryID)
-- property 1: hot tub and daily cleaning
(1, 1),
(1, 2),
-- property 2: hot tub, sauna, and daily cleaning
(2, 1),
(2, 3),
(2, 2),
-- property 3: daily breakfast delivery and concierge service
(4, 4),
(3, 5),
-- property 4: laundry service
(4, 6),
-- property 5: hot tub
(5,1),
-- property 6: hot tub, sauna, laundry service, daily cleaning, and concierge service.
(6,1),
(6,3),
(6,6),
(6,2),
(6,5);

INSERT INTO my_user VALUES
--(userid, name, dob, address
(1, 'Darth Vader', '1985-12-06'::timestamp, 'Death Star'),
(2, 'Leia, Princess', '2001-10-05'::timestamp, 'Alderaan'),
(3, 'Romeo Montague', '1988-05-11'::timestamp, 'Verona'),
(4, 'Juliet Capulet', '1991-07-24'::timestamp, 'Verona'),
(5, 'Mercutio', '1988-03-03'::timestamp, 'Verona'),
(6, 'Chewbacca', '1998-09-15'::timestamp, 'Kashyyyk');

INSERT INTO rental VALUES
-- rental id, property id, start date, end date, price
(1, 2, '2019-01-05'::timestamp, '2019-01-11'::timestamp),
(2, 3, '2019-01-12'::timestamp, '2019-01-25'::timestamp),
(3, 2, '2019-01-12'::timestamp, '2019-01-18'::timestamp),
(4, 5, '2019-01-05'::timestamp, '2019-01-11'::timestamp),
(5, 5, '2019-01-12'::timestamp, '2019-01-18'::timestamp);

INSERT INTO renter VALUES
-- rental id, user id, credit card number
(1, 1, '3466704824219330'),
(2, 2, '6011253896008199'),
(3, 3, '5446447451075463'),
(4, 5, '4666153163329984'),
(5, 6, '6011624297465933');

INSERT INTO property_price VALUES
-- pid, startDate, endDate, price
(2, '2019-01-05'::timestamp, '2019-01-11'::timestamp, '580'),
(3, '2019-01-12'::timestamp, '2019-01-18'::timestamp, '750'),
(3, '2019-01-19'::timestamp, '2019-01-25'::timestamp, '750'),
(2, '2019-01-12'::timestamp, '2019-01-18'::timestamp, '600'),
(5, '2019-01-05'::timestamp, '2019-01-11'::timestamp, '1000'),
(5, '2019-01-12'::timestamp, '2019-01-18'::timestamp, '1220');

INSERT INTO guest VALUES
-- rentalID, userId
(1, 2),
(2, 3),
(2, 4),
(3, 4),
(4, 3),
(4, 1),
(5, 2);

INSERT INTO rental_rate VALUES
-- rid, userID, rateId, star
(1, 2, 1, 5), -- Leia: 5star
(1, 1, 2, 2), -- Darth Vader: 2star

--rid 2, property3
(2, 3, 3, 5), --'Romeo Montague': 5star
(2, 4, 4, 5), --   'Juliet Capulet': 5 stars
(2, 2, 5, 1), --'Leia, Princess': 1 star

-- rid 3, property2
(3, 4, 6, 5), -- 'Juliet Capulet': 5 stars

-- rid 4, property5
(4, 5, 7, 1), --'Mercutio': 1 star
(4, 3, 8, 1), -- 'Romeo Montague': 1 star

-- rid 5, property5
(5, 6, 9, 3);-- 'Chewbacca': 3 stars

-- rateId, comment
INSERT INTO rating_comment VALUES
(2, 'Looks like she hides rebel scum here.'),
(5, 'A bit scruffy, could do with more regular housekeeping'),
(9, 'Fantastic, arggg');


-- rid, userId, rating
INSERT INTO host_rate VALUES
(1, 2),
(2, 5),
(3, 3),
(4, 4),
(5, 4);

