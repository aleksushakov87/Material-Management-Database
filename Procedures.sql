-- This procedure ensures a safe insert into FMR and updates FMR_LINE and INVENTORY available_qty.
-- Three cases are considered:
-- 
-- 1. The requested material (ITEM) does not exist in the INVENTORY table.
--    - In this case, the procedure returns a WARNING and inserts a new line into FMR_LINE with received_qty = 0.
--    - NO updates in INVENTORY table
--
-- 2. The requested material (ITEM) exists in INVENTORY, but available_qty is less than requested_qty.
--    - The procedure returns a WARNING and inserts a new record into FMR_LINE with received_qty = available_qty.
--    - available_qty in the INVENTORY table is updated to 0.
-- 
-- 3. The requested material (ITEM) exists in INVENTORY, and available_qty is greater than or equal to requested_qty.
--    - The procedure returns a STATUS indicating that the INVENTORY has been successfully updated.
--    - A new record is inserted into FMR_LINE.
--    - The available_qty in the INVENTORY table is updated accordingly.

DELIMITER $$

CREATE PROCEDURE SafeInsertFMRLine(
    IN p_fmr_line_id INT,
    IN p_fmr_id INT, 
    IN p_item_id INT, 
    IN p_warehouse_id INT, 
    IN p_requested_qty DECIMAL(12,2), 
    IN p_issued_qty DECIMAL(12,2)
)
BEGIN
    DECLARE v_qty_available DECIMAL(12,2);
    DECLARE v_warning_message VARCHAR(255);

    -- Fetch available quantity from INVENTORY
    SELECT qty_available INTO v_qty_available
    FROM INVENTORY
    WHERE item_id = p_item_id AND warehouse_id = p_warehouse_id;

    -- No Inventory Record Exists
    IF v_qty_available IS NULL THEN
    
		-- We do not update Inventory, but make a record in FMR_LINE, issued_qty = 0
		INSERT INTO FMR_LINE (fmr_line_id, fmr_id, item_id, warehouse_id, requested_qty, issued_qty)
        VALUES (p_fmr_line_id, p_fmr_id, p_item_id, p_warehouse_id, p_requested_qty, 0);
        
        SET v_warning_message = '⚠️ Warning: No inventory record found for this item and warehouse.';
        SELECT v_warning_message AS Warning;
    
    -- Case 2: Requested Quantity is Greater Than Available
    ELSEIF p_requested_qty > v_qty_available THEN
		-- Reduce the Inventory amount to 0 (issue all available qty)
		UPDATE INVENTORY
        SET qty_available = 0
        WHERE item_id = p_item_id AND warehouse_id = p_warehouse_id;
        
        -- Insert new record in FMR_LINE (issued_qty = available_qty)
        INSERT INTO FMR_LINE (fmr_line_id, fmr_id, item_id, warehouse_id, requested_qty, issued_qty)
        VALUES (p_fmr_line_id, p_fmr_id, p_item_id, p_warehouse_id, p_requested_qty, v_qty_available);
        
        SET v_warning_message = CONCAT(
            '⚠️ Warning: Available quantity (', v_qty_available, 
            ') is less than requested quantity (', p_requested_qty, 
            '). Please check all warehouses and request a quantity less than or equal to available stock.'
        );
        SELECT v_warning_message AS Warning;
    
    -- Case 3: Inventory Available → Proceed with Insert
    ELSE
        -- Reduce available quantity in INVENTORY
        UPDATE INVENTORY
        SET qty_available = qty_available - p_requested_qty
        WHERE item_id = p_item_id AND warehouse_id = p_warehouse_id;

        -- Insert the row (only if quantity check passed)
        INSERT INTO FMR_LINE (fmr_line_id, fmr_id, item_id, warehouse_id, requested_qty, issued_qty)
        VALUES (p_fmr_line_id, p_fmr_id, p_item_id, p_warehouse_id, p_requested_qty, p_issued_qty);
        
        -- Confirmation Message
        SET v_warning_message = '✅ Insert Successful!';
        SELECT v_warning_message AS Status;
    END IF;
END $$

DELIMITER ;