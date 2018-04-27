[#if temp_showCommitIsolation!false]
    [@s.checkbox labelKey='repository.common.commitIsolation.enabled' name='commit.isolation.option' /]
[/#if]

[#if temp_showQuietPeriod!false]
    [@s.checkbox labelKey='repository.common.quietPeriod.enabled' toggle='true' name='repository.common.quietPeriod.enabled' /]
    [@ui.bambooSection dependsOn='repository.common.quietPeriod.enabled' showOn='true' ]
        [@s.textfield labelKey='repository.common.quietPeriod.period' name='repository.common.quietPeriod.period' required='true' /]
        [@s.textfield labelKey='repository.common.quietPeriod.maxRetries' name='repository.common.quietPeriod.maxRetries' required='true' /]
    [/@ui.bambooSection]
[/#if]

[@s.select labelKey='filter.pattern.option' name='filter.pattern.option' toggle='true'
    list=uiConfigBean.filterOptions listKey='name' listValue='label' uiSwitch='value']
[/@s.select]

[@ui.bambooSection dependsOn='filter.pattern.option' showOn='regex']
    [@s.textfield labelKey='filter.pattern.regex' name='filter.pattern.regex' /]
[/@ui.bambooSection]

[@ww.textfield labelKey="changeset.filter.pattern.regex" name="changeset.filter.pattern.regex" /]


