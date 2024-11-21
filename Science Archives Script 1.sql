/* This version of the database has the complete database, dummy data, indexes, views and the SQL quries needed to support the functionality of the Science Archives Project - this script will run without any error statements on Oracle Live SQL*/

/* The below DDL statement shows a table created for system user and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE SystemUser (     
    systemUserId NUMBER (10) GENERATED ALWAYS AS IDENTITY NOT NULL,     
    firstName VARCHAR(100) NOT NULL,     
    lastName VARCHAR (100) NOT NULL,     
    password VARCHAR(30) NOT NULL,     
    email VARCHAR (50) UNIQUE NOT NULL,     
    contactPreference VARCHAR(20) NOT NULL CHECK (contactPreference IN ('Phone number','Email')),     
    userType VARCHAR(6) NOT NULL CHECK (userType IN ('Reader', 'Author', 'Both')),     
         
    PRIMARY KEY (systemUserId)     
    );

/* The below DDL statement shows a table created for Phone number and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE PhoneNumber (  
    systemUserId NUMBER (10) NOT NULL,  
    phoneNumber VARCHAR (20) NOT NULL,  
  
    CONSTRAINT phone_pk PRIMARY KEY (systemUserId, phoneNumber),  
    FOREIGN KEY (systemUserId) REFERENCES systemUser  
);

/* The below DDL statement shows a table created for system Author Review and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE AuthorReview (  
    systemUserId NUMBER (10) NOT NULL,  
    authorUserId NUMBER (10) NOT NULL,  
    reviewScore NUMBER (2) NOT NULL,  
    reviewContent VARCHAR(8000) NOT NULL,  
  
    CONSTRAINT authorReview_pk PRIMARY KEY (systemUserId,authorUserId),  
    FOREIGN KEY (systemUserId) REFERENCES systemUser,  
    FOREIGN KEY (authorUserID) REFERENCES systemUser (systemUserId)  
    /* The foreign key constraint for authorUserId references the systemUserId primary key in the system*/  
    );


