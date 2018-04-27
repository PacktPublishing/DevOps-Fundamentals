[#-- @ftlvariable name="baseUrl" type="java.lang.String" --][#lt/]
[#-- @ftlvariable name="applicationHost" type="java.lang.String" --][#lt/]
[#-- @ftlvariable name="storageLimits" type="com.atlassian.bamboo.configuration.StorageLimits" --][#lt/]
[#include "notificationCommonsText.ftl"][#lt/]
[#assign configurationUrl = baseUrl + '/admin/configureArtifactStorage.action' /][#lt/]
[#assign headline = i18n.getText("storage.capping.warning.email.hard.limit.header", [applicationHost]) /][#lt/]
[#assign policyUrl = i18n.getText('help.cloud.storage.policy') /][#lt/]
[#assign policyLink]${i18n.getText("storage.capping.warning.email.link.cloud.storage.policy")}: ${policyUrl}[/#assign][#lt/]
[@notificationTitleText title=headline /]
${i18n.getText("storage.capping.warning.email.hard.limit.body.part1", [storageLimits.hardLimit])}
${i18n.getText("storage.capping.warning.email.hard.limit.body.part2")}
${i18n.getText("storage.capping.warning.email.link.configure.storage")}: ${configurationUrl}
${i18n.getText("storage.capping.warning.email.hard.limit.body.part3", [policyLink])}

${i18n.getText("storage.capping.warning.email.hard.limit.body.part4")}
[@showEmailFooter /]
