[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.trigger.ReplaceTriggersAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.trigger.ReplaceTriggersAction" --]
[#include "/build/common/configureTrigger.ftl"]

<h3>[@s.text name="bulkAction.replaceTriggers.configure" /]</h3>
<p class="bulk-description">[@s.text name="bulkAction.replaceTriggers.warning" /]</p>

[@configureTrigger bulk=true/]