[#if temp_showCommitIsolation!false]
    [@s.checkbox labelKey='repository.common.commitIsolation.enabled' name='commit.isolation.option' disabled=true /]
[/#if]

[#if temp_showQuietPeriod!false]
    [@s.checkbox labelKey='repository.common.quietPeriod.enabled' name='repository.common.quietPeriod.enabled' disabled=true/]
    [#if stack.findValue('repository.common.quietPeriod.enabled')]
        [@s.textfield labelKey='repository.common.quietPeriod.period' name='repository.common.quietPeriod.period' required='true' disabled=true/]
        [@s.textfield labelKey='repository.common.quietPeriod.maxRetries' name='repository.common.quietPeriod.maxRetries' required='true' disabled=true/]
    [/#if]
[/#if]

[@s.select labelKey='filter.pattern.option' name='filter.pattern.option'
    list=uiConfigBean.filterOptions listKey='name' listValue='label' uiSwitch='value' disabled=true]
[/@s.select]

[#if stack.findValue('filter.pattern.option') != 'none']
    [@s.textfield labelKey='filter.pattern.regex' name='filter.pattern.regex' disabled=true/]
[/#if]

[@ww.textfield labelKey="changeset.filter.pattern.regex" name="changeset.filter.pattern.regex" disabled=true/]