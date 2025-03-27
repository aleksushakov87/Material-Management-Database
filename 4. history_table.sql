/*
    WAREHOUSE_CHANGE – Inventory Movement History Table

    Purpose:
    This table is designed to keep a history log of inventory movements between warehouses.
    Every time the `warehouse_id` of a record in the `INVENTORY` table is updated (i.e., an item 
    is physically moved to a different warehouse), a corresponding entry is made in the 
    `WAREHOUSE_CHANGE` table.

    Structure:
    - wrhse_change_id     → Auto-incremented unique ID for each transfer log entry.
    - old_warehouse       → ID of the warehouse from which the item was moved.
    - new_warehouse       → ID of the warehouse to which the item was moved.
    - inventory_id        → Reference to the INVENTORY record being updated.
    - date_of_transfer    → Date the warehouse change was recorded (via trigger).
    - FK Constraint       → Ensures that inventory_id exists in the INVENTORY table.

    How It Works:
    1. The `WrhseChangeTrigger` is fired **before any update** on the `INVENTORY` table.
    2. If the `warehouse_id` value changes, it triggers the following:
       - A new ID is generated using `MAX() + 1` (alternative to AUTO_INCREMENT).
       - A new row is inserted into `WAREHOUSE_CHANGE`, capturing:
           • Previous warehouse (`OLD.warehouse_id`)
           • New warehouse (`NEW.warehouse_id`)
           • Affected inventory item (`NEW.inventory_id`)
           • Current date of transfer (`CURDATE()`)
*/
-- Create WAREHOUSE_CHANGE table if it doesn't exist
CREATE TABLE IF NOT EXISTS WAREHOUSE_CHANGE (
    wrhse_change_id DECIMAL(12) NOT NULL,
    old_warehouse DECIMAL(12) NOT NULL,
    new_warehouse DECIMAL(12) NOT NULL,
    inventory_id DECIMAL(12) NOT NULL,
    date_of_transfer DATE NOT NULL,
    CONSTRAINT fk_whse_chg_to_inv FOREIGN KEY(inventory_id) REFERENCES INVENTORY(inventory_id)
);

-- Drop trigger if it already exists
DROP TRIGGER IF EXISTS WrhseChangeTrigger;

-- Create trigger to log warehouse changes
DELIMITER $$

CREATE TRIGGER WrhseChangeTrigger
BEFORE UPDATE ON INVENTORY
FOR EACH ROW
BEGIN
    DECLARE new_id INT;

        -- Check if warehouse_id is being changed
    IF OLD.warehouse_id <> NEW.warehouse_id THEN
        -- Generate new wrhse_change_id
        SELECT IFNULL(MAX(wrhse_change_id) + 1, 1)  -- if no record exist (wrhse_change_id is NULL) then wrhse_change_id = 1, otherwise 
													-- the last wrhse_change_id + 1
        INTO new_id 
        FROM WAREHOUSE_CHANGE;

        -- Insert change record
        INSERT INTO WAREHOUSE_CHANGE (
            wrhse_change_id,
            old_warehouse,
            new_warehouse,
            inventory_id,
            date_of_transfer
        )
        VALUES (
            new_id,
            OLD.warehouse_id,
            NEW.warehouse_id,
            NEW.inventory_id,
            CURDATE()
        );
    END IF;
END $$

DELIMITER ;
