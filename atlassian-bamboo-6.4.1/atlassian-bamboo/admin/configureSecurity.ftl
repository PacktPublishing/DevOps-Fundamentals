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
    [@ww.form action="saveConfigureSecurity"
              id="configurationSecurityForm"
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/viewSecurity.action'
              titleKey='config.security.form.edit.heading'
    ]

        [#-- general settings --]
        [@ui.bambooSection]
            [@ww.checkbox id='enableExternalUserManagement_id' labelKey='config.security.enableExternalUserManagement' descriptionKey='config.security.enableExternalUserManagement.description' name='enableExternalUserManagement'/]
            [@ww.checkbox id='enableSignup_id' labelKey='config.security.enableSignup' toggle=true name='enableSignup'/]
            [@ui.bambooSection dependsOn='enableSignup' showOn=true ]
                [@ww.checkbox id='enableCaptchaOnSignup_id' labelKey='config.security.enableCaptchaOnSignup' name='enableCaptchaOnSignup'/]
            [/@ui.bambooSection]
            [@ww.checkbox id='enableViewContactDetails_id' labelKey='config.security.enableViewContactDetails' descriptionKey='config.security.enableViewContactDetails.description' name='enableViewContactDetails'/]
            [@ww.checkbox id='enableRestrictedAdmin_id' labelKey='config.security.enableRestrictedAdmin' descriptionKey='config.security.enableRestrictedAdmin.description' name='enableRestrictedAdmin'/]

            [#if featureManager.soxComplianceModeConfigurable]
                [@s.checkbox labelKey='config.security.soxComplianceMode' name='soxComplianceModeEnabled' /]
            [/#if]

            [@ww.checkbox id='enableCaptcha_id' labelKey='config.security.enableCaptcha' toggle=true name='enableCaptcha'/]
            [@ui.bambooSection dependsOn='enableCaptcha' showOn=true]
                [@ww.textfield id='loginAttempts_id' labelKey='config.security.loginAttempts' name="loginAttempts" required=true/]
            [/@ui.bambooSection]
            [@s.checkbox labelKey='config.security.xsrfProtection' name='xsrfProtectionEnabled' toggle=true/]
            [@ui.bambooSection dependsOn='xsrfProtectionEnabled' showOn=true]
                [@s.checkbox labelKey='config.security.xsrfProtection.mutativeGetsAllowed' name='xsrfProtectionMutativeGetsAllowed'/]
            [/@ui.bambooSection]
            [@s.checkbox labelKey='config.security.resolveArtifactContentTypeByExtension' name='resolveArtifactContentTypeByExtension' /]
            [@s.checkbox labelKey='config.security.manageTrustedKeys' name='manageAcceptedSshHostKeys']
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
            [@s.checkbox labelKey='config.security.showAdminContactDetailsToAnonymousUsers' name='showAdminContactDetailsToAnonymousUsers' /]
        [/@ui.bambooSection]

        [#-- serialization protection methods --]
        [@ui.bambooSection]
            <h3>[@ww.text name='config.security.serialization.protection.method' /] [@help.icon pageKey='security.serialization.protection.method' /]</h3>
            [@s.select id='xstreamSerializationProtectionMethod_id'
                cssClass="labelForCheckbox" labelKey='config.security.xstream.serialization.protection.method'
                name="xstreamSerializationProtectionMethod"
                listKey="key"
                listValue="value"
                list=serializationProtectionOptionsForRemoting /]
            [@s.select id='bandanaSerializationProtectionMethod_id' cssClass="labelForCheckbox" labelKey='config.security.bandana.serialization.protection.method' name="bandanaSerializationProtectionMethod"
                listKey="key"
                listValue="value"
                list=serializationProtectionOptionsForBandana/]
        [/@ui.bambooSection]

        [#if featureManager.repositoryStoredSpecsEnabled ]
            [#-- repository stored specs security settings --]
            [@rssSecuritySettings isReadOnly=false /]
        [/#if]

    [/@ww.form]
</body>
</html>