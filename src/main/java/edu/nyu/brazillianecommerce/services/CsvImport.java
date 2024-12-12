package edu.nyu.brazillianecommerce.services;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CsvImport {

    private final JdbcTemplate jdbcTemplate;

    public CsvImport(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void importCsvData(String csvFilePath, String tableName) {
        try {
            // Read CSV records
            List<String[]> records = CsvReader.readCsv(csvFilePath);
            System.out.printf("Reading from the file %s completed. Read %d records%n", csvFilePath, records.size());

            // Dynamically determine the number of columns (based on the first row)
            if (records.isEmpty()) {
                System.out.println("No records found in the CSV file.");
                return;
            }

            int numColumns = records.get(0).length;  // Get the number of columns from the first record

            // Dynamically build the SQL query with the appropriate number of placeholders
            StringBuilder sqlBuilder = new StringBuilder("INSERT INTO ");
            sqlBuilder.append(tableName)
                    .append(" VALUES (");

            // Add placeholders for each column
            for (int i = 0; i < numColumns; i++) {
                sqlBuilder.append("?");
                if (i < numColumns - 1) {
                    sqlBuilder.append(", ");
                }
            }
            sqlBuilder.append(")");

            String sql = sqlBuilder.toString();

            // Loop through each record and insert into the database
            for (String[] record : records) {
                jdbcTemplate.update(sql, (Object[]) record);  // Pass record as Object array to jdbcTemplate
            }

            System.out.println("Data import completed successfully.");

        } catch (Exception e) {
            System.err.println("Error occurred during data import: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
