<html>
<head>
    <title>Acunetix 360</title>
    <meta name="decorator" content="adminpage">
${webResourceManager.requireResource("com.acunetix.acunetix360-bamboo-plugin:acunetix-360-web-resources")}
</head>
<body>
<div id="acunetix360SuccessMessage" class="aui-message aui-message-success" style="display:none">
    <p class="title">
        Successfully connected to the Acunetix 360.
    </p>
</div>
<div id="acunetix360ErrorMessage" class="aui-message aui-message-error" style="display: none">
    <p class="title">
        Failed to connect to the Acunetix 360.
    </p>
</div>
[@ww.form action="/admin/acunetix360/Acunetix360SaveConfiguration.action"
id="Acunetix360ConfigurationForm"
submitLabelKey='global.buttons.update'
cancelUri='/admin/administer.action']
<br>
<div class="paddedClearer"></div>
<div style="color: #3f3f3f;display:inline;font-size: 130%;">
    <img src="${req.contextPath}/download/resources/com.acunetix.acunetix360-bamboo-plugin:acunetix-360-assets/acunetix-360-logo.svg"
         alt="Acunetix 360"
         style="vertical-align:top; margin-bottom:1px;display: inline-block;height:1.6em;width: auto;"/>
    <h1 style="zoom:1;color: #3f3f3f;display:inline-block">Acunetix 360</h1>
</div>
<div class="aui-page-panel">
    <div class="aui-page-panel-inner">
        <section class="aui-page-panel-content">
            <h2 style="margin-left: 55px;">API Settings</h2>

            [@ww.textfield name="apiUrl" label='Server URL' description="Acunetix 360 URL, like 'https://www.acunetix360.com'"/]
            [@ww.password name="apiToken" label='API Token' showPassword='false' description="It can be found at 'Your Account > API Settings' page in the Acunetix 360.<br/>
                         User must have 'Start Scans' permission for the target website."/]
            <br>
            <button type="button" id="acunetix360TestConnectionButton" class="aui-button"
                    style="margin-left: 145px;">
                Test Connection
            </button>
            <div id="acunetix360TestConnectionButtonSpinner"
                 style="display: inline-block;margin: 5px;margin-left:10px;"></div>
        </section>
    </div>
</div>
<br>
[/@ww.form]

<script>
    var ncServerURLInput, ncApiTokenInput;
    var ncTestConnectionButton, ncTestConnectionButtonSpinner;
    var ncTestConnectionSuccessMessage, ncTestConnectionErrorMessage;
    var TestConnectionModel = {};
    var NCResponseData;

    //do noy use $ for Jquery instead use jQuery
    AJS.$(document).ready(function () {
        initializeNcElementsAndParams();
    });

    function initializeNcElementsAndParams() {
        ncServerURLInput = AJS.$("#Acunetix360ConfigurationForm_apiUrl");
        ncApiTokenInput = AJS.$("#Acunetix360ConfigurationForm_apiToken");

        ncTestConnectionSuccessMessage = AJS.$("#acunetix360SuccessMessage");
        ncTestConnectionErrorMessage = AJS.$("#acunetix360ErrorMessage");
        ncTestConnectionButton = AJS.$("#acunetix360TestConnectionButton");
        ncTestConnectionButtonSpinner = AJS.$("#acunetix360TestConnectionButtonSpinner");

        ncTestConnectionButton.click(ncTestConnection);
        ncServerURLInput.attr('placeholder', "URL like 'https://www.acunetix360.com'");

        updateNcParams();
    }

    function updateNcParams() {
        TestConnectionModel.apiURL = ncServerURLInput.val();
        TestConnectionModel.apiToken = ncApiTokenInput.val();
    }

    function ncTestConnection() {
        updateNcParams();
        ncTestConnectionButtonSpinner.spin();
        ncTestConnectionButton.prop('disabled', true);

        var request = AJS.$.ajax({
            type: "POST",
            url: "${req.contextPath}/rest/plugin/acunetix360/api/1.0/testconnection",
            data: JSON.stringify(TestConnectionModel),
            contentType: "application/json",
            dataType: "json"
        });

        request.done(function (data, statusText, xhr) {
            NCResponseData = data;
            if (NCResponseData.acunetix360StatusCode == "200") {
                ncTestConnectionErrorMessage.hide();
                ncTestConnectionSuccessMessage.show();
            } else {
                ncTestConnectionSuccessMessage.hide();
                ncTestConnectionErrorMessage.show();
            }

            ncTestConnectionButtonSpinner.spinStop();
            ncTestConnectionButton.prop('disabled', false);
        });

        request.fail(function (xhr, statusText) {
            ncTestConnectionSuccessMessage.hide();
            ncTestConnectionErrorMessage.show();

            ncTestConnectionButtonSpinner.spinStop();
            ncTestConnectionButton.prop('disabled', false);
        });
    }
</script>
</body>
</html>
