TRUNCATE TABLE listings, users, bookings RESTART IDENTITY;

INSERT INTO users (name, username, email, password) VALUES ('The Undertaker', 'undertakerrules!', 'hell@weemail.com', 'tombstone');
INSERT INTO users (name, username, email, password) VALUES ('Stone Cold Steve Austin', 'stonecoldstunner', 'texasrattlesnake@weemail.com', 'stunner');
INSERT INTO users (name, username, email, password) VALUES ('The Rock', 'peopleseyebrow', 'champ@weemail.com', 'heatbreakhotel');

INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Beautiful 2-bed maisonette', '12 Rodney Road', 'London', 'United Kingdom', '$400.00', 'Stunning situation, great amenities with walk in shower', 1, '2023-01-01', '2023-09-13');
INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Pokey underground bedsit',	'72 Wally Street', 'New York', 'United States', '$79.00', 'Cosy intimate living area, open plan living', 2, '2022-11-10', '2023-01-01');
INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Flashy mansion', '8 Rich Lane', 'Oslo',	'Norway',	'$2,159.00', 'Big party mansion, ideal for entertaining and treating your loved ones', 3, '2023-03-15', '2023-04-15');
INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Home away from home', '58 House Lane',	'Madrid', 'Spain', '$200.00', 'Spacious flat in the Malasaña area of madrid, natural light abound', 1, '2023-01-01', '2023-06-12');
INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Lovers first choice', '10 Teal Road', 'Paris', 'France',' $760.00', 'Luxury flat in the heart of Paris, with romantic views of the Eiffel tower', 2, '2022-12-25', '2023-01-02');
INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Cute caravan x', 'Nelly Fields', 'Hamburg', 'Germany', '$40.00', 'The perfect retreat, away from the hassle of big town life', 3, '2023-07-12', '2024-03-08');
INSERT INTO listings (name, address, city, country, ppn, description, host_id, available_start, available_end) VALUES ('Cute caravan x2', 'Nelly Fields', 'Hamburg', 'Germany', '$40.00', 'The perfect retreat, away from the hassle of big town life', 3, '2022-11-12', '2022-11-18');

INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-05-01', 1, 1, 'f');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-03-01', 2, 2, 'f');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-07-12', 3, 3, 'f');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-02-08', 1, 4, 't');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-12-25', 2, 5, 't');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-09-13', 3, 6, 't');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-11-14', 1, 7, 't');
INSERT INTO bookings (date, user_id, listing_id, approved) VALUES ('2022-11-16', 2, 7, 't');