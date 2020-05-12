package com.acunetix.rest;

import com.acunetix.model.ScanReport;
import com.acunetix.tasks.Acunetix360ScanHelper;
import com.acunetix.utility.AppCommon;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/report/{scantaskid}")
public class Report {

    @GET
    @Produces({MediaType.APPLICATION_JSON})
    @Consumes({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response getMessage(@PathParam("scantaskid") String scanTaskID) {
        boolean isModelValid = AppCommon.IsGUIDValid(scanTaskID);

        if (!isModelValid) {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
        final Acunetix360ScanHelper acunetix360ScanHelper = new Acunetix360ScanHelper();
        try {
            final ScanReport scanReport = acunetix360ScanHelper.GetScanReport(scanTaskID);

            return Response.ok(scanReport.getContent()).build();
        } catch (Exception ex) {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }
}
