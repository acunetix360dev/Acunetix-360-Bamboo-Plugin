package com.acunetix.tasks;

import com.acunetix.ConfigManager;
import com.acunetix.model.ScanReport;
import com.acunetix.model.ScanRequestResult;

import java.io.IOException;
import java.net.URISyntaxException;

public class Acunetix360ScanHelper {
    private final ConfigManager configManager = new ConfigManager();

    public String GetScanTaskID(String planKey, String buildNumber) {
        final String scanTaskID = configManager.getScanTaskID(planKey, buildNumber);

        return scanTaskID;
    }

    public ScanReport GetScanReport(String planKey, String buildNumber) throws IOException, URISyntaxException {
        final String scanTaskID = GetScanTaskID(planKey, buildNumber);
        final ScanReport scanReport = GetScanReport(scanTaskID);

        return scanReport;
    }

    public ScanReport GetScanReport(String scanTaskID) throws IOException, URISyntaxException {

        ScanRequestResult scanRequestResult = new ScanRequestResult(configManager.getApiUrl(), configManager.getApiToken(), scanTaskID);

        return scanRequestResult.getReport();
    }
}
