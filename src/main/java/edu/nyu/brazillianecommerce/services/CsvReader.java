package edu.nyu.brazillianecommerce.services;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CsvReader {
    public static List<String[]> readCsv(String filePath) throws IOException {
        List<String[]> records = new ArrayList<>();
        FileReader reader = new FileReader(filePath);

        Iterable<CSVRecord> csvRecords = CSVFormat.DEFAULT.withHeader().parse(reader);
        for (CSVRecord csvRecord : csvRecords) {
            String[] record = new String[csvRecord.size()];
            for (int i = 0; i < csvRecord.size(); i++) {
                record[i] = csvRecord.get(i);
            }
            records.add(record);
        }
        return records;
    }
}
