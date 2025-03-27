/*
    REPORTING SCRIPT – Material Management System

    This script generates a set of key reports that provide visibility into inventory levels, 
    material issuance, purchase order fulfillment, and distribution breakdown by subcontractor 
    and material category.
    
     These reports support operational visibility, accountability, and decision-making in 
    materials management.
*/

/*
1. 📦 Inventory Report
	- Displays current stock levels by item, warehouse, and location.
	- Useful for stock audits and warehouse planning.
*/
SELECT it.ident_code, 
       it.it_description, 
       inv.qty_available, 
       it.unit_of_measure, 
       w.w_name,
       l.loc_name
FROM ITEM it
JOIN INVENTORY inv ON inv.item_id = it.item_id
JOIN WAREHOUSE w ON w.warehouse_id = inv.warehouse_id
JOIN LOCATION_ l ON l.location_id = w.location_id;


/*
2. 📤 Issue Report
	- Shows details of materials issued via FMRs (Field Material Requests).
	- Includes subcontractor info, quantities issued, item details, and transaction dates.
*/

SELECT f.fmr_number, 
	   s.subc_name, 
       it.ident_code, 
       it.it_description, 
       it.unit_of_measure, 
       fl.requested_qty, 
       fl.issued_qty, 
       f.received_by,
       f.date_of_fmr
FROM FMR f
JOIN SUBCONTRACTOR s on f.subcontractor_id = s.subcontractor_id
JOIN FMR_LINE fl on fl.fmr_id = f.fmr_id
JOIN ITEM it on it.item_id = fl.item_id
ORDER BY f.fmr_number;


/*
3. 🧾 Purchase Order Status Report
       - Tracks the delivery status of materials ordered from suppliers.
       - Highlights undelivered items with a "NOT DELIVERED" label.
       - Helps procurement teams monitor pending receipts.
*/
SELECT purchase_order.po_id, 
	   item.it_category, 
       item.ident_code, 
       po_line.ordered_qty,
       COALESCE (mrr.mrr_id, 'NOT DELIVERED') AS MRR_ID,
       COALESCE (mrr_line.received_qty, 'NOT DELIVERED') AS RECEIVED_QTY, 
       COALESCE (mrr.date_of_mrr, 'NOT DELIVERED') AS DATE_OF_MRR
FROM PURCHASE_ORDER
JOIN PO_LINE ON PO_LINE.po_id = purchase_order.po_id
JOIN ITEM ON item.item_id = po_line.item_id
LEFT JOIN MRR ON mrr.po_line_id = po_line.po_line_id
LEFT JOIN MRR_LINE ON mrr_line.mrr_id = mrr.mrr_id
ORDER BY mrr.date_of_mrr DESC;

/*
4. ⚖️ Issued Weight Breakdown (by Subcontractor & Category)
	- Summarizes total material issued (in tons) grouped by subcontractor and item category.
	- Supports analytics on material consumption patterns for reporting or billing.
*/
SELECT subcontractor.subc_name, 
	   item.it_category, 
       SUM(fmr_line.issued_qty * item.weight_per_unit_kg)/1000 AS total_weight_ton
FROM SUBCONTRACTOR
JOIN FMR ON fmr.subcontractor_id = subcontractor.subcontractor_id
JOIN FMR_LINE ON fmr_line.fmr_id = fmr.fmr_id
JOIN ITEM ON item.item_id = fmr_line.item_id
GROUP BY subcontractor.subc_name, item.it_category
ORDER BY subc_name;