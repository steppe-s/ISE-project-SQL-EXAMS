USE VerifyPrototype
DELETE FROM SQLqueries
INSERT INTO SQLqueries (queryNo, query) VALUES 
(1, 'SELECT * FROM SQLqueries'),
(2, 'SELECasdT * FROM SQLqueries'),
(3, 'SELECT * FROM SQLqueries WHERE queryNo = 1'),
(4, 'SELECT query FROM SQLqueries')