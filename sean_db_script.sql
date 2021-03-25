DROP TABLE IF EXISTS Companies;

/* Note: there are a number of repeating listings on the Indeed Search*/
/* Note: Daniel's script left out the last two rows. I haven't had time to troubleshoot but removed these rows from other table csv files*/


CREATE TABLE Companies(
Company_Id integer NOT NULL, 
Company char(200),
PRIMARY KEY (Company_Id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Atlanta_Companies.csv'
INTO TABLE Companies
FIELDS TERMINATED BY ','
ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Company_Id, Company)
;

DROP TABLE IF EXISTS Listings;

CREATE TABLE Listings(
Listings_Id integer NOT NULL,
Company_Id integer NOT NULL,
Job_Title char(150),
Job_Level char(150),
City char(100),
State char(100),
PRIMARY KEY (Listings_Id),
FOREIGN KEY(Company_Id) REFERENCES Companies(Company_Id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Atlanta_Listings.csv'
INTO TABLE Listings
FIELDS TERMINATED BY ','
ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Listings_Id, Company_Id, Job_Title, Job_Level, City, State)
;

DROP TABLE IF EXISTS Skill_Counts;

CREATE TABLE Skill_Counts(
Skill_Count_Id integer NOT NULL,
analysis integer NOT NULL, 
aws integer NOT NULL, 
azure integer NOT NULL, 
caffe integer NOT NULL, 
cassandra integer NOT NULL, 
communication integer NOT NULL, 
computer_science integer NOT NULL, 
cplus_plus integer NOT NULL, 
csharp integer NOT NULL, 
data_engineering integer NOT NULL, 
deep_learning integer NOT NULL, 
docker integer NOT NULL, 
excel integer NOT NULL, 
git integer NOT NULL, 
hadoop integer NOT NULL, 
hbase integer NOT NULL, 
hive integer NOT NULL, 
java integer NOT NULL, 
javascript integer NOT NULL, 
keras integer NOT NULL, 
linux integer NOT NULL, 
machine_learning integer NOT NULL, 
mathematics integer NOT NULL, 
matlab integer NOT NULL, 
mongo_db integer NOT NULL, 
mysql integer NOT NULL, 
neural_networks integer NOT NULL, 
nlp integer NOT NULL, 
nosql integer NOT NULL, 
numpy integer NOT NULL, 
pandas integer NOT NULL, 
perl integer NOT NULL, 
pig integer NOT NULL, 
project_management integer NOT NULL, 
python integer NOT NULL, 
pytorch integer NOT NULL, 
r integer NOT NULL, 
sas integer NOT NULL, 
scala integer NOT NULL, 
scikit_learn integer NOT NULL, 
software_development integer NOT NULL, 
software_engineering integer NOT NULL, 
spark integer NOT NULL, 
spss integer NOT NULL, 
s_ql integer NOT NULL, 
statistics integer NOT NULL, 
tableau integer NOT NULL, 
tensor_flow integer NOT NULL, 
visualization integer NOT NULL, 
PRIMARY KEY (Skill_Count_Id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Text_Analysis.csv'
INTO TABLE Skill_Counts
FIELDS TERMINATED BY ','
ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Skill_Count_Id, analysis, aws, azure, caffe, cassandra, communication, computer_science, cplus_plus, csharp, data_engineering, deep_learning, docker, excel, git, hadoop, hbase, hive, java, javascript, keras, linux, machine_learning, mathematics, matlab, mongo_db, mysql, neural_networks, nlp, nosql, numpy, pandas, perl, pig, project_management, python, pytorch, r, sas, scala, scikit_learn, software_development, software_engineering, spark, spss, s_ql, statistics, tableau, tensor_flow, visualization)
;

DROP TABLE IF EXISTS Listings_Skill_Counts;

CREATE TABLE Listings_Skill_Counts(
Listing_Id INT,
Skill_Counts_Id INT,
PRIMARY KEY(Listing_Id, Skill_Counts_Id),
Foreign Key(Skill_Counts_Id) REFERENCES Skill_Counts(Skill_Count_Id),
Foreign Key(Listing_Id) REFERENCES Listings(Listings_Id)
);

insert into Listings_Skill_Counts (Listing_Id, Skill_Counts_Id)
select Listings_Id AS Listing_Id, 
Skill_Count_Id AS Skill_Counts_Id
FROM Listings CROSS JOIN Skill_Counts;

/* Run a test query*/
SELECT *
FROM Listings l
INNER JOIN Listings_Skill_Counts lsc
ON l.Listings_id = lsc.Listing_id
INNER JOIN Skill_Counts sc
ON sc.Skill_Count_Id = lsc.Skill_Counts_Id
;