/* The below DDL statement shows a table created for subject and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE subject( 
    subjectName VARCHAR (50) NOT NULL, 
    PRIMARY KEY (subjectName) 
);


/* The below DDL statement shows a table created for user interest and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE userInterest( 
    systemUserId NUMBER (10) NOT NULL, 
    subjectName VARCHAR(50) NOT NULL, 
 
    CONSTRAINT userInterest_pk PRIMARY KEY (systemUserId, subjectName), 
    FOREIGN KEY (systemUserId) REFERENCES systemUser, 
    FOREIGN KEY (subjectName) REFERENCES subject 
);

/* The below DDL statement shows a table created for publisher and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE publisher( 
    publisherId NUMBER (10) GENERATED ALWAYS AS IDENTITY NOT NULL, 
    publisherName VARCHAR (255) NOT NULL, 
    location VARCHAR (255) NOT NULL, 
     
    PRIMARY KEY (publisherId) 
);


/* The below DDL statement shows a table created for publication and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE publication(  
    publicationId NUMBER (10) GENERATED  BY DEFAULT AS IDENTITY NOT NULL,  
    Title VARCHAR(255) NOT NULL,  
    Editors VARCHAR (1000) NOT NULL,  
    hyperlink VARCHAR (500) NOT NULL,  
    publicationType VARCHAR (30) NOT NULL CHECK (publicationType In ('Thesis', 'Article', 'Book', 'Conference Proceeding Paper')),  
    abstract VARCHAR (8000),  
    volumeNumber NUMBER (3),  
    publicationDate DATE NOT NULL,  
    pageNumbers VARCHAR (10) NOT NULL,  
    publisherId NUMBER (10) NOT NULL,  
  
    PRIMARY KEY (publicationId),  
    FOREIGN KEY (publisherId) REFERENCES publisher  
      
);

/* The below DDL statement shows a table created for Author and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE Author(  
    systemUserId NUMBER (10) NOT NULL,  
    publicationId NUMBER (10) NOT NULL,  
    TypeOfAuthor VARCHAR (30) CHECK (TypeOfAuthor IN ('Co-author', 'Corresponding author')) NOT NULL,  
      
    CONSTRAINT author_pk PRIMARY KEY (systemUserId, publicationId, TypeOfAuthor),  
    FOREIGN KEY (systemUserId) REFERENCES systemUser,  
    FOREIGN KEY (publicationId) REFERENCES publication  
);


/* The below DDL statement shows a table created for publication subject and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE PublicationSubject(  
    publicationId NUMBER (10) NOT NULL,  
    subjectName VARCHAR (50) NOT NULL,  
  
    CONSTRAINT publicationSubject_pk PRIMARY KEY (publicationId, subjectName),  
    FOREIGN KEY (publicationId) REFERENCES publication,  
    FOREIGN KEY (subjectName) REFERENCES subject  
);


/* The below DDL statement shows a table created for Conference Proceeding Paper and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE ConferenceProceedingPaper ( 
    publicationId NUMBER (10) NOT NULL, 
    conferenceTitle VARCHAR (100) NOT NULL, 
 
    PRIMARY KEY (publicationId), 
    FOREIGN KEY (publicationId) REFERENCES publication 
);


/* The below DDL statement shows a table created for Thesis and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE Thesis ( 
    publicationId NUMBER (10) NOT NULL, 
    TypeOfThesis VARCHAR (20) NOT NULL, 
    Institution VARCHAR (50) NOT NULL, 
 
    PRIMARY KEY (publicationId), 
    FOREIGN KEY (publicationId) REFERENCES publication 
);


/* The below DDL statement shows a table created for Article and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE Article ( 
    publicationId NUMBER (10) NOT NULL, 
    journalName VARCHAR (100) NOT NULL, 
    issueNumber NUMBER (3) NOT NULL, 
 
    PRIMARY KEY (publicationId), 
    FOREIGN KEY (publicationId) REFERENCES publication 
);


/* The below DDL statement shows a table created for Book and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE BOOK ( 
    publicationId NUMBER (10) NOT NULL, 
    seriesTitle VARCHAR (100), 
    seriesNumber NUMBER (3), 
    edition NUMBER (3) NOT NULL, 
 
    PRIMARY KEY (publicationId), 
    FOREIGN KEY (publicationId) REFERENCES publication 
);

/* The below DDL statement shows a table created for user libaray and all the attributes and constraints as as specified in the phyiscal database design */

CREATE TABLE UserLibrary (  
    systemUserId NUMBER (10) NOT NULL,  
    publicationId NUMBER (10) NOT NULL,  
    viewDate DATE DEFAULT CURRENT_DATE NOT NULL,  
    viewTime VARCHAR (20) NOT NULL,  
    reviewScore NUMBER (2),  
    reviewContent VARCHAR(8000),  
  
    CONSTRAINT userLibrary_pk PRIMARY KEY (systemUserId, publicationId, viewDate, viewTime),  
    FOREIGN KEY (systemUserId) REFERENCES systemUser,  
    FOREIGN KEY (publicationId) REFERENCES publication  
);


/* The below DML statement shows dummy data being inserted into system user table*/

INSERT INTO systemUser (firstname,lastname, password, email, contactpreference, Usertype) 
Values ('Usman', 'Ali','UI123UI!', 'Aliu909@hotmail.com', 'Email', 'Both');

INSERT INTO systemUser (firstname,lastname, password, email, contactpreference, Usertype) 
Values ('Sam', 'Smith','SM123SM!', 'Smith912909@hotmail.com', 'Phone number', 'Author');

INSERT INTO systemUser (firstname,lastname, password, email, contactpreference, Usertype) 
Values ('Aidan', 'Bowater','AB123AB!', 'AidanA9@hotmail.com', 'Email', 'Author');

INSERT INTO systemUser (firstname,lastname, password, email, contactpreference, Usertype) 
Values ('Anthony','Hall','AH369AH!', 'AnthonyHall@hotmail.com', 'Phone number', 'Author');

INSERT INTO systemUser (firstname,lastname, password, email, contactpreference, Usertype) 
Values ('Kim', 'Fox','Kf123KF!', 'KF0@hotmail.com', 'Email', 'Reader');

/* The below DML statement shows dummy data being inserted into Phone Number table*/

