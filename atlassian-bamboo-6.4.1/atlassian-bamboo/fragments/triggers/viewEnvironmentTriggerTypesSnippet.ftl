[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.triggers.ConfigureEnvironmentTriggers" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.triggers.ConfigureEnvironmentTriggers" --]

[#import "/feature/triggers/triggersEditCommon.ftl" as tc/]
[@ww.url var="triggerSelectionUrl" action="addEnvironmentTrigger" namespace="/deploy/config" environmentId=environmentId returnUrl=returnUrl /]

[@tc.triggerSelector availableTriggerTypes triggerSelectionUrl /]
