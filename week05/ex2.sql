CREATE TABLE _Group (
  groupID NUMERIC NOT NULL PRIMARY KEY
);

CREATE TABLE Company (
  companyID NUMERIC NOT NULL PRIMARY KEY
);

CREATE TABLE HasCompany (
  groupID NUMERIC NOT NULL,
  FOREIGN KEY (groupID) REFERENCES _Group(groupID),
  companies NUMERIC REFERENCES Company
);

CREATE TABLE Structure (
  headCompany NUMERIC NOT NULL,
  FOREIGN KEY (headCompany) REFERENCES Company(companyID),
  companies NUMERIC REFERENCES Company
);

CREATE TABLE Plant (
  plantID NUMERIC NOT NULL PRIMARY KEY
);

CREATE TABLE HasPlant (
  companyID NUMERIC NOT NULL,
  FOREIGN KEY (companyID) REFERENCES Company(companyID),
  plants NUMERIC REFERENCES Plant  
);

CREATE TABLE Item (
  itemID NUMERIC NOT NULL PRIMARY KEY
);

CREATE TABLE Produces (
  plantID NUMERIC NOT NULL,
  FOREIGN KEY (plantID) REFERENCES Plant(plantID),
  items NUMERIC REFERENCES Item  
)