INSERT INTO PhoneNumber 
Values (1, '07368632901');

INSERT INTO PhoneNumber 
Values (2, '07575130841');

INSERT INTO PhoneNumber 
Values (3, '07984043128');

INSERT INTO PhoneNumber 
Values (3, '07967325671');

INSERT INTO PhoneNumber 
Values (4, '07864102433');

INSERT INTO PhoneNumber 
Values (5, '07866543211');

/* The below DML statement shows dummy data being inserted into author review table*/

INSERT INTO authorReview  
Values (3, 1, 5, 'Amazing and gifted Author!');

INSERT INTO authorReview  
Values (5, 4, 3, 'Decent Author, but not always clear');

INSERT INTO authorReview  
Values (4, 3, 1, 'Poor work - biased work');

/* The below DML statement shows dummy data being inserted into subject table*/

INSERT INTO subject (subjectName) 
Values ('Artificial Intelligence');

INSERT INTO subject (subjectName) 
Values ('Database Systems');

INSERT INTO subject (subjectName) 
Values ('Human Computer Interaction');

INSERT INTO subject (subjectName) 
Values ('Data Mining');

INSERT INTO subject (subjectName) 
Values ('Histopathology');

INSERT INTO subject (subjectName) 
Values ('Immunology');

/* The below DML statement shows dummy data being inserted into userInterest table*/

INSERT INTO userInterest 
Values (1, 'Artificial Intelligence');

INSERT INTO userInterest 
Values (1, 'Data Mining');

INSERT INTO userInterest 
Values (2, 'Histopathology');

INSERT INTO userInterest 
Values (2, 'Immunology');

INSERT INTO userInterest 
Values (3, 'Data Mining');

INSERT INTO userInterest 
Values (4, 'Immunology');

INSERT INTO userInterest 
Values (5, 'Human Computer Interaction');

INSERT INTO userInterest 
Values (5, 'Artificial Intelligence');

/* The below DML statement shows dummy data being inserted into the publisher table*/

INSERT INTO publisher (publisherName, location) 
VALUES ('Birmingham Public Press', 'Birmingham');

INSERT INTO publisher (publisherName, location) 
VALUES ('Publication Press', 'London');

INSERT INTO publisher (publisherName, location) 
VALUES ('London Open Press', 'London');

/* The below DML statement shows dummy data being inserted into the publication table*/

