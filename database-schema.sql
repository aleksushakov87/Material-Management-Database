-- Dropping database if exist
DROP DATABASE IF EXISTS `Material_Management_System`;

-- Creating a new database
CREATE DATABASE `Material_Management_System`;
USE `Material_Management_System`;

-- CREATING ALL ENTITIES
-- Creating a ROLE table. Defining the Primary key
CREATE TABLE RoleTable (
role_id DECIMAL(12) NOT NULL PRIMARY KEY,
r_description VARCHAR(64) NOT NULL);

-- Creating a User Account table. Defining the Primary key
CREATE TABLE UserAccount (
account_id DECIMAL(12) NOT NULL PRIMARY KEY,
role_id DECIMAL(12) NOT NULL,
first_name VARCHAR(64) NOT NULL,
last_name VARCHAR(64) NOT NULL,
email VARCHAR(64) NOT NULL,
phone DECIMAL(10),
username VARCHAR(32) NOT NULL,
ac_password VARCHAR(12) NOT NULL);

-- Creating a Subcontractor table. Defining the Primary key
CREATE TABLE SUBCONTRACTOR (
subcontractor_id DECIMAL(12) NOT NULL PRIMARY KEY,
subc_name VARCHAR(64) NOT NULL,
head_of_material_dep VARCHAR(64) NOT NULL,
phone DECIMAL(10));

-- Creating a FMR (Field Material Receive) table. Defining the Primary key
CREATE TABLE FMR (
fmr_id DECIMAL(12) NOT NULL PRIMARY KEY,
subcontractor_id DECIMAL(12) NOT NULL,
account_id DECIMAL(12) NOT NULL,
fmr_number VARCHAR(32) NOT NULL,
requested_by VARCHAR(64),
received_by VARCHAR(64) NOT NULL,
date_of_fmr DATE);

-- Creating a MRN (Material return note) table. Defining the Primary key
CREATE TABLE MRN (
mrn_id DECIMAL(12) NOT NULL PRIMARY KEY,
subcontractor_id DECIMAL(12) NOT NULL,
account_id DECIMAL(12) NOT NULL,
returned_by VARCHAR(64),
date_of_mrn DATE);

-- Creating FMR_LINE table (the content of each FMR). 
CREATE TABLE FMR_LINE (
fmr_line_id DECIMAL(12) NOT NULL PRIMARY KEY,
fmr_id DECIMAL(12) NOT NULL,
item_id DECIMAL(12) NOT NULL,
warehouse_id DECIMAL(12) NOT NULL,
requested_qty DECIMAL(12) NOT NULL,
issued_qty DECIMAL(12) NOT NULL);

-- Creating MRN_LINE table (the content of each MRN)
CREATE TABLE MRN_LINE (
mrn_line_id DECIMAL(12) NOT NULL PRIMARY KEY,
mrn_id DECIMAL(12) NOT NULL,
item_id DECIMAL(12) NOT NULL,
warehouse_id DECIMAL(12) NOT NULL,
returned_qty DECIMAL(12) NOT NULL);

-- Creating a Supplier table
CREATE TABLE SUPPLIER (
supplier_id DECIMAL(12) NOT NULL PRIMARY KEY,
s_name VARCHAR(64) NOT NULL,
address VARCHAR(64),
phone DECIMAL(10),
fax DECIMAL(10),
email VARCHAR(64));

-- Creating PO (purchase order) table
CREATE TABLE PURCHASE_ORDER (
po_id DECIMAL(12) NOT NULL PRIMARY KEY,
supplier_id DECIMAL(12) NOT NULL,
account_id DECIMAL(12) NOT NULL,
date_of_order DATE);

CREATE TABLE PO_LINE (
po_line_id DECIMAL(12) NOT NULL PRIMARY KEY,
po_id DECIMAL(12) NOT NULL,
item_id DECIMAL(12) NOT NULL,
ordered_qty DECIMAL(12) NOT NULL,
price DECIMAL (12,3) NOT NULL,
ETA_date DATE);

