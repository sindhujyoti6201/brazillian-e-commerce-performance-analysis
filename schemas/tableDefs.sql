-- Drop the database if it exists
DROP DATABASE IF EXISTS brazilian_ecommerce_test_db;

-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS brazilian_ecommerce_test_db;

-- Switch to the new database
USE brazilian_ecommerce_test_db;

-- Drop existing tables before creating new ones
DROP TABLE IF EXISTS olist_customers_dataset;
DROP TABLE IF EXISTS olist_geolocation_dataset;
DROP TABLE IF EXISTS olist_order_items_dataset;
DROP TABLE IF EXISTS olist_order_payments_dataset;
DROP TABLE IF EXISTS olist_order_reviews_dataset;
DROP TABLE IF EXISTS olist_orders_dataset;
DROP TABLE IF EXISTS olist_products_dataset;
DROP TABLE IF EXISTS olist_sellers_dataset;
DROP TABLE IF EXISTS product_category_name_translation;

CREATE TABLE olist_customers_dataset (
                                         customer_id VARCHAR(50),           -- Unique identifier for the customer
                                         customer_unique_id VARCHAR(50),    -- Unique customer key (nullable)
                                         customer_zip_code_prefix VARCHAR(20), -- ZIP code prefix (nullable)
                                         customer_city VARCHAR(255),         -- City of the customer (nullable)
                                         customer_state CHAR(2)             -- State of the customer (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_sellers_dataset (
                                       seller_id VARCHAR(50),            -- Unique identifier for each seller
                                       seller_zip_code_prefix VARCHAR(10), -- Seller's zip code prefix (nullable)
                                       seller_city VARCHAR(100),          -- City where the seller is located (nullable)
                                       seller_state VARCHAR(50)           -- State where the seller is located (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_geolocation_dataset (
                                           geolocation_zip_code_prefix VARCHAR(20), -- Prefix of the zip code (nullable)
                                           geolocation_lat DECIMAL(10, 8),         -- Latitude coordinate (nullable)
                                           geolocation_lng DECIMAL(11, 8),         -- Longitude coordinate (nullable)
                                           geolocation_city VARCHAR(100),          -- City name (nullable)
                                           geolocation_state CHAR(2)               -- State abbreviation (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_orders_dataset (
                                      order_id VARCHAR(50),                 -- Unique identifier for the order
                                      customer_id VARCHAR(50),              -- Customer ID (nullable)
                                      order_status VARCHAR(50),             -- Order status (nullable)
                                      order_purchase_timestamp TIMESTAMP NOT NULL, -- Timestamp when the order was purchased
                                      order_approved_at TIMESTAMP,          -- Timestamp when the order was approved (nullable)
                                      order_delivered_carrier_date TIMESTAMP, -- Timestamp when the order was delivered to the carrier (nullable)
                                      order_delivered_customer_date TIMESTAMP, -- Timestamp when the order was delivered to the customer (nullable)
                                      order_estimated_delivery_date TIMESTAMP NOT NULL -- Estimated delivery date (nullable)
) ENGINE=InnoDB;

CREATE TABLE product_category_name_translation (
                                                   product_category_name VARCHAR(100), -- Original product category name
                                                   product_category_name_english VARCHAR(100) -- English translation of the category name (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_products_dataset (
                                        product_id VARCHAR(50),           -- Unique identifier for each product
                                        product_category_name VARCHAR(100), -- Category of the product (nullable)
                                        product_name_length INT,          -- Length of the product name (nullable)
                                        product_description_length INT,   -- Length of the product description (nullable)
                                        product_photos_qty INT,           -- Number of photos associated with the product (nullable)
                                        product_weight_g INT,             -- Weight of the product in grams (nullable)
                                        product_length_cm INT,            -- Length of the product in centimeters (nullable)
                                        product_height_cm INT,            -- Height of the product in centimeters (nullable)
                                        product_width_cm INT             -- Width of the product in centimeters (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_order_items_dataset (
                                           order_id VARCHAR(50),             -- Order ID (nullable)
                                           order_item_id INT NOT NULL,       -- Identifier for items in the same order
                                           product_id VARCHAR(50),           -- Product ID (nullable)
                                           seller_id VARCHAR(50),            -- Seller ID (nullable)
                                           shipping_limit_date TIMESTAMP NOT NULL, -- Shipping deadline (nullable)
                                           price DECIMAL(10, 2),             -- Item price (nullable)
                                           freight_value DECIMAL(10, 2)      -- Freight cost (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_order_payments_dataset (
                                              order_id VARCHAR(50),             -- Order ID (nullable)
                                              payment_sequential INT NOT NULL,  -- Sequential number for each payment
                                              payment_type VARCHAR(50),        -- Payment type (nullable)
                                              payment_installments INT,        -- Number of installments for the payment (nullable)
                                              payment_value DECIMAL(10, 2)     -- Payment amount (nullable)
) ENGINE=InnoDB;

CREATE TABLE olist_order_reviews_dataset (
                                             review_id VARCHAR(50) NOT NULL,         -- Unique identifier for each review
                                             order_id VARCHAR(50),                   -- Order ID (nullable)
                                             review_score INT,                       -- Review score (nullable)
                                             review_comment_title TEXT,              -- Title of the review comment (nullable)
                                             review_comment_message TEXT,            -- Message of the review comment (nullable)
                                             review_creation_date DATETIME NOT NULL, -- Date when the review was created
                                             review_answer_timestamp DATETIME       -- Timestamp for when the review was answered (nullable)
) ENGINE=InnoDB;
