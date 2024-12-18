package edu.nyu.brazillianecommerce.services;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class CsvReader {

    public static List<String[]> readCsv(String filePath) throws IOException {
        List<String[]> records = new ArrayList<>();

        // Use InputStreamReader with UTF-8 encoding
        try (InputStreamReader reader = new InputStreamReader(
                new FileInputStream(filePath), StandardCharsets.UTF_8)) {

            // Parse the CSV file
            Iterable<CSVRecord> csvRecords = CSVFormat.DEFAULT.withFirstRecordAsHeader().parse(reader);
            for (CSVRecord csvRecord : csvRecords) {
                String[] record = new String[csvRecord.size()];
                for (int i = 0; i < csvRecord.size(); i++) {
                    record[i] = csvRecord.get(i);
                }
                records.add(record);
            }
        }
        return records;
    }
}

