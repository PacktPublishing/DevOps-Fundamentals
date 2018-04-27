[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.EditQuickFilterRuleAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.EditQuickFilterRuleAction" --]
[#-- snippet displayed in quick filter rules config right panel --]

[@s.form action="saveQuickFilterRule"
    method='POST'
    enctype='multipart/form-data'
    namespace="/admin"
    submitLabelKey="global.buttons.update"
    cancelUri="${returnUrl}"
    cssClass="top-label"]

    [@s.hidden name="quickFilterId" value=quickFilterId /]
    [@s.hidden name="ruleId" value=ruleId /]
    [@s.hidden name="returnUrl" value=returnUrl /]

    [@ui.bambooSection cssClass="general-rule-configuration"]
        [@s.textfield labelKey="quick.filters.rule.name"
            name="ruleName"
            id="ruleName"
            maxlength="255"
            required=true /]

        [@s.select labelKey='quick.filters.rule.type'
            name='ruleTypeKey'
            id="ruleTypeKey"
            toggle='true'
            list=ruleTypes
            listKey='key'
            listValue='name'
            optionDescription='description' /]
    [/@ui.bambooSection]

    [#list ruleTypes as ruleType]
        [@ui.bambooSection dependsOn='ruleTypeKey' showOn=ruleType.key cssClass="specific-rule-configuration"]
            ${ruleType.getEditHtml(ruleConfiguration)!}
        [/@ui.bambooSection]
    [/#list]
[/@s.form]
