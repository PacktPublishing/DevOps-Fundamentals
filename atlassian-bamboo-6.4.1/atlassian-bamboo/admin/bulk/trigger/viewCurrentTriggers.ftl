[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.trigger.ReplaceTriggersAction" --]

[#assign triggers = action.immutableChain.buildDefinition.triggerDefinitions]
[#if triggers.empty]
    [@s.text name="bulkAction.replaceTriggers.noTriggers" /]
[#else]
    <ul class="bulk-changed-items">
    [#list triggers as trigger]
        <li>
            ${trigger.name}
            [#if trigger.userDescription?has_content]
                <span class="userDescription">(${trigger.userDescription})</span>
            [/#if]
        </li>
    [/#list]
    </ul>
[/#if]
