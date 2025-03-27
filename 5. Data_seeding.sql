/*
    DATA SEEDING – Material Management System

    This script populates core tables with initial data to support testing and demonstration 
    of the Material Management System. 

    Breakdown of Insertions:
    --------------------------------------------------------------
    1. LOCATION_ and WAREHOUSE: Define physical storage areas.
    2. RoleTable and UserAccount: Setup of user roles and accounts.
    3. SUBCONTRACTOR and SUPPLIER: Stakeholders involved in material flow.
    4. ITEM: Detailed catalog of materials with descriptions and specs.
    5. PURCHASE_ORDER and PO_LINE: Simulated procurement transactions.
    6. MRR and MRR_LINE: Records of received materials from suppliers.
    7. FMR: Requests for materials by subcontractors.
    8. SafeInsertFMRLine: Procedure calls to insert FMR_LINE records and update inventory safely.

    Purpose:
    ----------------------------------------------------------------
    - To provide a pre-filled database for development, testing, or demonstration.
    - To simulate real-world scenarios of material procurement, receiving, and issuing.
    - To test triggers and procedures that maintain inventory accuracy.
*/

INSERT INTO LOCATION_ (location_id, loc_name)
VALUES 
(1, 'Area_1'),
(2, 'Area_2');

INSERT INTO WAREHOUSE (warehouse_id, location_id, w_name)
VALUES 
(1, 2,  'WHSE_1'),
(2, 1, 'WHSE_2');

INSERT INTO RoleTable (role_id, r_description)
VALUES 
(1, 'warehouse technician'),
(2, 'procurement technician');

INSERT INTO UserAccount (account_id, role_id, first_name, last_name, email, phone, username, ac_password)				
VALUES 
(1, 1, 'Aleksei', 'Ushakov', 'aushakov@bu.edu', 4251111111, 'aleks_bu', 'trf,hm_2023'),			
(2, 1, 'John', 'Smith', 'johnsmith@bu.edu', 4252222222, 'john_sm', 'Yjz,hm_2023');				

INSERT INTO SUBCONTRACTOR(subcontractor_id, subc_name, head_of_material_dep, phone)
VALUES 
(1,  'VLS',  'Joanna Gonzalez', 6014445555),
(2,  'RHI',  'Raul Hendricks', 6013332222),
(3,  'SNEMA',  'August Simpson', 6015556666);

INSERT INTO SUPPLIER (supplier_id, s_name, address, phone, fax, email)
VALUES 
(1, 'ORTON SRL',  'Via Dei Bazachi 50, 29010 Piacenza,  29121 Piacenza, Italy', 523762511, 523762512,  'last@ortonvalve.com'),
(2, 'JIANGSU WUJIN STA',  'Wucheng West Road Zhenglu Town, CHANGZHOU, JNG 213111', 1988931051, 1988732150,  'sales@wjss.com.cn'),
(3, 'TROUVAY CAUVIN GU',  '62 Rue Marceau, Le Havre, Normandy, 76600, France', 235213470, 235213470,  'info@trouvaycauvin.com'),
(4, 'CARRARA SPA',  '28 Via Napoli, Bussero, Lombardy, 20060, Italy', 307451121, 307451121,  'info@carrara.it');

