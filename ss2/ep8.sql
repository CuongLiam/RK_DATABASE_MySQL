CREATE DATABASE VPBank_Rikkei_Payment;
USE VPBank_Rikkei_Payment;

-- 1. Bảng Khách hàng (Customer)
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    IdentityCard VARCHAR(20) NOT NULL UNIQUE, -- CMND/CCCD duy nhất
    Phone VARCHAR(15) NOT NULL UNIQUE,       -- Số điện thoại duy nhất
    Address NVARCHAR(255)
);

-- 2. Bảng Tài khoản ngân hàng (Account)
CREATE TABLE Account (
    AccountNumber VARCHAR(20) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Balance DECIMAL(18, 2) DEFAULT 0 CHECK (Balance >= 0), -- Số dư không được âm
    AccountType VARCHAR(20) DEFAULT 'Checking',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_account_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- 3. Bảng Đối tác (Partner)
CREATE TABLE Partner (
    PartnerID INT AUTO_INCREMENT PRIMARY KEY,
    PartnerName NVARCHAR(100) NOT NULL,
    PartnerCode VARCHAR(20) NOT NULL UNIQUE, -- Ví dụ: 'RIKKEI_EDU'
    ServiceType NVARCHAR(50) DEFAULT 'Education'
);

-- 4. Bảng Hóa đơn học phí (TuitionBill)
CREATE TABLE TuitionBill (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    BillCode VARCHAR(50) NOT NULL UNIQUE,    -- Mã hóa đơn từ đối tác gửi sang
    AccountNumber VARCHAR(20) NOT NULL,      -- Tài khoản nộp học phí
    PartnerID INT NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL CHECK (Amount > 0),
    Status VARCHAR(20) DEFAULT 'Unpaid',     -- Trạng thái: Unpaid, Paid, Cancelled
    DueDate DATE,
    CONSTRAINT fk_bill_account FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber),
    CONSTRAINT fk_bill_partner FOREIGN KEY (PartnerID) REFERENCES Partner(PartnerID)
);

-- 5. Bảng Giao dịch (Transaction)
CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    BillID INT NOT NULL UNIQUE,             -- Đảm bảo mỗi hóa đơn chỉ thanh toán thành công 1 lần
    AccountNumber VARCHAR(20) NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL CHECK (Amount > 0),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Pending',    -- Trạng thái: Pending, Success, Failed
    Description NVARCHAR(255),
    CONSTRAINT fk_trans_bill FOREIGN KEY (BillID) REFERENCES TuitionBill(BillID),
    CONSTRAINT fk_trans_account FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber)
);