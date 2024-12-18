package edu.nyu.brazillianecommerce.services;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.TimeZone;

@Service
public class CsvImport {

    private final JdbcTemplate jdbcTemplate;

    public CsvImport(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public static boolean canBeParsedToNumber(String str) {
        try {
            // Try to parse the string to a number (integer or double)
            Double.parseDouble(str); // This can handle both integers and floating point numbers
            return true; // If parsing succeeds, return true
        } catch (NumberFormatException e) {
            return false; // If parsing fails, return false
        }
    }

    @Transactional
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

            // Set MySQL connection time zone to "America/Sao_Paulo"
            setDatabaseTimeZone();

            // Batch processing
            List<Object[]> batchArgs = new ArrayList<>();
            for (String[] record : records) {
                // Handle timestamp fields and replace empty strings with null
                for (int i = 0; i < record.length; i++) {
                    if (record[i].isEmpty()) {
                        record[i] = null;  // Replace empty string with null
                    } else if (isValidTimestamp(record[i])) {
                        record[i] = String.valueOf(convertToTimestamp(record[i])); // Convert valid timestamp
                    } else if (!canBeParsedToNumber(record[i])) {
                        if (record[i].startsWith("\"") && record[i].endsWith("\"")) {
                            // Remove double quotes and replace with single quotes
                            record[i] = record[i].substring(1, record[i].length() - 1);
                        }
                    }
                }
                batchArgs.add(record);
            }

            jdbcTemplate.batchUpdate(sql, batchArgs);
            System.out.println("Data import completed successfully.");
        } catch (Exception e) {
            System.err.println("Error occurred during data import: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Check if the string matches the timestamp format "yyyy-MM-dd HH:mm:ss"
    private boolean isValidTimestamp(String value) {
        String regex = "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$";
        return value != null && value.matches(regex);
    }

    // Convert a string to Timestamp considering the "America/Sao_Paulo" time zone
    private Timestamp convertToTimestamp(String timestampStr) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            dateFormat.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
            return new Timestamp(dateFormat.parse(timestampStr).getTime());
        } catch (ParseException e) {
            System.err.println("Error parsing timestamp: " + timestampStr);
            return null; // Return null if there's an error parsing the timestamp
        }
    }

    // Set MySQL connection time zone to "America/Sao_Paulo"
    private void setDatabaseTimeZone() {
        try {
            String timeZoneQuery = "SET time_zone = 'America/Sao_Paulo'";
            jdbcTemplate.execute(timeZoneQuery);
        } catch (Exception e) {
            System.err.println("Error setting database time zone: " + e.getMessage());
        }
    }
}
