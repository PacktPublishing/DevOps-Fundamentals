[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupLicenseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupLicenseAction" --]
<html>
<head>
    <title>[@s.text name='setup.install.standard.title' /]</title>
</head>

<body>

[@ui.header pageKey='setup.install.standard.heading' descriptionKey='setup.welcome' /]

[#assign licenseDescription]
    [@s.text name='license.description' ]
        [@s.param][@s.text name='license.contact.company' /][/@s.param]
    [/@s.text]
[/#assign]
[@s.form action="validateLicense"]
    [@s.hidden name='sid' /]

    [@ui.bambooSection  titleKey='setup.install.license.section']
        [@s.label key='setup.install.sid' name='sid' /]
        [@s.textarea key='license' name="licenseString" required=true rows="7" cssClass="license-field" fullWidthField=true]
            [@s.param name='description']
                [@s.text name='license.description']
                    [@s.param]${version}[/@s.param]
                    [@s.param]${sid}[/@s.param]
                [/@s.text]
            [/@s.param]
        [/@s.textarea]
    [/@ui.bambooSection]
    [@ui.bambooSection titleKey="setup.install.setupType.section"]
        [#if expressSetupEnabled ]
            [@installationOption titleKey='setup.install.setupType.express' descriptionKey='setup.install.setupType.express.description' submitKey='setup.install.express' submitId="expressInstall" isPrimary=true /]
        [/#if]
        [@installationOption titleKey='setup.install.setupType.custom' descriptionKey='setup.install.setupType.custom.description' submitKey='setup.install.custom' submitId="customInstall" /]
    [/@ui.bambooSection]
[/@s.form]

[#macro installationOption titleKey descriptionKey submitKey submitId isPrimary=false]
    [@s.text name=submitKey var="submitText" /]
    <div class="installation-option">
        <h4>[@s.text name=titleKey /]</h4>
        <p>[@s.text name=descriptionKey /]</p>
        <input type="submit" value="${submitText}" name="${submitId}" id="${submitId}" class="aui-button[#if isPrimary] aui-button-primary[/#if]" />
    </div>
[/#macro]
</body>
</html>
