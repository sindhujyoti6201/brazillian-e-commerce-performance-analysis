# Query Optimization and Performance Enhancement for Brazilian e-Commerce Dataset

## Introduction

This report details the performance analysis of a baseline query executed on the Brazilian E-commerce dataset. The goal is to understand the query's inefficiencies and propose optimizations to improve its performance.

### Baseline Query
```sql
SELECT o.order_id
     , o.order_status
     , o.order_purchase_timestamp
     , p.product_id
     , p.product_category_name
     , oi.price
     , oi.freight_value
FROM olist_orders_dataset o
         JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
         JOIN olist_products_dataset p ON oi.product_id = p.product_id
         JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE c.customer_unique_id = '8d50f5eadf50201ccdcedfb9e2ac8455'
ORDER BY o.order_purchase_timestamp DESC;
```
# Performance Analysis

## Execution Statistics

The query performance was analyzed using the MySQL EXPLAIN plan. Below are the key findings:

### Full Table Scans
- All tables (`c`, `o`, `oi`, and `p`) were scanned entirely due to the lack of indexing on critical columns.

### Intermediate Row Count
- Joins produced a massive number of intermediate rows, significantly impacting performance.
    - **Example**: The join between `oi` and `o` produced 1.09 trillion rows.

### Temporary Table and Filesort
- The query relied on a temporary table and filesort, adding substantial overhead.

## Detailed EXPLAIN Analysis

### Key Observations

#### Customer Table (`c`)
- **Access Type**: Full table scan.
- **Rows Examined**: 98,906.
- **Filtered Rows**: 10%.

#### Orders Table (`o`)
- **Access Type**: Full table scan.
- **Rows Examined**: 98,828.
- **Filtered Rows**: 10%.
- **Join Buffer**: Hash join.

#### Order Items Table (`oi`)
- **Access Type**: Full table scan.
- **Rows Examined**: 111,720.
- **Filtered Rows**: 10%.

#### Products Table (`p`)
- **Access Type**: Full table scan.
- **Rows Examined**: 32,771.
- **Filtered Rows**: 10%.

### Performance Costs
- **Total Query Cost**: 7.16e+15
- **Sort Cost**: 3.58e+15
- **Data Read Across Joins**: Approximately 1 Exabyte.

## Key Issues Identified

1. **Lack of Indexing**:
    - The absence of indexes on columns used in `WHERE` clauses and joins.

2. **Inefficient Join Strategy**:
    - Hash joins and full table scans led to high memory and I/O consumption.

3. **High Data Volume**:
    - Large datasets exacerbated performance bottlenecks.

# Optimization Plan

## Index Creation
- We have indexed the following columns to optimize query performance:
    - **`customer_id`** in the `olist_customers_dataset` table:
      ```sql
      ALTER TABLE olist_customers_dataset ADD INDEX idx_customers_customer_id (customer_id);
      ```
    - **`order_id`** in the `olist_orders_dataset` table:
      ```sql
      ALTER TABLE olist_orders_dataset ADD INDEX idx_orders_order_id (order_id);
      ```
    - **`customer_id`** in the `olist_orders_dataset` table:
      ```sql
      ALTER TABLE olist_orders_dataset ADD INDEX idx_orders_customer_id (customer_id);
      ```
    - **`order_purchase_timestamp`** in the `olist_orders_dataset` table:
      ```sql
      ALTER TABLE olist_orders_dataset ADD INDEX idx_orders_order_purchase_timestamp (order_purchase_timestamp);
      ```
    - **`product_id`** in the `olist_products_dataset` table:
      ```sql
      ALTER TABLE olist_products_dataset ADD INDEX idx_products_product_id (product_id);
      ```
    - **`order_id`** in the `olist_order_items_dataset` table:
      ```sql
      ALTER TABLE olist_order_items_dataset ADD INDEX idx_order_items_order_id (order_id);
      ```
    - **`product_id`** in the `olist_order_items_dataset` table:
      ```sql
      ALTER TABLE olist_order_items_dataset ADD INDEX idx_order_items_product_id (product_id);
      ``` 
## Summary of Optimized Results

After implementing the optimizations, the query performance showed significant improvements:

1. **Execution Time**:
    - The query cost decreased to **32971.40**, reflecting a much more efficient execution plan compared to the baseline.
    - Although a temporary table is still used, the overall cost of execution is reduced significantly, leading to an optimized query performance.

2. **Query Cost**:
    - The query cost dropped from **7.16e+15** to **32971.40**, thanks to the new indexes and optimized query structure.
    - This improvement is attributed to the use of optimized indexes and more efficient join operations.

3. **Data Read**:
    - The number of rows processed during the query execution was reduced significantly.
    - For example, the `olist_customers_dataset` table had **14M** rows read per join, but this was minimized by the proper use of indexes (`idx_customers_customer_id`).
    - Additionally, the `olist_orders_dataset`, `olist_order_items_dataset`, and `olist_products_dataset` saw reductions in data read due to the use of specific indexes on their respective columns.

4. **Filesort and Temporary Table**:
    - The query still uses temporary tables and filesorts, with a sort cost of **11491.90**.
    - However, the need for unnecessary filesorts and temporary tables has been minimized, reducing disk I/O and memory usage.

5. **Overall Efficiency**:
    - The optimizations led to a substantial reduction in query execution time and resource consumption.
    - The reordering of joins, efficient use of indexes, and limiting of data read per join significantly improved the performance, making the query more scalable for larger datasets.

These optimizations should improve the overall responsiveness and efficiency of queries in a production environment, especially as the data volume increases.

## Conclusion

The implementation of the proposed optimizations led to a significant enhancement in the performance of the query. By introducing indexes on critical columns such as `customer_id`, `order_id`, and `product_id`, and optimizing the join order, we were able to reduce the query cost from **7.16e+15** to **32971.40**, while also improving the efficiency of row processing and reducing unnecessary disk I/O.

Although the query still uses temporary tables and filesorts, these operations were minimized through effective indexing, resulting in lower overall resource consumption. The execution time and query cost improvements demonstrate the effectiveness of the optimization strategy, especially in reducing the number of rows processed and speeding up data retrieval.

These optimizations have not only improved the query performance but also made it more scalable, ensuring that the system can handle larger datasets more efficiently. As a result, the optimized query is expected to provide faster response times, better resource utilization, and improved scalability in a production environment, leading to a more responsive and efficient system as data volumes grow.

Overall, the optimizations have made a substantial impact on the system's performance, and further refinements could be considered as the dataset continues to evolve.
