CREATE DATABASE Cars_Management_System;
USE Cars_Management_System;

-- Customer Table:
CREATE TABLE customer (
	customer_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email_id VARCHAR(150) UNIQUE,
    phone VARCHAR(100) UNIQUE,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
    );

-- Brand Table:
CREATE TABLE brand (
	brand_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL,
    founded_year YEAR
);

-- Model Table:
CREATE TABLE model (
model_id VARCHAR(15) PRIMARY KEY,
brand_id VARCHAR(50) NOT NULL,
model_name VARCHAR(150) NOT NULL,
vehicle_type VARCHAR(50) NOT NULL,
	CONSTRAINT fk_model_brand FOREIGN KEY (brand_id) REFERENCES brand(brand_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_model_brand UNIQUE (brand_id, model_name)
);

-- Vehicle Table:
CREATE TABLE vehicle (
	vehicle_id VARCHAR(20) PRIMARY KEY,
	VIN CHAR(17) NOT NULL UNIQUE,
	model_id VARCHAR(15) NOT NULL,
	color VARCHAR(50),
	mileage INT DEFAULT 0 NOT NULL,
    status ENUM('available','reserved','sold') DEFAULT 'available',
    price DECIMAL(12,2) NOT NULL,
    purchase_date DATE NOT NULL,
    registration_number VARCHAR(50) NOT NULL UNIQUE,
	CONSTRAINT fk_vehicle_model FOREIGN KEY (model_id) REFERENCES model(model_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_vehicle_mileage CHECK (mileage >= 0),
    CONSTRAINT chk_vehicle_price CHECK (price > 0)
);


-- Salesperson
CREATE TABLE salesperson (
    salesperson_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(150),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(50),
    hire_date DATE,
    position VARCHAR(100)
);
-- Sale
CREATE TABLE sale (
    sale_id VARCHAR(20) PRIMARY KEY,
    vehicle_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    salesperson_id VARCHAR(10),
    sale_date DATE NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL,
    payment_method ENUM('cash','card','financing','bank_transfer'),
    CONSTRAINT fk_sale_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sale_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sale_salesperson FOREIGN KEY (salesperson_id) REFERENCES salesperson(salesperson_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_sale_price CHECK (sale_price > 0)
);


-- Appointment
CREATE TABLE appointment (
    appointment_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    vehicle_id VARCHAR(20) NOT NULL,
    scheduled_start DATETIME,
    scheduled_end DATETIME,
    purpose VARCHAR(200),
    status ENUM('scheduled','rescheduled','completed','cancelled','no_show') DEFAULT 'scheduled',
	CONSTRAINT fk_appointment_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_appointment_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ServiceOrder
CREATE TABLE serviceorder (
    service_id VARCHAR(50) PRIMARY KEY,
    vehicle_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    appointment_id VARCHAR(30) NULL,
    received_date DATE,
    completed_date DATE,
    odometer INT,
    total_amount DECIMAL(12,2) DEFAULT 0,
    status ENUM('open','in_progress','closed','cancelled') DEFAULT 'open',
    service_type ENUM('repair','maintenance','warranty','inspection') NOT NULL,
    payment_status ENUM('pending','paid','waived') DEFAULT 'pending',
	CONSTRAINT fk_service_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_service_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_service_appointment FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_service_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_service_odometer CHECK (odometer >= 0)
);

-- Technician
CREATE TABLE technician (
    tech_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(150),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(50),
    skill_level ENUM('junior','senior','master'),
    hire_date DATE
);

-- ServiceTechnicians (junction)
CREATE TABLE service_technicians (
    service_id VARCHAR(50) NOT NULL,
    tech_id VARCHAR(10) NOT NULL,
    role ENUM('lead','assistant','inspector'),
	PRIMARY KEY (service_id, tech_id),
	CONSTRAINT fk_servicetech_service FOREIGN KEY (service_id) REFERENCES serviceorder(service_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_servicetech_tech FOREIGN KEY (tech_id) REFERENCES technician(tech_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Part
CREATE TABLE part (
    part_id VARCHAR(15) PRIMARY KEY,
    part_number VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    unit_cost DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    CONSTRAINT chk_part_unit_cost CHECK (unit_cost >= 0),
    CONSTRAINT chk_part_stock CHECK (stock_quantity >= 0)
);

-- ServiceParts (junction)
CREATE TABLE service_parts (
    service_id VARCHAR(50) NOT NULL,
    part_id VARCHAR(15) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (service_id, part_id),
	CONSTRAINT fk_serviceparts_service FOREIGN KEY (service_id) REFERENCES serviceorder(service_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_serviceparts_part FOREIGN KEY (part_id) REFERENCES part(part_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_serviceparts_quantity CHECK (quantity > 0),
    CONSTRAINT chk_serviceparts_unit_price CHECK (unit_price > 0)
);

-- Supplier
CREATE TABLE supplier (
    supplier_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    contact_name VARCHAR(150),
    phone VARCHAR(50),
    email VARCHAR(150) UNIQUE,
    address VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- PartSuppliers (junction)
CREATE TABLE part_suppliers (
    part_id VARCHAR(15) NOT NULL,
    supplier_id VARCHAR(10) NOT NULL,
    supplier_part_number VARCHAR(50),
    lead_time_days INT,
    price DECIMAL(10,2),
	PRIMARY KEY (part_id, supplier_id),
	CONSTRAINT fk_partsuppliers_part FOREIGN KEY (part_id) REFERENCES part(part_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_partsuppliers_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_partsuppliers_leadtime CHECK (lead_time_days >= 0),
    CONSTRAINT chk_partsuppliers_price CHECK (price >= 0)
);

-- insurance policy table
CREATE TABLE insurancepolicy (
    policy_id VARCHAR(30) PRIMARY KEY,
    policy_number VARCHAR(50) NOT NULL UNIQUE,
    provider VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_insurance_dates CHECK (start_date <= end_date)
);


-- vehicle insurance policy
CREATE TABLE vehicle_insurance (
    vehicle_id VARCHAR(20) NOT NULL,
    policy_id VARCHAR(30),
    assigned_date DATE,
    status ENUM('active','expired','cancelled') DEFAULT 'active',
	PRIMARY KEY(vehicle_id, assigned_date),
	CONSTRAINT fk_vehicleinsurance_vehicle FOREIGN KEY(vehicle_id) REFERENCES vehicle(vehicle_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleinsurance_policy FOREIGN KEY(policy_id) REFERENCES insurancepolicy(policy_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);


-- Invoice
CREATE TABLE invoice (
    invoice_id VARCHAR(30) PRIMARY KEY,
    service_id VARCHAR(50) NULL,
    sale_id VARCHAR(20) NULL,
    invoice_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12,2) NOT NULL,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    discount_amount DECIMAL(12,2) DEFAULT 0,
    paid_flag BOOLEAN DEFAULT FALSE,
    payment_date DATE,
    payment_method ENUM('cash','card','financing','bank_transfer'),
	CONSTRAINT fk_invoice_service FOREIGN KEY (service_id) REFERENCES serviceorder(service_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_invoice_sale FOREIGN KEY (sale_id) REFERENCES sale(sale_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_invoice_amount CHECK (amount >= 0),
    CONSTRAINT chk_invoice_tax CHECK (tax_amount >= 0),
    CONSTRAINT chk_invoice_discount CHECK (discount_amount >= 0)
);

-- Index on Sale: Customer and Sale Date:
CREATE INDEX idx_sale_customer_date ON sale (customer_id, sale_date);

-- Index on Service Order: Vehicle and Received Date:
CREATE INDEX idx_service_vehicle_date ON serviceorder (vehicle_id, received_date);

-- Index on Vehicle: VIN and Registration Number:
CREATE UNIQUE INDEX idx_vehicle_vin ON vehicle (VIN);
CREATE UNIQUE INDEX idx_vehicle_registration ON vehicle (registration_number);

-- Index on Customer: Email and Phone:
CREATE UNIQUE INDEX idx_customer_email ON customer (email_id);
CREATE UNIQUE INDEX idx_customer_phone ON customer (phone);

-- Index on Part: Part Number:
CREATE UNIQUE INDEX idx_part_number ON part (part_number);

-- Index on Technician: Email:
CREATE UNIQUE INDEX idx_technician_email ON technician (email);

-- Index on Supplier: Email:
CREATE UNIQUE INDEX idx_supplier_email ON supplier (email);

-- Index on Appointment: Customer and Vehicle:
CREATE INDEX idx_appointment_customer_vehicle ON appointment (customer_id, vehicle_id);

-- Index on Vehicle_Insurance: Vehicle and Policy:
CREATE INDEX idx_vehicleinsurance_vehicle_policy ON vehicle_insurance (vehicle_id, policy_id);

-- Index on Invoice: Sale and Service:
CREATE INDEX idx_invoice_sale_service ON invoice (sale_id, service_id);

SHOW INDEX FROM sale;
SHOW INDEX FROM serviceorder;
SHOW INDEX FROM vehicle;
SHOW INDEX FROM customer;
SHOW INDEX FROM part;
SHOW INDEX FROM technician;
SHOW INDEX FROM supplier;
SHOW INDEX FROM invoice;

INSERT INTO customer VALUES
('C001','John','Smith','john.smith@email.com','9876543210','123 Elm Street','New York','USA'),
('C002','Alice','Johnson','alice.j@email.com','9876543211','45 Maple Ave','Los Angeles','USA'),
('C003','Robert','Brown','robert.b@email.com','9876543212','78 Pine Road','Chicago','USA'),
('C004','Emma','Davis','emma.davis@email.com','9876543213','22 Oak Lane','Houston','USA'),
('C005','Michael','Wilson','michael.w@email.com','9876543214','19 Cedar Blvd','Phoenix','USA'),
('C006','Sophia','Martinez','sophia.m@email.com','9876543215','90 Birch Street','Philadelphia','USA'),
('C007','James','Anderson','james.a@email.com','9876543216','45 Willow Road','San Antonio','USA'),
('C008','Olivia','Thomas','olivia.t@email.com','9876543217','32 Ash Court','San Diego','USA'),
('C009','Liam','Garcia','liam.g@email.com','9876543218','10 Redwood St','Dallas','USA'),
('C010','Ava','Rodriguez','ava.r@email.com','9876543219','18 Palm Drive','San Jose','USA'),
('C011','William','Lee','william.l@email.com','9876543220','90 River Blvd','Austin','USA'),
('C012','Ethan','Harris','ethan.h@email.com','9876543221','101 Lake Road','Jacksonville','USA'),
('C013','Mia','Clark','mia.c@email.com','9876543222','88 Park Avenue','Fort Worth','USA'),
('C014','Noah','Lewis','noah.l@email.com','9876543223','54 Broadway','Columbus','USA'),
('C015','Isabella','Walker','isabella.w@email.com','9876543224','67 Cherry Lane','Charlotte','USA');


INSERT INTO brand VALUES
('B001','Toyota','Japan',1937),
('B002','Honda','Japan',1948),
('B003','Ford','USA',1903),
('B004','Chevrolet','USA',1911),
('B005','BMW','Germany',1916),
('B006','Mercedes-Benz','Germany',1926),
('B007','Hyundai','South Korea',1967),
('B008','Kia','South Korea',1944),
('B009','Nissan','Japan',1933),
('B010','Volkswagen','Germany',1937),
('B011','Lexus','Japan',1989),
('B012','Mazda','Japan',1920),
('B013','Jeep','USA',1941),
('B014','Tesla','USA',2003),
('B015','Audi','Germany',1909);


INSERT INTO model VALUES
('M001','B001','Corolla','Sedan'),
('M002','B001','Camry','Sedan'),
('M003','B002','Civic','Sedan'),
('M004','B002','CRV','SUV'),
('M005','B003','Mustang','Coupe'),
('M006','B003','F-150','Truck'),
('M007','B004','Malibu','Sedan'),
('M008','B005','X5','SUV'),
('M009','B006','C-Class','Sedan'),
('M010','B007','Elantra','Sedan'),
('M011','B008','Sportage','SUV'),
('M012','B009','Altima','Sedan'),
('M013','B010','Golf','Hatchback'),
('M014','B014','Model 3','Sedan'),
('M015','B015','A4','Sedan');


INSERT INTO vehicle VALUES
('V001','1HGCM82633A123450','M001','White',2500,'available',22000.00,'2023-01-10','NY001'),
('V002','1HGCM82633A123451','M002','Black',10000,'sold',28000.00,'2022-06-15','NY002'),
('V003','1HGCM82633A123452','M003','Silver',5000,'available',24000.00,'2023-03-12','LA003'),
('V004','1HGCM82633A123453','M004','Blue',12000,'sold',27000.00,'2022-09-05','LA004'),
('V005','1HGCM82633A123454','M005','Red',7000,'available',35000.00,'2023-04-08','CH005'),
('V006','1HGCM82633A123455','M006','Grey',15000,'sold',40000.00,'2022-07-18','HO006'),
('V007','1HGCM82633A123456','M007','White',11000,'reserved',25000.00,'2023-02-21','PH007'),
('V008','1HGCM82633A123457','M008','Black',8000,'sold',55000.00,'2022-11-30','SD008'),
('V009','1HGCM82633A123458','M009','Blue',9000,'sold',47000.00,'2023-01-22','DA009'),
('V010','1HGCM82633A123459','M010','Red',4000,'available',21000.00,'2023-04-20','SJ010'),
('V011','1HGCM82633A123460','M011','White',13000,'available',27000.00,'2023-03-28','AU011'),
('V012','1HGCM82633A123461','M012','Black',5000,'sold',26000.00,'2022-12-05','JA012'),
('V013','1HGCM82633A123462','M013','Silver',6000,'sold',29000.00,'2023-02-17','FW013'),
('V014','1HGCM82633A123463','M014','White',3000,'available',42000.00,'2023-04-12','CL014'),
('V015','1HGCM82633A123464','M015','Blue',8000,'sold',46000.00,'2022-08-25','CH015');



INSERT INTO salesperson VALUES
('S001','Daniel Adams','daniel.a@email.com','9000000001','2021-01-01','Manager'),
('S002','Laura White','laura.w@email.com','9000000002','2021-03-15','Senior Sales'),
('S003','Kevin Turner','kevin.t@email.com','9000000003','2021-06-01','Executive'),
('S004','Emily Clark','emily.c@email.com','9000000004','2022-01-10','Executive'),
('S005','Brian Scott','brian.s@email.com','9000000005','2022-03-05','Sales Associate'),
('S006','Sophia Reed','sophia.r@email.com','9000000006','2022-04-08','Sales Associate'),
('S007','Jack Lee','jack.l@email.com','9000000007','2022-06-22','Executive'),
('S008','Evelyn Hall','evelyn.h@email.com','9000000008','2022-08-30','Sales Associate'),
('S009','David Green','david.g@email.com','9000000009','2023-01-15','Executive'),
('S010','Grace Young','grace.y@email.com','9000000010','2023-02-20','Executive'),
('S011','Andrew Collins','andrew.c@email.com','9000000011','2023-03-18','Sales Associate'),
('S012','Hannah Lewis','hannah.l@email.com','9000000012','2023-05-22','Executive'),
('S013','Samuel Brooks','samuel.b@email.com','9000000013','2023-06-10','Manager'),
('S014','Olivia Reed','olivia.r@email.com','9000000014','2023-07-01','Senior Sales'),
('S015','Ethan Moore','ethan.m@email.com','9000000015','2023-08-15','Sales Associate');



INSERT INTO sale VALUES
('SL001','V002','C001','S001','2023-01-15',28000.00,'card'),
('SL002','V004','C002','S002','2023-02-18',27000.00,'cash'),
('SL003','V006','C003','S003','2023-03-21',40000.00,'bank_transfer'),
('SL004','V008','C004','S004','2023-04-10',55000.00,'card'),
('SL005','V009','C005','S005','2023-05-09',47000.00,'cash'),
('SL006','V012','C006','S006','2023-06-25',26000.00,'card'),
('SL007','V013','C007','S007','2023-07-14',29000.00,'cash'),
('SL008','V015','C008','S008','2023-08-10',46000.00,'card'),
('SL009','V003','C009','S009','2023-09-05',24000.00,'cash'),
('SL010','V005','C010','S010','2023-09-25',35000.00,'bank_transfer'),
('SL011','V014','C011','S011','2023-10-01',42000.00,'card'),
('SL012','V011','C012','S012','2023-10-02',27000.00,'cash'),
('SL013','V010','C013','S013','2023-10-03',21000.00,'card'),
('SL014','V001','C014','S014','2023-10-04',22000.00,'cash'),
('SL015','V007','C015','S015','2023-10-05',25000.00,'card');



INSERT INTO appointment VALUES
('A001','C001','V002','2023-02-10 09:00:00','2023-02-10 10:00:00','Oil Change','completed'),
('A002','C002','V004','2023-03-12 11:00:00','2023-03-12 12:30:00','Brake Inspection','completed'),
('A003','C003','V006','2023-04-05 13:00:00','2023-04-05 14:00:00','Engine Check','completed'),
('A004','C004','V008','2023-05-01 09:30:00','2023-05-01 10:30:00','Battery Replacement','completed'),
('A005','C005','V009','2023-05-28 10:00:00','2023-05-28 11:00:00','General Service','completed'),
('A006','C006','V012','2023-06-20 08:30:00','2023-06-20 09:45:00','AC Maintenance','completed'),
('A007','C007','V013','2023-07-08 10:30:00','2023-07-08 11:45:00','Oil Change','completed'),
('A008','C008','V015','2023-08-15 09:00:00','2023-08-15 10:00:00','Tyre Rotation','completed'),
('A009','C009','V003','2023-09-10 10:30:00','2023-09-10 12:00:00','Inspection','completed'),
('A010','C010','V005','2023-09-22 11:00:00','2023-09-22 12:15:00','Wheel Alignment','completed'),
('A011','C011','V014','2023-10-05 08:00:00','2023-10-05 09:15:00','Warranty Check','completed'),
('A012','C012','V011','2023-10-10 09:00:00','2023-10-10 10:30:00','Cleaning Service','completed'),
('A013','C013','V010','2023-10-15 11:00:00','2023-10-15 12:00:00','Engine Tuning','scheduled'),
('A014','C014','V001','2023-10-18 10:00:00','2023-10-18 11:00:00','Pre-Sale Check','scheduled'),
('A015','C015','V007','2023-10-20 09:00:00','2023-10-20 10:00:00','Inspection','scheduled');



INSERT INTO serviceorder VALUES
('SR001','V002','C001','A001','2023-02-10','2023-02-10',5000,150.00,'closed','maintenance','paid'),
('SR002','V004','C002','A002','2023-03-12','2023-03-12',8000,200.00,'closed','inspection','paid'),
('SR003','V006','C003','A003','2023-04-05','2023-04-05',15000,300.00,'closed','repair','paid'),
('SR004','V008','C004','A004','2023-05-01','2023-05-01',9000,180.00,'closed','maintenance','paid'),
('SR005','V009','C005','A005','2023-05-28','2023-05-28',10000,220.00,'closed','inspection','paid'),
('SR006','V012','C006','A006','2023-06-20','2023-06-20',12000,250.00,'closed','maintenance','paid'),
('SR007','V013','C007','A007','2023-07-08','2023-07-08',13000,160.00,'closed','maintenance','paid'),
('SR008','V015','C008','A008','2023-08-15','2023-08-15',9000,175.00,'closed','repair','paid'),
('SR009','V003','C009','A009','2023-09-10','2023-09-10',6000,210.00,'closed','inspection','paid'),
('SR010','V005','C010','A010','2023-09-22','2023-09-22',7000,230.00,'closed','maintenance','paid'),
('SR011','V014','C011','A011','2023-10-05','2023-10-05',3000,190.00,'closed','warranty','paid'),
('SR012','V011','C012','A012','2023-10-10','2023-10-10',13000,140.00,'closed','maintenance','paid'),
('SR013','V010','C013','A013','2023-10-15',NULL,4000,0,'open','repair','pending'),
('SR014','V001','C014','A014','2023-10-18',NULL,2500,0,'open','inspection','pending'),
('SR015','V007','C015','A015','2023-10-20',NULL,11000,0,'open','inspection','pending');


INSERT INTO technician VALUES
('T001','Liam Johnson','liam.johnson@email.com','9010000001','master','2020-01-01'),
('T002','Emma Williams','emma.w@email.com','9010000002','senior','2020-03-10'),
('T003','Noah Brown','noah.b@email.com','9010000003','junior','2020-06-15'),
('T004','Olivia Davis','olivia.d@email.com','9010000004','senior','2021-01-05'),
('T005','William Miller','william.m@email.com','9010000005','junior','2021-04-22'),
('T006','Sophia Wilson','sophia.w@email.com','9010000006','senior','2021-07-10'),
('T007','James Moore','james.m@email.com','9010000007','master','2022-01-20'),
('T008','Isabella Taylor','isabella.t@email.com','9010000008','junior','2022-03-18'),
('T009','Benjamin Anderson','ben.a@email.com','9010000009','senior','2022-05-05'),
('T010','Charlotte Thomas','charlotte.t@email.com','9010000010','junior','2022-08-08'),
('T011','Lucas Jackson','lucas.j@email.com','9010000011','senior','2022-10-01'),
('T012','Mia White','mia.w@email.com','9010000012','junior','2023-01-12'),
('T013','Elijah Harris','elijah.h@email.com','9010000013','senior','2023-03-14'),
('T014','Amelia Martin','amelia.m@email.com','9010000014','junior','2023-05-09'),
('T015','Harper Lee','harper.l@email.com','9010000015','senior','2023-07-01');



INSERT INTO service_technicians VALUES
('SR001','T001','lead'),
('SR002','T002','lead'),
('SR003','T007','lead'),
('SR004','T006','lead'),
('SR005','T004','lead'),
('SR006','T008','assistant'),
('SR007','T009','assistant'),
('SR008','T005','lead'),
('SR009','T003','assistant'),
('SR010','T010','assistant'),
('SR011','T011','lead'),
('SR012','T012','assistant'),
('SR013','T013','lead'),
('SR014','T014','inspector'),
('SR015','T015','lead');



INSERT INTO part VALUES
('P001','ENG-001','Engine Oil',40.00,100),
('P002','BRK-002','Brake Pads',70.00,60),
('P003','FLT-003','Oil Filter',25.00,80),
('P004','BAT-004','Battery',150.00,40),
('P005','TYR-005','Tire',120.00,120),
('P006','WIP-006','Wiper Blades',15.00,90),
('P007','SPK-007','Spark Plug',10.00,150),
('P008','COO-008','Coolant',30.00,70),
('P009','BEL-009','Drive Belt',45.00,50),
('P010','BRF-010','Brake Fluid',25.00,60),
('P011','FUE-011','Fuel Filter',35.00,80),
('P012','AIR-012','Air Filter',20.00,70),
('P013','LGT-013','Headlight Bulb',50.00,50),
('P014','ALT-014','Alternator',250.00,20),
('P015','AC-015','AC Compressor',300.00,25);



INSERT INTO service_parts VALUES
('SR001','P001',2,40.00),
('SR002','P002',1,70.00),
('SR003','P004',1,150.00),
('SR004','P005',2,120.00),
('SR005','P006',1,15.00),
('SR006','P007',4,10.00),
('SR007','P008',1,30.00),
('SR008','P009',1,45.00),
('SR009','P010',2,25.00),
('SR010','P011',1,35.00),
('SR011','P012',1,20.00),
('SR012','P013',1,50.00),
('SR013','P014',1,250.00),
('SR014','P015',1,300.00),
('SR015','P003',1,25.00);


INSERT INTO supplier VALUES
('SUP001','AutoParts Co.','John Carter','9020000020','autoparts@email.com','45 Industrial Road','New York','USA'),
('SUP002','BrakeWorld','Emily Evans','9020000030','brakeworld@email.com','67 Brake St','Chicago','USA'),
('SUP003','EngineTech','Mark Brown','9020000045','engintech@email.com','12 Power Dr','Houston','USA'),
('SUP004','BatteryPlus','Olivia White','9020000025','batteryplus@email.com','9 Volt Ave','Dallas','USA'),
('SUP005','TireHub','Ethan Green','9020000315','tirehub@email.com','23 Rubber Way','Austin','USA'),
('SUP006','FilterPro','Ava Moore','9020000129','filterpro@email.com','11 Filter Blvd','San Jose','USA'),
('SUP007','CarCool','William Johnson','9020000587','carcool@email.com','77 Coolant Rd','Phoenix','USA'),
('SUP008','DriveLine','Sophia Clark','9020000148','driveline@email.com','89 Belt St','Los Angeles','USA'),
('SUP009','LightWorks','James Davis','9020000959','lightworks@email.com','21 Beam Rd','New York','USA'),
('SUP010','AutoElectro','Liam Martin','9020008510','autoelectro@email.com','32 Spark Ave','Seattle','USA'),
('SUP011','PartsNow','Charlotte Hall','9020007811','partsnow@email.com','66 Gear St','Miami','USA'),
('SUP012','SpeedSupply','Amelia Hill','9020009212','speedsupply@email.com','14 Engine Dr','Denver','USA'),
('SUP013','AutoServe','Benjamin Scott','9020000911','autoserve@email.com','22 Service Ln','Boston','USA'),
('SUP014','TransAuto','Mia Harris','9020006291','transauto@email.com','99 Shift Ave','Atlanta','USA'),
('SUP015','CoolDrive','Lucas Lewis','9020000629','cooldrive@email.com','15 Chill Blvd','Detroit','USA');



INSERT INTO part_suppliers VALUES
('P001','SUP001','ENG-001A',7,38.00),
('P002','SUP002','BRK-002B',5,65.00),
('P003','SUP006','FLT-003C',6,20.00),
('P004','SUP004','BAT-004D',10,145.00),
('P005','SUP005','TYR-005E',12,110.00),
('P006','SUP006','WIP-006F',8,12.00),
('P007','SUP010','SPK-007G',4,9.00),
('P008','SUP007','COO-008H',5,28.00),
('P009','SUP008','BEL-009I',7,40.00),
('P010','SUP002','BRF-010J',6,22.00),
('P011','SUP006','FUE-011K',7,30.00),
('P012','SUP006','AIR-012L',8,18.00),
('P013','SUP009','LGT-013M',9,45.00),
('P014','SUP010','ALT-014N',10,240.00),
('P015','SUP015','AC-015O',9,280.00);


INSERT INTO insurancepolicy VALUES
('POL001','INS1001','Allianz','2023-01-01','2024-01-01',DEFAULT),
('POL002','INS1002','AXA','2023-02-01','2024-02-01',DEFAULT),
('POL003','INS1003','Geico','2023-03-01','2024-03-01',DEFAULT),
('POL004','INS1004','StateFarm','2023-04-01','2024-04-01',DEFAULT),
('POL005','INS1005','Progressive','2023-05-01','2024-05-01',DEFAULT),
('POL006','INS1006','Nationwide','2023-06-01','2024-06-01',DEFAULT),
('POL007','INS1007','MetLife','2023-07-01','2024-07-01',DEFAULT),
('POL008','INS1008','Zurich','2023-08-01','2024-08-01',DEFAULT),
('POL009','INS1009','Prudential','2023-09-01','2024-09-01',DEFAULT),
('POL010','INS1010','Liberty','2023-10-01','2024-10-01',DEFAULT),
('POL011','INS1011','Allianz','2022-01-01','2023-01-01',DEFAULT),
('POL012','INS1012','AXA','2022-02-01','2023-02-01',DEFAULT),
('POL013','INS1013','Geico','2022-03-01','2023-03-01',DEFAULT),
('POL014','INS1014','StateFarm','2022-04-01','2023-04-01',DEFAULT),
('POL015','INS1015','Progressive','2022-05-01','2023-05-01',DEFAULT);



INSERT INTO vehicle_insurance VALUES
('V001','POL001','2023-01-10','active'),
('V002','POL002','2023-02-12','active'),
('V003','POL003','2023-03-05','active'),
('V004','POL004','2023-04-18','active'),
('V005','POL005','2023-05-22','active'),
('V006','POL006','2023-06-15','active'),
('V007','POL007','2023-07-01','active'),
('V008','POL008','2023-08-05','active'),
('V009','POL009','2023-09-10','active'),
('V010','POL010','2023-10-02','active'),
('V011','POL011','2022-01-05','expired'),
('V012','POL012','2022-02-10','expired'),
('V013','POL013','2022-03-07','expired'),
('V014','POL014','2022-04-20','expired'),
('V015','POL015','2022-05-30','expired');


INSERT INTO invoice VALUES
('INV001','SR001','SL001','2023-02-10 10:00:00',150.00,15.00,0,FALSE,NULL,'cash'),
('INV002','SR002','SL002','2023-03-12 12:00:00',200.00,18.00,0,TRUE,'2023-03-12','card'),
('INV003','SR003','SL003','2023-04-05 14:00:00',300.00,25.00,0,TRUE,'2023-04-05','bank_transfer'),
('INV004','SR004','SL004','2023-05-01 11:00:00',180.00,16.00,0,TRUE,'2023-05-01','cash'),
('INV005','SR005','SL005','2023-05-28 12:00:00',220.00,20.00,0,TRUE,'2023-05-28','card'),
('INV006','SR006','SL006','2023-06-20 09:45:00',250.00,22.00,0,TRUE,'2023-06-20','cash'),
('INV007','SR007','SL007','2023-07-08 11:45:00',160.00,14.00,0,TRUE,'2023-07-08','card'),
('INV008','SR008','SL008','2023-08-15 10:00:00',175.00,15.00,0,TRUE,'2023-08-15','card'),
('INV009','SR009','SL009','2023-09-10 12:00:00',210.00,18.00,0,TRUE,'2023-09-10','cash'),
('INV010','SR010','SL010','2023-09-22 12:15:00',230.00,21.00,0,TRUE,'2023-09-22','bank_transfer'),
('INV011','SR011','SL011','2023-10-05 09:15:00',190.00,17.00,0,TRUE,'2023-10-05','card'),
('INV012','SR012','SL012','2023-10-10 10:30:00',140.00,13.00,0,TRUE,'2023-10-10','cash'),
('INV013','SR013','SL013','2023-10-15 12:00:00',0.00,0.00,0,FALSE,NULL,NULL),
('INV014','SR014','SL014','2023-10-18 11:00:00',0.00,0.00,0,FALSE,NULL,NULL),
('INV015','SR015','SL015','2023-10-20 10:00:00',0.00,0.00,0,FALSE,NULL,NULL);



-- View 1 – Sales Summary by Brand

CREATE VIEW vw_sales_summary_by_brand AS
SELECT 
    b.name AS brand_name,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.sale_price) AS total_revenue,
    ROUND(AVG(s.sale_price),2) AS average_sale_price
FROM sale s
JOIN vehicle v ON s.vehicle_id = v.vehicle_id
JOIN model m ON v.model_id = m.model_id
JOIN brand b ON m.brand_id = b.brand_id
GROUP BY b.name
ORDER BY total_revenue DESC;






-- View 2 – Monthly Sales Trend

CREATE VIEW vw_monthly_sales_trend AS
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    COUNT(sale_id) AS total_sales,
    SUM(sale_price) AS monthly_revenue,
    ROUND(AVG(sale_price),2) AS avg_sale_value
FROM sale
GROUP BY sale_month
ORDER BY sale_month;

SELECT * FROM vw_sales_summary_by_brand;

SELECT * FROM vw_monthly_sales_trend;


-- Which salesperson has generated the highest total sales revenue, and how many vehicles has each salesperson sold?

SELECT 
    s.salesperson_id,
    s.name AS salesperson_name,
    COUNT(sa.sale_id) AS total_vehicles_sold,
    SUM(sa.sale_price) AS total_revenue_generated
FROM salesperson s
JOIN sale sa ON s.salesperson_id = sa.salesperson_id
GROUP BY s.salesperson_id, s.name
HAVING COUNT(sa.sale_id) > 0
ORDER BY total_revenue_generated DESC;

-- Which car brands have the highest average service costs, and how does brand affect maintenance expenses?

SELECT 
    b.name AS brand_name,
    ROUND(AVG(so.total_amount),2) AS avg_service_cost,
    COUNT(so.service_id) AS total_services
FROM serviceorder so
JOIN vehicle v ON so.vehicle_id = v.vehicle_id
JOIN model m ON v.model_id = m.model_id
JOIN brand b ON m.brand_id = b.brand_id
GROUP BY b.name
HAVING AVG(so.total_amount) > 0
ORDER BY avg_service_cost DESC;


-- How can customers be classified into spending categories (Low, Medium, High) based on their total purchases and services combined?

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(s.sale_price) + IFNULL(SUM(so.total_amount),0),2) AS total_spent,
    CASE
        WHEN (SUM(s.sale_price) + IFNULL(SUM(so.total_amount),0)) >= 80000 THEN 'High Value'
        WHEN (SUM(s.sale_price) + IFNULL(SUM(so.total_amount),0)) BETWEEN 40000 AND 79999 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_category
FROM customer c
LEFT JOIN sale s ON c.customer_id = s.customer_id
LEFT JOIN serviceorder so ON c.customer_id = so.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;


-- Which spare parts are most frequently used across all service orders?

SELECT 
    p.part_id,
    p.name AS part_name,
    SUM(sp.quantity) AS total_units_used
FROM part p
JOIN service_parts sp ON p.part_id = sp.part_id
GROUP BY p.part_id, p.name
HAVING SUM(sp.quantity) > (
    SELECT AVG(qty_sum) 
    FROM (
        SELECT SUM(quantity) AS qty_sum 
        FROM service_parts 
        GROUP BY part_id
    ) AS sub
)
ORDER BY total_units_used DESC
LIMIT 5;


-- How does each salesperson rank in terms of total monthly revenue generation?

SELECT 
    DATE_FORMAT(sa.sale_date, '%Y-%m') AS sale_month,
    s.salesperson_id,
    s.name AS salesperson_name,
    SUM(sa.sale_price) AS monthly_revenue,
    RANK() OVER (PARTITION BY DATE_FORMAT(sa.sale_date, '%Y-%m') 
                 ORDER BY SUM(sa.sale_price) DESC) AS monthly_rank
FROM sale sa
JOIN salesperson s ON sa.salesperson_id = s.salesperson_id
GROUP BY sale_month, s.salesperson_id, s.name
ORDER BY sale_month, monthly_rank;


-- Identifying a Slow Query

SELECT 
    b.name AS brand_name,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.sale_price) AS total_revenue
FROM sale s
JOIN vehicle v ON s.vehicle_id = v.vehicle_id
JOIN model m ON v.model_id = m.model_id
JOIN brand b ON m.brand_id = b.brand_id
WHERE s.sale_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY b.name
ORDER BY total_revenue DESC;

-- Optimization Strategy 1 – Adding Composite Indexes:


-- Adding composite index on sale table to speed up joins and date-based filtering
CREATE INDEX idx_sale_vehicle_date ON sale (vehicle_id, sale_date);

-- Adding index on model table for join performance
CREATE INDEX idx_model_brand ON model (brand_id);

-- Adding index on brand name to optimize GROUP BY and ORDER BY operations
CREATE INDEX idx_brand_name ON brand (name);



-- Optimization Strategy 2 – Rewriting the Query Using a Precomputed View:


SELECT * FROM vw_sales_summary_by_brand
WHERE total_revenue > 30000
ORDER BY total_revenue DESC;
