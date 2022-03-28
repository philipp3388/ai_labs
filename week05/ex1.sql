CREATE TABLE ShippingAddresses (
  addressID INT NOT NULL,
  PRIMARY KEY (addressID),
  house INT,
  street VARCHAR(255),
  district VARCHAR(255),
  city VARCHAR(255)
);

CREATE TABLE Customer (
  clientID INT NOT NULL,
  PRIMARY KEY (clientID),
  balance INT,
  creditLimit INT,
  discount INT,
  addresses INT NOT NULL,
  FOREIGN KEY (addresses) REFERENCES ShippingAddresses(addressID)
);

CREATE TABLE _Order (
  orderID INT NOT NULL,
  PRIMARY KEY (orderID),
  _date DATETIME,
  addresses INT NOT NULL,
  FOREIGN KEY (addresses) REFERENCES ShippingAddresses(addressID)
);

CREATE TABLE PlaceA (
  orderID INT,
  FOREIGN KEY (orderID) REFERENCES _Order(orderID),
  customers INT,
  FOREIGN KEY (customers) REFERENCES Customer(clientID)
);

CREATE TABLE Item (
  itemID INT NOT NULL,
  PRIMARY KEY (itemID),
  description VARCHAR(255)
);

CREATE TABLE Includes (
  orderID INT,
  FOREIGN KEY (orderID) REFERENCES _Order(orderID),
  items INT,
  FOREIGN KEY (items) REFERENCES Item(itemID),
  quantity INT
);

CREATE TABLE Manufacturer (
  manufacturerID INT NOT NULL,
  PRIMARY KEY (manufacturerID),
  phonenumber VARCHAR(255)
);

CREATE TABLE Produce (
  items INT NOT NULL,
  FOREIGN KEY (items) REFERENCES Item(itemID),
  manufacturers INT,
  FOREIGN KEY (manufacturers) REFERENCES Manufacturer(manufacturerID),
  quantity INT
);
