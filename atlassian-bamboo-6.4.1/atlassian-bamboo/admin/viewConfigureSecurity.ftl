[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
[#include "/admin/security/securitySettingsCommon.ftl"/]

<html>
<head>
    [@ui.header pageKey="config.security.heading" title=true/]
    <meta name="adminCrumb" content="configureSecurityPage">
</head>
<body>
    [@ui.header pageKey="config.security.heading" descriptionKey="config.security.description"/]
    [#if xsrfProtectionEnabled && xsrfProtectionMutativeGetsAllowed]
        [@ui.messageBox type="warning"]
            [@s.text name='config.security.xsrfProtection.mutativeGetsAllowed.warning' /]
        [/@ui.messageBox]
    [/#if]
    [@ww.form action="configureSecurity.action"
              namespace="/admin"
              id="viewConfigurationSecurityForm"
              submitLabelKey='global.buttons.edit'
              titleKey='config.security.form.view.heading'
    ]

        [#-- general settings --]
        [@ui.bambooSection]
            [@ww.checkbox id='enableExternalUserManagement_id' labelKey='config.security.enableExternalUserManagement' descriptionKey='config.security.enableExternalUserManagement.description' name='enableExternalUserManagement' disabled=true/]
            [@ww.checkbox id='enableSignup_id' labelKey='config.security.enableSignup' descriptionKey='config.security.enableSignup.description' toggle=true name='enableSignup' disabled=true/]
            [@ui.bambooSection dependsOn='enableSignup' showOn=true ]
                [@ww.checkbox id='enableCaptchaOnSignup_id' labelKey='config.security.enableCaptchaOnSignup' name='enableCaptchaOnSignup' disabled=true /]
            [/@ui.bambooSection]
            [@ww.checkbox id='enableViewContactDetails_id' labelKey='config.security.enableViewContactDetails' descriptionKey='config.security.enableViewContactDetails.description' name='enableViewContactDetails' disabled=true /]
            [@ww.checkbox id='enableRestrictedAdmin_id' labelKey='config.security.enableRestrictedAdmin' descriptionKey='config.security.enableRestrictedAdmin.description' name='enableRestrictedAdmin' disabled=true /]

            [#if featureManager.soxComplianceModeConfigurable]
                [@s.checkbox labelKey='config.security.soxComplianceMode' name='soxComplianceModeEnabled' disabled=true /]
            [/#if]

            [@ww.checkbox id='enableCaptcha_id' labelKey='config.security.enableCaptcha' toggle=true name='enableCaptcha' disabled=true  /]
            [@ui.bambooSection dependsOn='enableCaptcha' showOn=true]
                [@ww.textfield id='loginAttempts_id' cssClass="labelForCheckbox" labelKey='config.security.loginAttempts' name="loginAttempts" disabled=true /]
            [/@ui.bambooSection]
            [@s.checkbox labelKey='config.security.xsrfProtection' name='xsrfProtectionEnabled' disabled=true  /]
            [@s.checkbox labelKey='config.security.resolveArtifactContentTypeByExtension' name='resolveArtifactContentTypeByExtension' disabled=true /]
            [@s.checkbox labelKey='config.security.manageTrustedKeys' name='manageAcceptedSshHostKeys' disabled=true]
                [@s.param name="description"]
                    [#if manageAcceptedSshHostKeys]
                        [@s.text name="config.security.manageTrustedKeys.enabled.description"]
                            [@s.param][@s.url namespace='/admin' action='trustedKeys'/][/@s.param]
                        [/@s.text]
                    [#else ]
                        [@s.text name="config.security.manageTrustedKeys.disabled.description" /]
                    [/#if]
                [/@s.param]
            [/@s.checkbox]
            [@s.checkbox labelKey='config.security.showAdminContactDetailsToAnonymousUsers' name='showAdminContactDetailsToAnonymousUsers' disabled=true /]
        [/@ui.bambooSection]

        [#-- serialization protection methods --]
        [@ui.bambooSection]
            <h3>[@ww.text name='config.security.serialization.protection.method' /] [@help.icon pageKey='security.serialization.protection.method' /]</h3>
            [@s.select id='xstreamSerializationProtectionMethod_id'
                cssClass="labelForCheckbox" labelKey='config.security.xstream.serialization.protection.method'
                name="xstreamSerializationProtectionMethod"
                listKey="key"
                listValue="value"
                list=serializationProtectionOptionsForRemoting
                disabled=true /]

            [@s.select id='bandanaSerializationProtectionMethod_id'
                cssClass="labelForCheckbox"
                labelKey='config.security.bandana.serialization.protection.method'
                name="bandanaSerializationProtectionMethod"
                listKey="key"
                listValue="value"
                list=serializationProtectionOptionsForBandana
                disabled=true /]
        [/@ui.bambooSection]

        [#if featureManager.repositoryStoredSpecsEnabled ]
            [#-- repository stored specs security settings --]
            [@rssSecuritySettings isReadOnly=true /]
        [/#if]
    [/@ww.form]
</body>
</html>