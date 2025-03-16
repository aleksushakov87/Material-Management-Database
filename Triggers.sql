-- TRIGGERS --
-- the trigger below updates INVENTORY Qty_available everytime when
-- when material received (MRR, MRR_LINE INSERT) from SUPPLIER 
-- or returned (MRN, MRN_LINE) by SUBCONTRACTOR
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