INSERT INTO ITEM (item_id, it_description, it_category, ident_code, weight_per_unit_kg, unit_of_measure)
VALUES 
(1, '16 IN Spiral Wound Gasket, ASME B16.20, AISI 304/Graphite, RF as per ASME B16.5, 300 Lbs, Thk=4.5mm, Inner AISI 304/Outer CS, Design temperature at -52 degC', 'Gasket', 'C1J9LXY4', 34, 'EA'),
(2, '6 IN Spiral Wound Gasket, Low Stress, ASME B16.20, AISI 304/Graphite, RF as per ASME B16.5, 150 Lbs, Thk=4.5mm, Inner AISI 304/Outer CS, Design temperature at -52 degC', 'Gasket', 'C1TJPF26', 34, 'EA'),
(3, '34 IN x 31.75MM EFW + 100% RT, Pipes, ASME B36.19/B36.10, ASTM A358 Gr.304/304L Cl.1, BE, Impact tested as per JSS', 'Pipe', 'C3008436', 7240, 'M'),
(4, '10 IN x 11.13MM EFW + 100% RT, Pipes, ASME B36.19/B36.10, ASTM A358 Gr.304/304L Cl.1, BE, Impact tested as per JSS', 'Pipe', 'C30083F3', 824, 'M'),
(5, '12 IN Butterfly Valve Flanged Ends, Short Pattern, API 609 Cat.B where applicable, Seat Leakage as per ISO 5208 Rate A, ASTM A352 Gr.LCC, 900 Lbs, RTJ Faces, Ends as per ASME B16.5, Eccentric Disc - Triple Offset Type', 'Valve', 'C2KTRVY9', 2530, 'EA'),
(6, '12 IN Butterfly Valve Flanged Ends, Short Pattern, API 609 Cat.B where applicable, Seat Leakage as per ISO 5208 Rate A, ASTM A352 Gr.LCC + PWHT + Sour Service, 900 Lbs, RTJ Faces, Ends as per ASME B16.5, Eccentric Disc - Triple Offset Type', 'Valve', 'C2KTT34R', 2530, 'EA'),
(7, '10 IN Butterfly Valve Flanged Ends, Short Pattern, API 609 Cat.B where applicable, Seat Leakage as per ISO 5208 Rate A, ASTM A351 Gr.CF8, 900 Lbs, RTJ Faces, Ends as per ASME B16.5, Eccentric Disc - Triple Offset Type', 'Valve', 'C1UC59KP', 3970, 'EA'),
(8, '6 IN x S-40 Weldneck Flange, ASME B16.5, ASTM A350 Gr.LF2 Cl.1, 150 Lbs, RF/BW End, Design temperature at -52 degC', 'Flange', 'C1TJPC8N', 164, 'EA'),
(9, '16 IN x S-20 Weldneck Flange, ASME B16.5, ASTM A350 Gr.LF2 Cl.1, 300 Lbs, RF/BW End, Design temperature at -52 degC', 'Flange', 'C1TJPCGN', 164, 'EA'),
(10, '2 IN x S-40 Weldneck Flange, ASME B16.5, ASTM A350 Gr.LF2 Cl.1, 600 Lbs, RTJ Face/BW End, Design temperature at -52 degC', 'Flange', 'C1TJPDEJ', 164, 'EA');

INSERT INTO PURCHASE_ORDER (po_id, supplier_id, account_id, date_of_order)
VALUES 
(1, 4, 2, '2022-12-17'),
(2, 2, 2, '2023-03-17'),
(3, 1, 2, '2023-06-15'),
(4, 3, 2, '2022-12-10');

INSERT INTO PO_LINE (po_line_id, po_id, item_id, ordered_qty, price, ETA_date)
VALUES
(1, 1, 1, 1000, 30, '2023-12-17'),
(2, 1, 2, 500, 40, '2023-11-16'),
(3, 4, 3, 500, 2000, '2023-11-16'),
(4, 2, 4, 1200, 1000, '2023-10-15'),
(5, 3, 5, 50, 5000, '2023-08-17'),
(6, 3, 6, 100, 5000, '2023-11-10'),
(7, 3, 7, 200, 4500, '2023-12-10');



INSERT INTO MRR (mrr_id, account_id, po_line_id, date_of_mrr, received_by)
VALUES
(1, 1, 1, '2023-12-16', 'Adler Austin'),
(2, 1, 2, '2023-12-16', 'Adler Austin'),
(3, 1, 3, '2023-12-16', 'Adler Austin'),
(4, 1, 4, '2023-12-16', 'Adler Austin'),
(5, 1, 5, '2023-12-16', 'Brantley Fry'),
(6, 1, 6, '2023-12-16', 'Brantley Fry');

INSERT INTO MRR_LINE (mrr_id_line, mrr_id, item_id, warehouse_id, received_qty)
VALUES 
(1, 1, 1, 1, 500),
(2, 2, 2, 1, 250),
(3, 3, 3, 1, 300),
(4, 4, 4, 2, 700),
(5, 5, 5, 2, 30),
(6, 6, 6, 2, 50),
(7, 1, 1, 1, 500),
(8, 4, 4, 2, 500);

INSERT INTO FMR (fmr_id, subcontractor_id, account_id, fmr_number, requested_by, received_by, date_of_fmr)
VALUES
(1, 1, 1,  'VLS-1',  'Lochlan Stephenson',  'Lochlan Stephenson', '2023-12-17'),
(2, 2, 1,  'RHI-1',  'Alex Diaz',  'Alex Diaz', '2023-12-17'),
(3, 3, 1,  'SNEMA-1',  'Iris Warren',  'Iris Warren', '2023-12-17');

CALL SafeInsertFMRLine(2, 1, 2, 1, 100, 100);
CALL SafeInsertFMRLine(3, 1, 4, 2, 55, 55);
CALL SafeInsertFMRLine(4, 1, 5, 2, 10, 10);
CALL SafeInsertFMRLine(5, 2, 5, 2, 30, 30);
CALL SafeInsertFMRLine(6, 2, 4, 2, 100, 100);
CALL SafeInsertFMRLine(1, 1, 1, 2, 350, 350);
CALL SafeInsertFMRLine(7, 3, 6, 2, 45, 45);