INSERT INTO publication (publicationId,Title,Editors, hyperlink, publicationType, abstract, publicationDate, pageNumbers, publisherId) 
Values (1,'Database Systems', 'James Colley, Edward Gale','https://www.viewbooks.com/search/definition/Database Systems', 'Book','This book protrays fundamental concepts needed for Databases, designing and implementing them in a DBMS. Covering topics such as relational databases, business intellegence and NOSQL.','04-APR-2019', '300', 1);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (2, 'Machine Learning for Data Mining', 'Anthony Blake, Jordan Gale','https://www.viewbooks.com/search/definition/MachineLearningforDataMining', 'Book','This book portrays fundamental concepts needed for Data mining using Machine Learning techniques. Covering topics such as the fundamentals of using data mining techniques to extract data for business Intelligence.', 2,'05-JAN-2015', '800', 2);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (3, 'Human Computer Interaction Desgin', 'Sam Blake, Henry Gale','https://www.viewbooks.com/search/definition/HCIDesign', 'Book','This book protrays fundamental concepts needed for designing a usable User Interface. Covering topics such as Know Elicitation, prototype designing and Evaluation of prototypes.',1 ,'05-JAN-2015', '800', 3);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (4, 'Improving Histolopathology pratice with Database Systems', 'Aidan Ward, Thomas clay, James Hall','https://www.viewarticles.com/search/definition/HistologyDatabaseSystmes', 'Article','This article portrays fundamental concepts used in Histopathology and how the use of a Laboratory Information system improves quality management and control. The scope of this article includes H&E, special stains, Microscopy and the database management system used in Histology.', 1,'09-JAN-2016', '117 - 130', 1);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (5,'Use of Immunologial techniques in histology', 'Ray Blake, Ali Hussain','https://www.viewarticles.com/search/definition/immunologyInHistology', 'Article','This article protrays fundamental concepts used in Histopathology and how Immunological techniques can lead to faster diagnosis of disease. The scope of this article includes immunological agents that can aid in the diagnosis of tissue samples from patients.', 3 ,'19-MAY-2009', '90 - 99', 2);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (6, 'Machine Learning in Immunology diagnosis', 'Anthony Steadman, Sam Lake, Anthony Ward','https://www.viewarticles.com/search/definition/MachineLearningforDataMining', 'Article','This article looks at Immunology diagnosis using Machine Learning. The scope of this article includes the use of machine learning algorithms to diagnose immunological results.',1 ,'05-DEC-2015', '12 - 35', 3);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (7,'Effect practices of Data Mining', 'Mike Brown, Jordan Reed','https://www.viewthesis.com/search/definition/DataMining', 'Thesis','This Thesis protrays fundamental concepts needed for Data mining. Covering topics such as fundamentals of using data Mining techniques to extract data for business Intelligence.', 1,'13-AUG-2020', '65', 1);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (8, 'Histology Practices', 'Shane Blake, Reece Gale','https://www.viewthesis.com/search/definition/MachineLearningforDataMining', 'Thesis','This Thesis portrays fundamental concepts needed to preform histological examination in pathology. Covering topics such as tissue fixation, tissue examination, tissue processing and use of staining.',5 ,'23-FEB-2018', '80', 2);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (9, 'Immunology practices', 'Kameron Hussain, Abdullah Asif, Jordan Hall','https://www.viewthesis.com/search/definition/MachineLearningforDataMining', 'Thesis','This Thesis portrays fundamental concepts needed for immunological techniques. Covering topics such as ELISA and fluorescence immunoassays.',1 ,'18-APR-2014', '80', 3);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (10, 'Overview of Machine Learning approaches', 'Gale Khaleesi, Peter Parker','https://www.viewconference.com/search/definition/Machinelearningapproaches', 'Conference Proceeding Paper','This conference proceeding paper portrays fundamental concepts needed for advanced Machine Learning techniques in a wide range of applications. Covering topics such as the advanced use of AI techniques.',3 ,'08-JAN-2018', '15', 2);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (11, 'HCI approaches for Database systems', 'Dean Gale, Sam Gale','https://www.viewconference.com/search/definition/HCIForDatabases', 'Conference Proceeding Paper','This conference proceeding paper portrays fundamental concepts needed for designing a usable UI for backend databases. Covering topics such as fundamentals of Usability design specifically for databases applications.',1,'10-MAY-2022', '13', 3);

INSERT INTO publication (publicationId, Title,Editors, hyperlink, publicationType, abstract, volumeNumber, publicationDate, pageNumbers, publisherId) 
Values (12,'Overview of Relational database normalisation', 'Kaley Pale, John Cena','https://www.viewconference.com/search/definition/Normalisation','Conference Proceeding Paper','This conference proceeding paper portrays fundamental concepts needed for normalisation and even delves into the 6NF. Covering topics such as functional dependencies and normal forms.',2 ,'03-JAN-2011', '10', 3);



/* The below statements are used to create indexes for the publication Title and publication type as they may be commonly used criteria to search for publications and another index was created for the FK Publisher ID in the publication table as this commonly used in a join - this is done to speed up preformance of data retrieval and it is good practice to create these before the dummy data is inserted*/

CREATE INDEX publicationTitle_index ON publication (title);

CREATE INDEX publicationType_index ON publication (publicationType);

CREATE INDEX publicationFK_index ON publication (publisherID);

/* The below statements are used to create views - these are views on data that allow faster retrival of data as the virtual table produced would normally require a select statement with joins - it is good practice to create these before the dummy data is inserted*/

CREATE VIEW ConferencePaper_RefInfo AS SELECT P.PUBLICATIONID,TITLE, EDITORS, HYPERLINK, PUBLICATIONTYPE, ABSTRACT, VOLUMENUMBER, PUBLICATIONDATE, PAGENUMBERS, CONFERENCETITLE, U.PUBLISHERID, PUBLISHERNAME, LOCATION  
    FROM publication p, ConferenceProceedingPaper c, publisher u 
    WHERE p.publicationID = c.publicationId AND p.publisherID = u.publisherID;

