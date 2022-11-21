CREATE DATABASE orders;

USE orders;

CREATE TABLE entries
(
ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
RecordNumber VARCHAR(64), -- This is the UUID
CustomerName VARCHAR(64),
Email VARCHAR(64),
Phone VARCHAR(64),
Stat INT(1) DEFAULT 0, -- Job status, not done is 0, done is 1
RAWS3URL VARCHAR(200), -- set the returned S3URL here
FINSIHEDS3URL VARCHAR(200)
);

INSERT INTO jobs(RecordNumber,CustomerName,Email,Phone,Stat,S3URL) VALUES('00000',"NAME","email@iit.edu","000-000-0000",0,"http://");
