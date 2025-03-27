/*
    PROCEDURE: SafeInsertFMRLine

    Description:
    This procedure handles safe insertion of material requests (FMR lines (based on Field Material Receiving document)) 
    and ensures accurate updates to the INVENTORY table based on current stock availability. It covers three key scenarios:

    CASE 1: Inventory Record Not Found
      - Action:
        • Inserts a line into FMR_LINE with issued_qty = 0
        • Does NOT update INVENTORY
        • Returns a warning message

    CASE 2: Insufficient Inventory (available_qty < requested_qty)
      - Action:
        • Inserts a line into FMR_LINE with issued_qty = available_qty
        • Updates INVENTORY to qty_available = 0
        • Returns a warning message with suggestion

    CASE 3: Sufficient Inventory (available_qty ≥ requested_qty)
      - Action:
        • Inserts a line into FMR_LINE with full issued_qty
        • Updates INVENTORY by subtracting requested_qty
        • Returns a success message

    Parameters:
      - p_fmr_line_id      → ID for new FMR_LINE record
      - p_fmr_id           → Associated FMR number record
      - p_item_id          → Requested item
      - p_warehouse_id     → Warehouse location
      - p_requested_qty    → Quantity requested by the user
      - p_issued_qty       → Quantity to issue (same as requested if enough stock)

    Purpose:
    Ensures that FMRs are processed without causing negative inventory, and alerts the user if stock is insufficient.
*/

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