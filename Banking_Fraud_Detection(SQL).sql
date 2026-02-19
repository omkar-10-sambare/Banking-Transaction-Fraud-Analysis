create database Banking_fraud;
use banking_fraud;
show databases;
show tables;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    phone       VARCHAR(15) UNIQUE,
    email       VARCHAR(100) UNIQUE,
    city        VARCHAR(50),
    risk_score  INT CHECK (risk_score BETWEEN 0 AND 100)
);
INSERT INTO customers (customer_id, full_name, phone, email, city, risk_score) VALUES
(1, 'Amit Sharma', '9876543210', 'amit.sharma@gmail.com', 'Mumbai', 25),
(2, 'Neha Verma', '9123456780', 'neha.verma@gmail.com', 'Delhi', 55),
(3, 'Rohit Mehta', '9988776655', 'rohit.mehta@gmail.com', 'Bangalore', 40),
(4, 'Priya Singh', '9090909090', 'priya.singh@gmail.com', 'Chennai', 70),
(5, 'Karan Patel', '9012345678', 'karan.patel@gmail.com', 'Ahmedabad', 35),
(6, 'Sneha Joshi', '9345678123', 'sneha.joshi@gmail.com', 'Pune', 60),
(7, 'Vikram Rao', '9765432109', 'vikram.rao@gmail.com', 'Hyderabad', 45),
(8, 'Anjali Gupta', '9898989898', 'anjali.gupta@gmail.com', 'Kolkata', 80),
(9, 'Suresh Kumar', '9555666777', 'suresh.kumar@gmail.com', 'Jaipur', 30),
(10,'Meera Nair', '9444555666', 'meera.nair@gmail.com', 'Kochi', 65);

select * from customers;

CREATE TABLE accounts (
    account_id   INT PRIMARY KEY,
    customer_id  INT NOT NULL,
    account_type VARCHAR(20) CHECK (account_type IN ('Savings','Current')),
    opened_date  DATE,
    status       VARCHAR(20) CHECK (status IN ('Active','Closed')),
    balance      DECIMAL(12,2) DEFAULT 0,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO accounts (account_id, customer_id, account_type, opened_date, status, balance) VALUES
(101, 1, 'Savings', '2022-01-10', 'Active', 55000),
(102, 2, 'Current', '2021-08-05', 'Active', 120000),
(103, 3, 'Savings', '2020-11-20', 'Active', 75000),
(104, 4, 'Savings', '2019-03-15', 'Active', 20000),
(105, 5, 'Current', '2023-06-01', 'Active', 500000),
(106, 6, 'Savings', '2022-09-12', 'Active', 15000),
(107, 7, 'Savings', '2021-02-18', 'Active', 98000),
(108, 8, 'Current', '2020-05-30', 'Active', 670000),
(109, 9, 'Savings', '2023-01-25', 'Active', 34000),
(110, 10,'Savings', '2018-12-11', 'Closed', 0);

select * from accounts;

CREATE TABLE merchants (
    merchant_id   INT PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    risk_level    VARCHAR(20) CHECK (risk_level IN ('Low','Medium','High'))
);

INSERT INTO merchants (merchant_id, merchant_name, category, risk_level) VALUES
(201, 'Amazon', 'Shopping', 'Low'),
(202, 'Flipkart', 'Shopping', 'Low'),
(203, 'Swiggy', 'Food', 'Low'),
(204, 'Zomato', 'Food', 'Low'),
(205, 'IRCTC', 'Travel', 'Medium'),
(206, 'MakeMyTrip', 'Travel', 'Medium'),
(207, 'CryptoXChange', 'Crypto', 'High'),
(208, 'FastLoanApp', 'Loan', 'High'),
(209, 'PetrolPump-HP', 'Fuel', 'Medium'),
(210, 'LuxuryStore', 'Shopping', 'High');

select * from merchants;

CREATE TABLE transactions (
    txn_id        INT PRIMARY KEY,
    account_id    INT NOT NULL,
    txn_date      TIMESTAMP NOT NULL,
    amount        DECIMAL(12,2) NOT NULL,
    txn_type      VARCHAR(10) CHECK (txn_type IN ('Debit','Credit')),
    channel       VARCHAR(20) CHECK (channel IN ('ATM','UPI','CARD','NETBANK')),
    merchant_id   INT,
    location_city VARCHAR(50),
    device_id     VARCHAR(50),
	FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

INSERT INTO transactions (txn_id, account_id, txn_date, amount, txn_type, channel, merchant_id, location_city, device_id) VALUES
(301, 101, '2025-01-05 10:15:00', 2500,   'Debit', 'UPI',     203, 'Mumbai',    'DEV001'),
(302, 102, '2025-01-05 12:45:00', 75000,  'Debit', 'NETBANK', 205, 'Delhi',     'DEV002'),
(303, 103, '2025-01-06 09:10:00', 1500,   'Debit', 'CARD',    204, 'Bangalore', 'DEV003'),
(304, 104, '2025-01-06 20:20:00', 98000,  'Debit', 'CARD',    210, 'Chennai',   'DEV004'),
(305, 105, '2025-01-07 11:00:00', 250000, 'Debit', 'NETBANK', 207, 'Ahmedabad', 'DEV005'),
(306, 106, '2025-01-07 18:30:00', 5000,   'Debit', 'ATM',     209, 'Pune',      'DEV006'),
(307, 107, '2025-01-08 08:10:00', 12000,  'Debit', 'UPI',     201, 'Hyderabad', 'DEV007'),
(308, 108, '2025-01-08 22:05:00', 350000, 'Debit', 'NETBANK', 208, 'Kolkata',   'DEV008'),
(309, 109, '2025-01-09 14:55:00', 4000,   'Debit', 'UPI',     203, 'Jaipur',    'DEV009'),
(310, 101, '2025-01-09 23:59:00', 90000,  'Debit', 'CARD',    207, 'Goa',       'DEV010');

select * from transactions;

CREATE TABLE fraud_cases (
    case_id       INT PRIMARY KEY,
    txn_id        INT NOT NULL,
    fraud_flag    BOOLEAN NOT NULL,
    fraud_type    VARCHAR(50),
    reported_date DATE,
    status        VARCHAR(20) CHECK (status IN ('Open','Closed','Investigating')),
	FOREIGN KEY (txn_id) REFERENCES transactions(txn_id)
);

INSERT INTO fraud_cases (case_id, txn_id, fraud_flag, fraud_type, reported_date, status) VALUES
(401, 301, FALSE, NULL,            NULL,        'Closed'),
(402, 302, FALSE, NULL,            NULL,        'Closed'),
(403, 303, FALSE, NULL,            NULL,        'Closed'),
(404, 304, TRUE,  'Card Skimming', '2025-01-07','Investigating'),
(405, 305, TRUE,  'Crypto Scam',   '2025-01-08','Open'),
(406, 306, FALSE, NULL,            NULL,        'Closed'),
(407, 307, FALSE, NULL,            NULL,        'Closed'),
(408, 308, TRUE,  'Loan App Fraud','2025-01-09','Open'),
(409, 309, FALSE, NULL,            NULL,        'Closed'),
(410, 310, TRUE,  'Phishing',      '2025-01-10','Investigating');

select * from fraud_cases;

SELECT c.full_name, a.account_id, a.account_type, a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;



