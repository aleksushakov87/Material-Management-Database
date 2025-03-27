/*
    TRIGGERS – Inventory Auto-Update

    This section defines two triggers that **automatically update the INVENTORY table**
    whenever materials are either received from a supplier (via MRR) or returned by a subcontractor (via MRN).

    1. TRIGGER: INV_INSERT_1
       - Event: AFTER INSERT on MRR_LINE (Material receiving report document)
       - Action: Increases `qty_available` in INVENTORY based on the received quantity.
       - If no inventory record exists for the item and warehouse, a new one is created.

    2. TRIGGER: INV_INSERT_2
       - Event: AFTER INSERT on MRN_LINE (Material return note document)
       - Action: Increases `qty_available` in INVENTORY based on the returned quantity.
       - Also creates a new inventory record if it doesn’t exist.

    These triggers ensure that the INVENTORY table remains accurate and up-to-date
    with real-time changes from receiving or returning materials.
*/

DELIMITER $$

CREATE TRIGGER INV_INSERT_1
AFTER INSERT ON MRR_LINE
FOR EACH ROW
BEGIN
    DECLARE inventory_count INT;
    DECLARE new_inventory_id INT;

    -- Check if item exists in inventory
    SELECT COUNT(*) INTO inventory_count 
    FROM INVENTORY 
    WHERE item_id = NEW.item_id AND warehouse_id = NEW.warehouse_id;

    -- If inventory exists, update it
    IF inventory_count > 0 THEN
        UPDATE INVENTORY 
        SET qty_available = qty_available + NEW.received_qty
        WHERE item_id = NEW.item_id AND warehouse_id = NEW.warehouse_id;
    ELSE
        -- Get a new inventory ID without selecting from the same table in the INSERT
        SELECT COALESCE(MAX(inventory_id) + 1, 100) INTO new_inventory_id FROM (SELECT inventory_id FROM INVENTORY) AS temp_table;

        -- Insert a new inventory record
        INSERT INTO INVENTORY (inventory_id, item_id, warehouse_id, qty_available)
        VALUES (new_inventory_id, NEW.item_id, NEW.warehouse_id, NEW.received_qty);
    END IF;
END $$

CREATE TRIGGER INV_INSERT_2
AFTER INSERT ON MRN_LINE
FOR EACH ROW
BEGIN
    DECLARE inventory_count INT;
    DECLARE new_inventory_id INT;

    -- Check if item exists in inventory
    SELECT COUNT(*) INTO inventory_count 
    FROM INVENTORY 
    WHERE item_id = NEW.item_id AND warehouse_id = NEW.warehouse_id;

    -- If inventory exists, update it
    IF inventory_count > 0 THEN
        UPDATE INVENTORY 
        SET qty_available = qty_available + NEW.returned_qty
        WHERE item_id = NEW.item_id AND warehouse_id = NEW.warehouse_id;
    ELSE
        -- Get a new inventory ID without selecting from the same table in the INSERT
        SELECT COALESCE(MAX(inventory_id) + 1, 100) INTO new_inventory_id FROM (SELECT inventory_id FROM INVENTORY) AS temp_table;

        -- Insert a new inventory record
        INSERT INTO INVENTORY (inventory_id, item_id, warehouse_id, qty_available)
        VALUES (new_inventory_id, NEW.item_id, NEW.warehouse_id, NEW.returned_qty);
    END IF;
END $$

DELIMITER ;