CREATE VIEW Article_RefInfo AS SELECT P.PUBLICATIONID,TITLE, EDITORS, HYPERLINK, PUBLICATIONTYPE, ABSTRACT, VOLUMENUMBER, PUBLICATIONDATE, PAGENUMBERS, JOURNALNAME, ISSUENUMBER, U.PUBLISHERID, PUBLISHERNAME, LOCATION  
    FROM publication p, Article a, publisher u 
    WHERE p.publicationID = a.publicationId AND p.publisherID = u.publisherID;

CREATE VIEW Thesis_RefInfo AS SELECT P.PUBLICATIONID,TITLE, EDITORS, HYPERLINK, PUBLICATIONTYPE, ABSTRACT, VOLUMENUMBER, PUBLICATIONDATE, PAGENUMBERS,TYPEOFTHESIS, INSTITUTION, U.PUBLISHERID, PUBLISHERNAME, LOCATION  
    FROM publication p, Thesis t, publisher u 
    WHERE p.publicationID = t.publicationID AND p.publisherID = u.publisherID;

CREATE VIEW Book_RefInfo AS SELECT P.PUBLICATIONID,TITLE, EDITORS, HYPERLINK, PUBLICATIONTYPE, ABSTRACT, VOLUMENUMBER, PUBLICATIONDATE, PAGENUMBERS,SERIESTITLE, SERIESNUMBER, EDITION, U.PUBLISHERID, PUBLISHERNAME, LOCATION  
    FROM publication p, book b, publisher u 
    WHERE p.publicationID = b.publicationID AND p.publisherID = u.publisherID;

CREATE VIEW AVG_ScoreOfItems AS SELECT PublicationID, AVG (reviewScore) as Avg_ScoreOfItem FROM UserLibrary 
    GROUP BY publicationID;



