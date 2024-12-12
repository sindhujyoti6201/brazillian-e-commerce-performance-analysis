package edu.nyu.brazillianecommerce.cli;

import edu.nyu.brazillianecommerce.services.CsvImport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class CsvImportCLI implements CommandLineRunner {

    @Autowired
    private CsvImport csvImport;

    @Override
    public void run(String... args) throws Exception {
        if (args.length < 2) {
            System.out.println("Usage: java -jar <jar-file> <csv-file-path> <table-name>");
            return;
        }

        String csvFilePath = args[0];
        String tableName = args[1];

        System.out.println("Importing data from CSV: " + csvFilePath + " into table: " + tableName);

        // Import data from CSV into the database
        csvImport.importCsvData(csvFilePath, tableName);

        System.out.println("Data import completed!");
    }
}
