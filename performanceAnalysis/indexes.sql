-- Create an index on the `customer_id` column in the `olist_customers_dataset` table
ALTER TABLE olist_customers_dataset ADD INDEX idx_customers_customer_id (customer_id);

-- Create an index on the `order_id` column in the `olist_orders_dataset` table
ALTER TABLE olist_orders_dataset ADD INDEX idx_orders_order_id (order_id);

-- Create an index on the `customer_id` column in the `olist_orders_dataset` table
ALTER TABLE olist_orders_dataset ADD INDEX idx_orders_customer_id (customer_id);

-- Create an index on the `order_purchase_timestamp` column in the `olist_orders_dataset` table
ALTER TABLE olist_orders_dataset ADD INDEX idx_orders_order_purchase_timestamp (order_purchase_timestamp);

-- Create an index on the `product_id` column in the `olist_products_dataset` table
ALTER TABLE olist_products_dataset ADD INDEX idx_products_product_id (product_id);

-- Create an index on the `order_id` column in the `olist_order_items_dataset` table
ALTER TABLE olist_order_items_dataset ADD INDEX idx_order_items_order_id (order_id);

-- Create an index on the `product_id` column in the `olist_order_items_dataset` table
ALTER TABLE olist_order_items_dataset ADD INDEX idx_order_items_product_id (product_id);