-- Creating MRR (Material receiving report) table
CREATE TABLE MRR (
mrr_id DECIMAL(12) NOT NULL PRIMARY KEY,
po_line_id DECIMAL(12) NOT NULL, 
account_id DECIMAL(12) NOT NULL,
date_of_mrr DATE NOT NULL,
received_by VARCHAR(64) NOT NULL);

-- Creating MRR_LINE (the content of each MRR)
CREATE TABLE MRR_LINE (
mrr_id_line DECIMAL(12) NOT NULL PRIMARY KEY,
mrr_id DECIMAL(12) NOT NULL,
item_id DECIMAL(12) NOT NULL,
warehouse_id DECIMAL(12) NOT NULL,
received_qty DECIMAL(12) NOT NULL);

-- Creating ITEM table (information about items)
CREATE TABLE ITEM (
item_id DECIMAL(12) NOT NULL PRIMARY KEY,
it_description VARCHAR(252) NOT NULL,
it_category VARCHAR(64),
ident_code VARCHAR(8) NOT NULL,
weight_per_unit_kg DECIMAL(12),
unit_of_measure VARCHAR(10) NOT NULL);

-- Creating INVENTORY table (this table will be filled after INSERT/UPDATE of MRR, FMR, MRN)
CREATE TABLE INVENTORY (
inventory_id DECIMAL(12) NOT NULL PRIMARY KEY,
item_id DECIMAL(12) NOT NULL,
warehouse_id DECIMAL(12) NOT NULL,
qty_available DECIMAL(12) NOT NULL);

-- Creating a WAREHOUSE table
CREATE TABLE WAREHOUSE (
warehouse_id DECIMAL(12) NOT NULL PRIMARY KEY,
location_id DECIMAL(12) NOT NULL,
w_name VARCHAR(32) NOT NULL);

-- Creating the LOCATION table (the place in the warehouse)
CREATE TABLE LOCATION_ (
location_id DECIMAL(12) NOT NULL PRIMARY KEY,
loc_name VARCHAR(32) NOT NULL);

-- CREATING FOREIGN KEYS for each entity
ALTER TABLE UserAccount
ADD CONSTRAINT fk_account_to_role FOREIGN KEY(role_id) REFERENCES RoleTable(role_id);

ALTER TABLE FMR
ADD CONSTRAINT fk_fmr_to_subcontractor FOREIGN KEY(subcontractor_id) REFERENCES SUBCONTRACTOR(subcontractor_id),
ADD CONSTRAINT fk_fmr_to_account FOREIGN KEY(account_id) REFERENCES UserAccount(account_id);

ALTER TABLE MRN
ADD CONSTRAINT fk_mrn_to_subcontractor FOREIGN KEY(subcontractor_id) REFERENCES SUBCONTRACTOR(subcontractor_id),
ADD CONSTRAINT fk_mrn_to_account FOREIGN KEY(account_id) REFERENCES UserAccount(account_id);

ALTER TABLE PURCHASE_ORDER
ADD CONSTRAINT fk_po_to_supplier FOREIGN KEY(supplier_id) REFERENCES SUPPLIER(supplier_id),
ADD CONSTRAINT fk_po_to_account FOREIGN KEY(account_id) REFERENCES UserAccount(account_id);

ALTER TABLE FMR_LINE
ADD CONSTRAINT fk_fmrl_to_fmr FOREIGN KEY(fmr_id) REFERENCES FMR(fmr_id),
ADD CONSTRAINT fk_fmrl_to_item FOREIGN KEY(item_id) REFERENCES ITEM(item_id),
ADD CONSTRAINT fk_fmrl_to_warehouse FOREIGN KEY(warehouse_id) REFERENCES WAREHOUSE(warehouse_id);

ALTER TABLE MRN_LINE
ADD CONSTRAINT fk_mrnl_to_mrn FOREIGN KEY(mrn_id) REFERENCES MRN(mrn_id),
ADD CONSTRAINT fk_mrnl_to_item FOREIGN KEY(item_id) REFERENCES ITEM(item_id),
ADD CONSTRAINT fk_mrnl_to_warehouse FOREIGN KEY(warehouse_id) REFERENCES WAREHOUSE(warehouse_id);

