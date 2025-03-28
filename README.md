# Material-Management-Database
The project was developed from scratch for MySQL. The goal was to create a basic inventory management system that allows tracking the movement of all project materials and maintaining an accurate stock record, including ordered materials, materials under shipment, received items, issued items, and transfers between warehouses.

# Description
This DBMS should allow updating, storing, and retrieving:
- Data on purchase order (PO) details, including item information, quantity, etc.
- Status of delivery and receipt of materials on-site.
- Status of material requests (issuance), including item details, quantity, subcontractor information, number of requests, and dates.
- Information on actual inventory

# Supported Database Servers
MySQL

# Data Model
![erd](https://github.com/user-attachments/assets/9988e598-0c4d-4ac5-a8c8-5d30fe59cd4e)

# Project Structure
- `database-schema.sql`: Defines all tables, relationships, and constraints.
- `Procedures.sql`: Contains stored procedures such as SafeInsertFMRLine.
- `Triggers.sql`: Defines triggers for inventory updates.
- `history_table.sql`: Creates WAREHOUSE_CHANGE table and logging trigger.
- `Data_seeding.sql`: Populates the database with sample data.
- `Reports.sql`: Generates inventory, issue, and PO reports.

# How To Run the Project
1. Run `database-schema.sql` to create the database structure.
2. Run `Procedures.sql`, `Triggers.sql`, and `history_table.sql` to set up logic.
3. Run `Data_seeding.sql` to insert test data.
4. Use `Reports.sql` to view example queries and results.

