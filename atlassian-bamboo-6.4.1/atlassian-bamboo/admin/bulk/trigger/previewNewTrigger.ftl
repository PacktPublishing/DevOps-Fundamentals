[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.trigger.ReplaceTriggersAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.trigger.ReplaceTriggersAction" --]
[#include "/build/common/viewBuildTrigger.ftl"]

[@ui.messageBox type='warning'][@ww.text name="bulkAction.replaceTriggers.warning" /][/@ui.messageBox]

[@viewBuildTrigger bulk=true /]