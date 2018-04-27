[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="applicationHost" type="java.lang.String" --]
[#-- @ftlvariable name="storageLimits" type="com.atlassian.bamboo.configuration.StorageLimits" --]
[#include "notificationCommonsHtml.ftl"]

[#assign configurationUrl = baseUrl + '/admin/configureArtifactStorage.action' /]
[#assign headline = i18n.getText("storage.capping.warning.email.soft.limit.header", [applicationHost]) /]
[#assign policyUrl = i18n.getText('help.cloud.storage.policy') /]
[#assign policyLink]<a style="text-decoration:none; color: #3572b0;" href="${policyUrl}">${i18n.getText("storage.capping.warning.email.link.cloud.storage.policy")}</a>[/#assign]

[@atlassianEmailTemplate baseUrl=baseUrl headline=headline]
    <p>${i18n.getText("storage.capping.warning.email.soft.limit.body.part1", [storageLimits.hardLimit])}</p>
    <p>${i18n.getText("storage.capping.warning.email.soft.limit.body.part2")}</p>
    <div style="padding: 20px 0; text-align: center;">
        <a href="${configurationUrl}" style="text-decoration: none; background-color: #3572b0; color: #ffffff; padding: 8px 10px; border-radius: 4px; font-weight: bold;">
            ${i18n.getText("storage.capping.warning.email.link.configure.storage")}
        </a>
    </div>
    <p>
        <strong>${i18n.getText("storage.capping.warning.email.soft.limit.body.part3")}</strong>
        ${i18n.getText("storage.capping.warning.email.soft.limit.body.part4", [policyLink])}
    </p>
    <p>${i18n.getText("storage.capping.warning.email.soft.limit.body.part5")}</p>
[/@atlassianEmailTemplate]
