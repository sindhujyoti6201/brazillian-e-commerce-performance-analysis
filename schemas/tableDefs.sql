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
                                         customer_id VARCHAR(50) PRIMARY KEY,           -- Unique identifier for the customer
                                         customer_unique_id VARCHAR(50) NOT NULL,       -- Unique customer key
                                         customer_zip_code_prefix VARCHAR(20) NOT NULL, -- ZIP code prefix
                                         customer_city VARCHAR(255) NOT NULL,           -- City of the customer
                                         customer_state CHAR(2) NOT NULL                -- State of the customer (e.g., SP)
) ENGINE=InnoDB;

CREATE TABLE olist_sellers_dataset (
                                       seller_id VARCHAR(50) NOT NULL,                          -- Unique identifier for each seller
                                       seller_zip_code_prefix VARCHAR(10) NOT NULL,             -- Seller's zip code prefix
                                       seller_city VARCHAR(100) NOT NULL,                       -- City where the seller is located
                                       seller_state VARCHAR(50) NOT NULL,                       -- State where the seller is located
                                       PRIMARY KEY (seller_id)                                  -- Primary key for seller_id
) ENGINE=InnoDB;

CREATE TABLE olist_geolocation_dataset (
                                           geolocation_zip_code_prefix VARCHAR(20) NOT NULL,  -- Prefix of the zip code
                                           geolocation_lat DECIMAL(10, 8) NOT NULL,           -- Latitude coordinate
                                           geolocation_lng DECIMAL(11, 8) NOT NULL,           -- Longitude coordinate
                                           geolocation_city VARCHAR(100) NOT NULL,            -- City name
                                           geolocation_state CHAR(2) NOT NULL,                -- State abbreviation
                                           PRIMARY KEY (geolocation_lat, geolocation_lng)     -- Primary key for zip code prefix
) ENGINE=InnoDB;

CREATE TABLE olist_orders_dataset (
                                      order_id VARCHAR(50) PRIMARY KEY,                  -- Unique identifier for the order
                                      customer_id VARCHAR(50) NOT NULL,                 -- Foreign key referencing olist_customers_dataset
                                      order_status VARCHAR(50) NOT NULL,                -- Order status (e.g., delivered, shipped)
                                      order_purchase_timestamp TIMESTAMP NOT NULL,      -- Timestamp when the order was purchased
                                      order_approved_at TIMESTAMP,                      -- Timestamp when the order was approved
                                      order_delivered_carrier_date TIMESTAMP,           -- Timestamp when the order was delivered to the carrier
                                      order_delivered_customer_date TIMESTAMP,          -- Timestamp when the order was delivered to the customer
                                      order_estimated_delivery_date TIMESTAMP NOT NULL, -- Estimated delivery date
                                      FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE product_category_name_translation (
                                                   product_category_name VARCHAR(100) NOT NULL,            -- Original product category name
                                                   product_category_name_english VARCHAR(100) NOT NULL,     -- English translation of the category name
                                                   PRIMARY KEY (product_category_name)                      -- Primary key based on product category name
) ENGINE=InnoDB;

CREATE TABLE olist_products_dataset (
                                        product_id VARCHAR(50) NOT NULL,                      -- Unique identifier for each product
                                        product_category_name VARCHAR(100) NOT NULL,          -- Category of the product (e.g., perfumaria)
                                        product_name_length INT NOT NULL,                     -- Length of the product name
                                        product_description_length INT NOT NULL,              -- Length of the product description
                                        product_photos_qty INT NOT NULL,                      -- Number of photos associated with the product
                                        product_weight_g INT NOT NULL,                        -- Weight of the product in grams
                                        product_length_cm INT NOT NULL,                       -- Length of the product in centimeters
                                        product_height_cm INT NOT NULL,                       -- Height of the product in centimeters
                                        product_width_cm INT NOT NULL,                        -- Width of the product in centimeters
                                        PRIMARY KEY (product_id),                             -- Primary key for product_id
                                        FOREIGN KEY (product_category_name) REFERENCES product_category_name_translation(product_category_name) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE olist_order_items_dataset (
                                           order_id VARCHAR(50) NOT NULL,                   -- Foreign key to olist_orders_dataset
                                           order_item_id INT NOT NULL,                     -- Identifier for items in the same order
                                           product_id VARCHAR(50) NOT NULL,                -- Foreign key to olist_products_dataset
                                           seller_id VARCHAR(50) NOT NULL,                 -- Foreign key to olist_sellers_dataset
                                           shipping_limit_date TIMESTAMP NOT NULL,         -- Shipping deadline
                                           price DECIMAL(10, 2) NOT NULL,                  -- Item price
                                           freight_value DECIMAL(10, 2) NOT NULL,          -- Freight cost
                                           PRIMARY KEY (order_id, order_item_id),          -- Composite primary key
                                           FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id) ON DELETE CASCADE,
                                           FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id) ON DELETE CASCADE,
                                           FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE olist_order_payments_dataset (
                                              order_id VARCHAR(50) NOT NULL,                   -- Foreign key to olist_orders_dataset
                                              payment_sequential INT NOT NULL,                 -- Sequential number for each payment
                                              payment_type VARCHAR(50) NOT NULL,               -- Payment type (e.g., credit_card, boleto)
                                              payment_installments INT NOT NULL,               -- Number of installments for the payment
                                              payment_value DECIMAL(10, 2) NOT NULL,           -- Payment amount
                                              PRIMARY KEY (order_id, payment_sequential),      -- Composite primary key
                                              FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE olist_order_reviews_dataset (
                                             review_id VARCHAR(50) NOT NULL,                    -- Unique identifier for each review
                                             order_id VARCHAR(50) NOT NULL,                      -- Foreign key to olist_orders_dataset
                                             review_score INT NOT NULL,                          -- Review score (e.g., 1 to 5)
                                             review_comment_title TEXT,                          -- Title of the review comment (optional)
                                             review_comment_message TEXT,                        -- Message of the review comment (optional)
                                             review_creation_date DATETIME NOT NULL,             -- Date when the review was created
                                             review_answer_timestamp DATETIME,                   -- Timestamp for when the review was answered
                                             PRIMARY KEY (review_id),                            -- Primary key for review_id
                                             FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;


