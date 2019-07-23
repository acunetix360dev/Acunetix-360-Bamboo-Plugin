package com.acunetix.tasks;

import com.acunetix.model.ScanReport;
import com.atlassian.bamboo.build.ViewBuildResults;

public class Acunetix360Report extends ViewBuildResults {

    String buildNumber;
    String scanTaskID;
    String hasError;
    String errorMessage;
    String isReportGenerated;

    @Override
    public String execute() throws Exception {
        try {
            final Acunetix360ScanHelper acunetix360ScanHelper = new Acunetix360ScanHelper();
            final String scanTaskID = acunetix360ScanHelper.GetScanTaskID(getPlanKey(), this.buildNumber);
            final ScanReport scanReport = acunetix360ScanHelper.GetScanReport(scanTaskID);
            this.scanTaskID = scanTaskID;
            isReportGenerated = String.valueOf(scanReport.isReportGenerated());
            hasError = "false";
            errorMessage = "";
        } catch (Exception ex) {
            this.scanTaskID = scanTaskID;
            hasError = "true";
            isReportGenerated = "false";
            errorMessage = ex.getMessage();
        }
        return super.execute();
    }

    //these getters called from ui like ${IsReportGenerated}

    public String getScanTaskID() {
        return scanTaskID;
    }

    public String getHasError() {
        return hasError;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public String getIsReportGenerated() {
        return isReportGenerated;
    }

    public String getBuildNumberString() {
        return buildNumber;
    }
    //this is set by bamboo see atlassian-plugin.xml -> buildNumber=${buildNumber}
    public void setBuildNumber(String buildNumber) {
        this.buildNumber = buildNumber;
    }
}