ALTER TABLE PO_LINE
ADD CONSTRAINT fk_pol_to_po FOREIGN KEY(po_id) REFERENCES PURCHASE_ORDER(po_id),
ADD CONSTRAINT fk_pol_to_item FOREIGN KEY(item_id) REFERENCES ITEM(item_id);

ALTER TABLE MRR
ADD CONSTRAINT fk_mrr_to_account FOREIGN KEY(account_id) REFERENCES UserAccount(account_id),
ADD CONSTRAINT fk_mrr_to_po_line FOREIGN KEY(po_line_id) REFERENCES PO_LINE(po_line_id);

ALTER TABLE MRR_LINE
ADD CONSTRAINT fk_mrrl_to_mrr FOREIGN KEY(mrr_id) REFERENCES MRR(mrr_id),
ADD CONSTRAINT fk_mrrl_to_item FOREIGN KEY(item_id) REFERENCES ITEM(item_id),
ADD CONSTRAINT fk_mrrl_to_warehouse FOREIGN KEY(warehouse_id) REFERENCES WAREHOUSE(warehouse_id);

ALTER TABLE INVENTORY
ADD CONSTRAINT fk_inv_to_item FOREIGN KEY(item_id) REFERENCES ITEM(item_id),
ADD CONSTRAINT fk_inv_to_warehouse FOREIGN KEY(warehouse_id) REFERENCES WAREHOUSE(warehouse_id);

ALTER TABLE WAREHOUSE
ADD CONSTRAINT fk_wrhs_to_location FOREIGN KEY(location_id) REFERENCES LOCATION_(location_id);

-- CREATING INDEXES --
CREATE INDEX AccRoleIDidx
ON UserAccount (role_id);

CREATE INDEX FmrSubIDidx
ON FMR (subcontractor_id);

CREATE INDEX FmrAccIDidx
ON FMR (account_id);

CREATE INDEX MrnSubIDidx
ON MRN (subcontractor_id);

CREATE INDEX MrnAccIDidx
ON MRN (account_id);

CREATE INDEX FmrLineFmrIDidx
ON FMR_LINE (fmr_id);

CREATE INDEX FmrLineItemIDidx
ON FMR_LINE (item_id);

CREATE INDEX FmrLineWrhsIDidx
ON FMR_LINE (warehouse_id);

CREATE INDEX MrnLineMrnIDidx
ON MRN_LINE (mrn_id);

CREATE INDEX MrnLineItemIDidx
ON MRN_LINE (item_id);

CREATE INDEX MrnLineWrhsIDidx
ON MRN_LINE (warehouse_id);

CREATE INDEX POSupIDidx
ON PURCHASE_ORDER (supplier_id);

CREATE INDEX POAccIDidx
ON PURCHASE_ORDER (account_id);

CREATE INDEX PoLinePoIDidx
ON PO_LINE (po_id);

CREATE INDEX PoLineItemIDidx
ON PO_LINE (item_id);

CREATE INDEX MrrAccIDidx
ON MRR (account_id);

CREATE INDEX MrrLineMrrIDidx
ON MRR_LINE (mrr_id);

CREATE INDEX MrrLineItemIDidx
ON MRR_LINE (item_id);

CREATE INDEX MrrLineWrhsIDidx
ON MRR_LINE (warehouse_id);

CREATE INDEX InvItIDidx
ON INVENTORY (item_id);

CREATE INDEX InvWrhsIDidx
ON INVENTORY (warehouse_id);

CREATE INDEX WrhsLocIDidx
ON WAREHOUSE (location_id);

CREATE UNIQUE INDEX SubNameidx
ON SUBCONTRACTOR (subc_name);

CREATE INDEX FmrDateidx
ON FMR (date_of_fmr);

CREATE UNIQUE INDEX SupNameidx
ON SUPPLIER (s_name);

CREATE INDEX PoLineQtyidx
ON PO_LINE (ordered_qty);

CREATE UNIQUE INDEX ItIdentidx
ON ITEM (ident_code);

CREATE INDEX InvQtyAvidx
ON INVENTORY (qty_available);