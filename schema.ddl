drop schema if exists vacationschema cascade;
create schema vacationschema;
set search_path to vacationschema;

-- 1. What constraints from the domain could not be enforced, if any?
--
--    - "a week is defined to start on a Saturday"
--      Having startDate of rental be on Saturday, and endDate of rental be on
--      Friday could not be enforced. This could not be enforced for the 
--      following:
--          - rental.startDate
--          - rental.endDate
--          - property_price.startDate
--          - property_price.startDate
--      Even though this only reqires a row base check, the
--      function "EXTRACT" (used for extracting weekday from
--      timestamp) does not work within CHECK().
--
-- 2. What constraints that could have been enforced were not enforced, if any? Why not?
--
--    - "Renter must be at least 18 years old on the first day of the rental"
--      This could not be enforeced. DOB of user is stored on a different table
--      than the table about rental date. This involves a check accross table (assertion),
--      which is not supported by PostgreSQL. However, if we were to design
--      the table differently, and put DOB of user in the same table
--      as the table that stores the first day of rental, then we could have
--      enforce this constraints. But, it does not make much sence to make such
--      a table, and will introduce a lot of redundancy.
--
--    - "The number of guests, including the renter, must not exceed the sleeping capacity of the property"
--      This could not be enforced for similar reason as above. Number of guests
--      and renters is stored on a different table then the table that stores
--      the sleeping capacity. Thus requiring a check accross table.
--      (and as a result, have the same consequences as the last constraint
--      that we decide not to enforce)
--

CREATE TABLE host (
    hid INT PRIMARY KEY,
    email VARCHAR(64) NOT NULL
);

CREATE TABLE property (
    pid INT PRIMARY KEY,
    hid INT REFERENCES Host(hid) NOT NULL,
    numberBedRooms INT NOT NULL,
    numberBathRooms INT NOT NULL,
    capacity INT NOT NULL,
    address VARCHAR(64) NOT NULL,
    CHECK(numberBedRooms <= capacity)
);

-- Specify luxury types
-- If multiple properties has the same luxury type (String), then
-- the name of the luxury (String) will only be stored once
CREATE TABLE luxuries (
    lid INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

-- luxury of each property
CREATE TABLE luxury (
    pid INT REFERENCES property(pid) NOT NULL,
    lid INT REFERENCES luxuries(lid) NOT NULL,
    PRIMARY KEY(pid, lid)
);

CREATE TABLE city_property (
    pid INT REFERENCES Property(pid) NOT NULL,
    walkability INT NOT NULL,
    transitType VARCHAR(32) NOT NULL,
    PRIMARY KEY(pid),
    CHECK (walkability >= 0 and walkability <= 100),
    -- Using the string 'none' is more clear then NULL
    -- when performing equality
    CHECK (transitType in ('bus', 'LRT', 'subway', 'none'))
);


-- This extra table is only needed for water properties (no need for
-- city property), because it is one-to-many (potentially multiple water types)
-- Using integers for water type avoids storing the same water type string
-- multiple times. (instead it stores integers)
CREATE TABLE water_properties (
    pid INT REFERENCES Property(pid) NOT NULL,
    wid INT PRIMARY KEY
);

CREATE TABLE water_property (
    wid INT REFERENCES water_properties(wid) NOT NULL,
    waterType VARCHAR(32) NOT NULL,
    hasLifeguard BOOLEAN NOT NULL,
    PRIMARY KEY(wid),
    CHECK (waterType in ('beach', 'lake', 'pool'))
);

CREATE TABLE property_price (
    -- property id
    pid INT REFERENCES Property(pid) NOT NULL,
    startDate TIMESTAMP NOT NULL,
    endDate TIMESTAMP NOT NULL,
    -- weekly price
    price REAL NOT NULL,
    PRIMARY KEY(pid, startDate)
    --CHECK (EXTRACT(startDate) == 6)
);


CREATE TABLE rental (
    rid INT PRIMARY KEY,
    pid INT REFERENCES property(pid) NOT NULL,
    startDate date NOT NULL,
    endDate date NOT NULL
);

CREATE TABLE my_user (
    userId INT PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    dob date NOT NULL,
    address VARCHAR(64) NOT NULL
);

CREATE TABLE renter (
    rid INT REFERENCES rental(rid) NOT NULL,
    -- clearly userID is unique, but the word UNIQUE still needs to be here
    -- because it s a forgnie key for hostrate
    userId INT UNIQUE REFERENCES my_user(userId) NOT NULL,
    creditCardNum BIGINT NOT NULL,
    PRIMARY KEY(rid)
);

CREATE TABLE guest (
    rid INT REFERENCES rental(rid) NOT NULL,
    userId INT REFERENCES my_user(userId) NOT NULL,
    PRIMARY KEY(rid, userId)
);

CREATE DOMAIN MYRATING AS INT
    CHECK (value >=0 and value <=5);

CREATE TABLE rental_rate (
    rid INT REFERENCES rental(rid) NOT NULL,
    userId INT REFERENCES my_user(userId) NOT NULL,
    rateId INT PRIMARY KEY,
    star MYRATING NOT NULL,
    UNIQUE (rid, userId) -- each user can rate each rental at most once
);

CREATE TABLE rating_comment (
    rateId INT REFERENCES rental_rate(rateId) NOT NULL PRIMARY KEY,
    my_comment VARCHAR(256)
);

CREATE TABLE host_rate (
    rid INT REFERENCES rental(rid) NOT NULL,
    star MYRATING NOT NULL,
    PRIMARY KEY(rid)
);

