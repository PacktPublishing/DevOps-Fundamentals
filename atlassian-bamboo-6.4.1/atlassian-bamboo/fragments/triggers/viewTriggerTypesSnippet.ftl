[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.triggers.ConfigureChainTriggers" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.triggers.ConfigureChainTriggers" --]

[#import "/feature/triggers/triggersEditCommon.ftl" as tc/]
[@ww.url var="triggerSelectionUrl" action="addChainTrigger" namespace="/chain/admin/config" planKey=planKey returnUrl=returnUrl /]

[@tc.triggerSelector availableTriggerTypes triggerSelectionUrl /]
