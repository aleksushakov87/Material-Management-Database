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

# The structural database rules
The structural database rules are listed below:
1. One **ROLE** is associated with one **UserAccount**, one **UserAccount** can be associated with many **ROLEs**
2. Each **SUPPLIER** is associated with zero or many **PO**s, each **PO** is associated with only one SUPPLIER
3. Each **PO** may contain at least one **P_LINE**, one **POLINE** is associated with only one **PO**
4. One **PO_LINE** may contain just one **ITEM**. One **ITEM** is associated with many **PO_LINE**s
5. One **SUBCONTRACTOR** can submit at least one **FMR**. One **FMR** is associated with only one **SUBCONTRACTOR**
6. Each **FMR** may contain at least one **FMR_LINE**, one **FMR_LINE** is associated with only one **FMR**
7. One **FMR_LINE** may contain just one **ITEM**. One **ITEM** is associated with one or many **FMR_LINE**s
8. One **FMR_LINE** is associated with only one **WAREHOUSE**. At least one **WAREHOUSE** associated with one **FMR_LINE**
9. One **SUBCONTRACTOR** can submit at least one **MRN**. One **MRN** is associated with only one **SUBCONTRACTOR**
10. Each **MRN** may contain at least one **MRN_LINE**, one **MRN_LINE** is associated with only one **MRN**
11. One **MRN_LINE** may contain just one **ITEM**. One **ITEM** is associated with one or many **MRN_LINE**s
12. One **MRN_LINE** is associated with only one **WAREHOUSE**. At least one **WAREHOUSE** associated with one **MRN_LINE**
13. One **MRR** is associated with only one **PO_LINE**, one **PO_LINE** is associated with one **MRR_LINE**
14. Each **MRR** may contain at least one **MRR_LINE**, one **MRR_LINE** is associated with only one **MRR**
15. One **MRR_LINE** may contain just one **ITEM**. One **ITEM** is associated with one or many **MRR_LINES**
16. One **MRR_LINE** is associated with only one **WAREHOUSE**. At least one **WAREHOUSE** associated with one **MRR_LINE**
17. One **ITEM** is associated with one or many **INVENTORY** lines, one **INVENTORY** line is associated with only one **ITEM**
18. One **INVENTORY** record associated with only one **WAREHOUSE**, one **WAREHOUSE** associated with 0 or more **INVENTORY** lines.
19. One **WAREHOUSE** is associated with only one **LOCATION**, **LOCATION** with the same name can be designated in many **WAREHOSES**

