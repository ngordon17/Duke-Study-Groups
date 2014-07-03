

CREATE TABLE Senators (
	id VARCHAR(50),
	first_name VARCHAR(50),
	last_name VARCHAR(50), 
	state CHAR(2),
	party CHAR(3) CHECK value IN ('Rep', 'Dem', 'Ind')
);

CREATE TABLE Bills (
	id VARCHAR(50)
);

CREATE TABLE Cosponsorships (
	sen_id VARCHAR(50),
	bill_id VARCHAR(50)
);