/* The below DML statement shows dummy data being inserted into Author*/

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1, 1, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3, 1, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1, 1, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1, 2, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3, 2, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3, 2, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2, 3, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1, 3, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1, 3, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2, 4, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4 , 4, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values(2 , 4, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values(2, 5, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1 , 5, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2 , 5, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3 , 6, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4 , 6, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1 , 6, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3, 7, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4 , 7, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3 , 7, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1 , 8, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3 , 8, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1 , 8, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2 , 9, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3, 9, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2 , 9, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2 , 10, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4, 10, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4 , 10, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3 , 11, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (1 , 11, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (3 , 11, 'Corresponding author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4 , 12, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (2, 12, 'Co-author');

INSERT INTO Author (systemUserId, publicationId, TypeOfAuthor)  
Values (4 , 12, 'Corresponding author');

/* The below DML statement shows dummy data being inserted into Publication Subject*/

INSERT INTO PublicationSubject  
Values (1, 'Database Systems');

INSERT INTO PublicationSubject  
Values (2, 'Artificial Intelligence');

INSERT INTO PublicationSubject  
Values (2, 'Data Mining');

INSERT INTO PublicationSubject  
Values (3, 'Human Computer Interaction');

INSERT INTO PublicationSubject  
Values (4, 'Histopathology');

INSERT INTO PublicationSubject  
Values (4, 'Database Systems');

INSERT INTO PublicationSubject  
Values (5, 'Immunology');

INSERT INTO PublicationSubject  
Values (5, 'Histopathology');

INSERT INTO PublicationSubject  
Values (6, 'Immunology');

INSERT INTO PublicationSubject  
Values (6, 'Artificial Intelligence');

INSERT INTO PublicationSubject  
Values (7, 'Data Mining');

INSERT INTO PublicationSubject  
Values (8, 'Histopathology');

INSERT INTO PublicationSubject  
Values (9, 'Immunology');

INSERT INTO PublicationSubject  
Values (11, 'Human Computer Interaction');

INSERT INTO PublicationSubject  
Values (11,'Database Systems');

INSERT INTO PublicationSubject  
Values (12, 'Database Systems');

INSERT INTO PublicationSubject  
Values (10, 'Artificial Intelligence');

/* The below DML statement shows dummy data being inserted into Conference Proceeding Paper table*/

INSERT INTO ConferenceProceedingPaper   
Values (10, 'Artifical Express');

INSERT INTO ConferenceProceedingPaper   
Values (11, 'Usability Express');

INSERT INTO ConferenceProceedingPaper   
Values (12, 'Database Express');

/* The below DML statement shows dummy data being inserted into Thesis table*/

INSERT INTO Thesis  
Values (7, 'PhD', 'Aston University');

INSERT INTO Thesis  
Values (8, 'PhD', 'Aston University');

INSERT INTO Thesis  
Values (9, 'PhD', 'Aston University');

/* The below DML statement shows dummy data being inserted into Article table*/

INSERT INTO Article  
Values (4, 'Pathology UK', 3);

INSERT INTO Article  
Values (5, 'Pathology UK', 5);

INSERT INTO Article  
Values (6, 'AIPathology', 3);

/* The below DML statement shows dummy data being inserted into Book table*/

INSERT INTO Book (publicationId, edition)  
Values (1, 10);

INSERT INTO Book   
Values (2,'AI for Data Mining',5 , 10);

INSERT INTO Book   
Values (3, 'HCI for Application Design',3 ,10);

/* The below DML statement shows dummy data being inserted into User Library table*/

INSERT INTO UserLibrary (systemUserId, publicationID,viewTime, reviewScore, reviewContent) 
Values (1,1, '12:26:12', '5', 'Excellent and detailed publication.');

INSERT INTO UserLibrary (systemUserId, publicationID,viewTime)  
Values (1,1, '13:50:09');

INSERT INTO UserLibrary (systemUserId, publicationID,viewTime) 
Values (1,1, '19:30:15');

INSERT INTO UserLibrary (systemUserId, publicationID,viewTime, reviewScore, reviewContent)  
Values (1,12, '21:30:52', '3', 'Good Papar!');




/* This query create a list of reviews*/
SELECT publicationID, reviewScore, reviewContent FROM USERlibrary
    WHERE reviewContent IS NOT NULL
    ORDER BY publicationID;

/* retrieving Reference information for Conference proceeding papers from view*/
SELECT * FROM ConferencePaper_RefInfo;

/* retrieving Reference information for Articles view*/
SELECT * FROM Article_RefInfo;

/*retrieving Reference information for Thesis view*/

SELECT * FROM Thesis_RefInfo;

/*retrieving Reference information for Book from view */
SELECT * FROM Book_RefInfo;

/* Please note that the below SQL statements are designed to retrieve the data weights used in this example is as follows 
 W1 = 0.1, W2 = 0.1, W3 = 0.2, W4 =0.3, W5 = 0.3 */


/* (1) SQL statments to find the average score and threshold - if the average score is over thresold then it will be mutipled by W1*/
SELECT 0.1 * (SELECT AVG_ScoreOfItem FROM Avg_scoreOfItems
    WHERE avg_scoreOfItem > (SELECT AVG (reviewScore) as Threshold FROM userLibrary)) AS Weight1
    FROM DUAL;

-- the inner most select query detemines the threhold value 
-- the the middle select queuy determines if the avgerage score is above the threshold
-- the outer most select query times the the averageScore (if above the thresold) with W1 (0.1)

/* (2) The following will check will where the user subject interest is the same as the publication subject
The SELECT * FROM statement first identifies all the subjects of the item the system wants to recommend (in this example the 
Item has publicationID = 4) and then compares it to the subjects that the user is interested in (in this example, the user is systemUserId = 2)
The outer count statment then counts all the subjects that the user is interested that overlap with the subjects of the item the system wants to recommend - forming the subject-specific score*/

SELECT 0.1 * (SELECT Count (publicationID) AS Subject_Specific_Items FROM (SELECT * FROM PublicationSubject p WHERE publicationID = 4  AND p.subjectName 
    IN (SELECT u.subjectName FROM UserInterest u WHERE systemUserID = 2))) AS Weight2
    FROM DUAL;
-- the outermost select statement works out weight 2 by multiplying the subject-specific score with W2

/* (3)count  Number of a user's co-auther that appear in item's author's list  - this step is only included in the alogrithm if the user is an author (or author and reader) but it is not inclueded if they are just a reader */

/* The with statement below is used to work out the number of co-author's that appear in the item's author list.
In the example below, the user the item will be recommonded to is systemuserId =1 and the item that the system is trying to recommend is publictionID =1*/

SELECT 0.2 * (WITH CoAuthor_List AS (SELECT DISTINCT systemUserId FROM author 
    WHERE publicationID IN (SELECT publicationID FROM Author WHERE TypeOfAuthor = 'Co-author' and systemuserID = 1) AND systemUserID != 1),

    Item_Author AS (SELECT systemUserId FROM author WHERE publicationID = 1 and TypeOfAuthor = 'Co-author')

    SELECT COUNT (c.systemUserID) AS NO_OF_COAUTHORS FROM coAuthor_List c, Item_Author i
    WHERE c.systemUserId = i.systemUserID) AS WEIGHT3
    FROM DUAL;

/* CoAuthor_list identifies the list of co-auther that the systemUser has (the systemuser (ID =1) is not included in this list)
The Item-author list identifies the all the authors from the item (publicationID = 1) we want the system to recommend

The main query (in the with statment) then find where the User's co-authers are eqaul the item's authors (and the counts them)
This can then be multiplied BY W3 by the outermost statement)*/

/* the below statement finds all the items that the user has already read */
SELECT * FROM userLibrary; 

/* (4) from user's library, count items that share at least one author with item recommended
In this example, the user the syetem is considering to recommend the item to is systemUserID = 1 
and the item we want the system to recommend to the user is publicationID = 6 */



SELECT 0.3 * (SELECT COUNT (publicationID) AS Matching_Author_ITEMS FROM
(SELECT DISTINCT b.systemUserID, u.publicationID from userlibrary u, publication p, author b
WHERE u.publicationID = p.publicationID AND b.publicationID = p.publicationID AND u.systemUserID = 1 -- the u.systemUserID = 1 is looking at the userlibrary of systemUser 1
    AND  b.SystemUserID IN (SELECT a.systemUserID From author a WHERE typeOfAuthor ='Co-author' AND publicationID = 6))) AS WEIGHT4
    FROM DUAL;

/* The select Distinct statment is finding all the authors of the publications that exist in the user's library 
(in this case the user is u.systemUserId = 1) The next statement then check if the authors (form publications in the user's library)
are IN the list of authors for the recommneded item (this is the result second subquery - that selects a.systemUserID)
Then, the outer select counts (aggregate funtion) the number of items where the item's authors matches with (at least one of) the authors of the publications in the user's library
Lastly the outermost select statement muliplies the value by W4*/


/*(5) From Matching subject - in this example the item to be recommended has a publicationID of 7
The SELECT DISTINCT statement is identifies the subject of the publications in the user's library 
The The seconds part checks if the subjectName of at leasts one publication macthes the subject of the item that is to be recommneded
The outer count statement then counts the number of items (in the user library) that have the same subject as the item to be recommended*/

SELECT 0.3 * (SELECT COUNT (publicationID) AS Matching_Subject_Items FROM
(SELECT DISTINCT u.publicationID, s.subjectname FROM userlibrary u, publication p, PublicationSubject s
WHERE u.publicationID = p.publicationID AND p.publicationID = s.publicationID
AND s.subjectName IN (SELECT i.SubjectName FROM publicationSubject i WHERE publicationID = 4))) AS WEIGHT5 
FROM DUAL;

/* The WITH statement below then give the overall score of the algorithm for a user that is an author and reader
The structure of this enquiry is as follows 
SELECT (w1 * Query1) + (W2 * Query2) + (W3 * Query3) + (W4 * Query4) + (W5 * Query5) FROM DUAL;
The queries are the statements as described above*/

SELECT (SELECT 0.1 * (SELECT AVG_ScoreOfItem FROM Avg_scoreOfItems
    WHERE avg_scoreOfItem > (SELECT AVG (reviewScore) as Threshold FROM userLibrary)) AS Weight
    FROM DUAL) 
    + (SELECT 0.1 * (SELECT Count (publicationID) AS Subject_Specific_Items FROM (SELECT * FROM PublicationSubject p WHERE publicationID = 4  AND p.subjectName 
    IN (SELECT u.subjectName FROM UserInterest u WHERE systemUserID = 2))) AS Weight
    FROM DUAL) 
    + (SELECT 0.2 * (WITH CoAuthor_List AS (SELECT DISTINCT systemUserId FROM author 
    WHERE publicationID IN (SELECT publicationID FROM Author WHERE TypeOfAuthor = 'Co-author' and systemuserID = 1) AND systemUserID != 1),

    Item_Author AS (SELECT systemUserId FROM author WHERE publicationID = 1 and TypeOfAuthor = 'Co-author')

    SELECT COUNT (c.systemUserID) AS NO_OF_COAUTHORS FROM coAuthor_List c, Item_Author i
    WHERE c.systemUserId = i.systemUserID) AS WEIGHT3
    FROM DUAL) 
    + (SELECT 0.3 * (SELECT COUNT (publicationID) AS Matching_Author_ITEMS FROM
    (SELECT DISTINCT b.systemUserID, u.publicationID from userlibrary u, publication p, author b
    WHERE u.publicationID = p.publicationID AND b.publicationID = p.publicationID AND u.systemUserID = 1 -- the u.systemUserID = 1 is looking at the userlibrary of systemUser 1
    AND  b.SystemUserID IN (SELECT a.systemUserID From author a WHERE typeOfAuthor ='Co-author' AND publicationID = 6))) AS WEIGHT
    FROM DUAL) + (SELECT 0.3 * (SELECT COUNT (publicationID) AS Matching_Subject_Items FROM
    (SELECT DISTINCT u.publicationID, s.subjectname FROM userlibrary u, publication p, PublicationSubject s
    WHERE u.publicationID = p.publicationID AND p.publicationID = s.publicationID
    AND s.subjectName IN (SELECT i.SubjectName FROM publicationSubject i WHERE publicationID = 4))) AS WEIGHT
    FROM DUAL) AS Recommended_Score
    FROM DUAL;


/* The WITH statement below then give the overall score of the algorithm for a user who is just a reader - 
as they will not have Query 3 - as they have no co-authors*/

WITH W1 AS (SELECT 0.1 * (SELECT AVG_ScoreOfItem FROM Avg_scoreOfItems
    WHERE avg_scoreOfItem > (SELECT AVG (reviewScore) as Threshold FROM userLibrary)) AS Weight
    FROM DUAL),
    
    W2 AS (SELECT 0.1 * (SELECT Count (publicationID) AS Subject_Specific_Items FROM (SELECT * FROM PublicationSubject p WHERE publicationID = 4  AND p.subjectName 
    IN (SELECT u.subjectName FROM UserInterest u WHERE systemUserID = 2))) AS Weight
    FROM DUAL),

    W4 AS (SELECT 0.3 * (SELECT COUNT (publicationID) AS Matching_Author_ITEMS FROM
    (SELECT DISTINCT b.systemUserID, u.publicationID from userlibrary u, publication p, author b
    WHERE u.publicationID = p.publicationID AND b.publicationID = p.publicationID AND u.systemUserID = 1 -- the u.systemUserID = 1 is looking at the userlibrary of systemUser 1
    AND  b.SystemUserID IN (SELECT a.systemUserID From author a WHERE typeOfAuthor ='Co-author' AND publicationID = 6))) AS WEIGHT
    FROM DUAL),

    W5 AS (SELECT 0.3 * (SELECT COUNT (publicationID) AS Matching_Subject_Items FROM
    (SELECT DISTINCT u.publicationID, s.subjectname FROM userlibrary u, publication p, PublicationSubject s
    WHERE u.publicationID = p.publicationID AND p.publicationID = s.publicationID
    AND s.subjectName IN (SELECT i.SubjectName FROM publicationSubject i WHERE publicationID = 4))) AS WEIGHT
    FROM DUAL)


SELECT w1.weight + w2.weight + w4.weight + w5.weight AS Recommended_Score FROM w1, w2, w4, w5;

