
CREATE TABLE customer_accounts (
    AccountNumber BIGINT PRIMARY KEY,
    AccountHolder VARCHAR(100),
    AccountType VARCHAR(50),
    Balance DECIMAL(15,2),
    InterestRate DECIMAL(5,2),
    CreditScore INT,
    OpeningDate DATE,
    LoanAmount DECIMAL(15,2),
    AccountHolderDetails TEXT
);

CREATE TABLE transactions (
    TransactionID INT PRIMARY KEY,
    AccountNumber BIGINT,
    TransactionType VARCHAR(50),
    Amount DECIMAL(15,2),
    TransactionDate DATE,
    BranchCode INT,
    Currency VARCHAR(10),
    TransactionTime INT,
    FOREIGN KEY (AccountNumber) REFERENCES customer_accounts(AccountNumber)
);

-- 1. Total number of customers
SELECT COUNT(*) AS total_customers FROM customer_accounts;

-- 2. Average balance across all customers
SELECT AVG(Balance) AS avg_balance FROM customer_accounts;

-- 3. Total loan amount issued
SELECT SUM(LoanAmount) AS total_loans FROM customer_accounts;

-- 4. Average credit score by account type
SELECT AccountType, AVG(CreditScore) AS avg_credit_score FROM customer_accounts GROUP BY AccountType;

-- 5. Top 10 customers by account balance
SELECT AccountHolder, Balance FROM customer_accounts ORDER BY Balance DESC LIMIT 10;

-- 6. Number of transactions per account type
SELECT ca.AccountType, COUNT(t.TransactionID) AS total_txns
FROM transactions t JOIN customer_accounts ca USING(AccountNumber)
GROUP BY ca.AccountType;

-- 7. Most frequent transaction type
SELECT TransactionType, COUNT(*) AS freq
FROM transactions
GROUP BY TransactionType
ORDER BY freq DESC
LIMIT 1;

-- 8. Total transaction value by currency
SELECT Currency, SUM(Amount) AS total_amount
FROM transactions
GROUP BY Currency;

-- 9. Top 5 branches by total transaction volume
SELECT BranchCode, SUM(Amount) AS branch_total
FROM transactions
GROUP BY BranchCode
ORDER BY branch_total DESC
LIMIT 5;

-- 10. Average interest rate of customers with credit score above 700
SELECT AVG(InterestRate) AS avg_interest_high_credit
FROM customer_accounts
WHERE CreditScore > 700;

-- 11. Customers with highest loan-to-balance ratio
SELECT AccountHolder, (LoanAmount / Balance) AS loan_balance_ratio
FROM customer_accounts
ORDER BY loan_balance_ratio DESC
LIMIT 10;

-- 12. Monthly transaction totals
SELECT DATE_FORMAT(TransactionDate, '%Y-%m') AS month, SUM(Amount) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- 13. Transactions per account
SELECT AccountNumber, COUNT(*) AS txn_count
FROM transactions
GROUP BY AccountNumber;

-- 14. Accounts opened per year
SELECT YEAR(OpeningDate) AS year_opened, COUNT(*) AS total_accounts
FROM customer_accounts
GROUP BY year_opened;

-- 15. Average transaction amount per type
SELECT TransactionType, AVG(Amount) AS avg_amount
FROM transactions
GROUP BY TransactionType;

-- 16. Total deposits vs withdrawals
SELECT TransactionType, SUM(Amount) AS total_amount
FROM transactions
WHERE TransactionType IN ('Deposit', 'Withdrawal')
GROUP BY TransactionType;

-- 17. City-level average credit score
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(AccountHolderDetails, 'City: ', -1), ',', 1) AS City,
       AVG(CreditScore) AS avg_score
FROM customer_accounts
GROUP BY City;

-- 18. Most active customers (by number of transactions)
SELECT t.AccountNumber, ca.AccountHolder, COUNT(*) AS txn_count
FROM transactions t
JOIN customer_accounts ca USING(AccountNumber)
GROUP BY t.AccountNumber
ORDER BY txn_count DESC
LIMIT 10;

-- 19. Average transaction time per type
SELECT TransactionType, AVG(TransactionTime) AS avg_time
FROM transactions
GROUP BY TransactionType;

-- 20. Correlation insight: Do higher credit scores correspond to lower loan amounts?
SELECT ROUND(AVG(LoanAmount),2) AS avg_loan, ROUND(AVG(CreditScore),2) AS avg_credit
FROM customer_accounts;

-- 21. Top 5 customers with highest total transaction value
SELECT ca.AccountHolder, SUM(t.Amount) AS total_value
FROM transactions t
JOIN customer_accounts ca USING(AccountNumber)
GROUP BY ca.AccountHolder
ORDER BY total_value DESC
LIMIT 5;

-- 22. Accounts with negative or zero balances
SELECT * FROM customer_accounts WHERE Balance <= 0;

-- 23. Branch-wise transaction count
SELECT BranchCode, COUNT(*) AS txn_count
FROM transactions
GROUP BY BranchCode
ORDER BY txn_count DESC;

-- 24. Total balance and loan per account type
SELECT AccountType, SUM(Balance) AS total_balance, SUM(LoanAmount) AS total_loans
FROM customer_accounts
GROUP BY AccountType;

-- 25. Top 5 currencies used in transactions
SELECT Currency, COUNT(*) AS txn_count
FROM transactions
GROUP BY Currency
ORDER BY txn_count DESC
LIMIT 5;
