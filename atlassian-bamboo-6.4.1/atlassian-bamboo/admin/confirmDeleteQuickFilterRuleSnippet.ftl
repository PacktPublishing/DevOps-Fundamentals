[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.EditQuickFilterRuleAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.EditQuickFilterRuleAction" --]
[@s.form action="deleteQuickFilterRule"
    namespace="/admin"
    submitLabelKey="global.buttons.delete"
    cancelUri="${returnUrl}"]

    [@s.hidden name="quickFilterId" value=quickFilterId /]
    [@s.hidden name="ruleId" value=ruleId /]
    [@s.hidden name="returnUrl" value=returnUrl /]

    <h1>[@s.text name="quick.filters.rule.delete.title"/]</h1>
    [#if !action.hasAnyErrors()]
        <p>
            [@s.text name="quick.filters.rule.delete.confirm"]
                [@s.param]${rule.name}[/@s.param]
            [/@s.text]
        </p>
    [/#if]
[/@s.form]
