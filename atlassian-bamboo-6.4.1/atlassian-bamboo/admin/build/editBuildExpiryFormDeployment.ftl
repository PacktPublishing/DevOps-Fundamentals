[#-- @ftlvariable name="fieldPrefix" type="java.lang.String" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#assign fieldPrefix = fieldPrefix!"expiryConfig"/]

[@ui.bambooSection titleKey="buildExpiry.enable.type.title" id="expiryTypeSelect" headerWeight='h4']
    [#assign expiryDescription]
        [#if action.getExpiryConfig().getMaxIgnoredLogSize() != -1]
            [@s.text name='buildExpiry.enable.type.buildlog.withDeployments.withLogSizeLimit']
                [@s.param value=action.getMaxIgnoredLogSizeFormatted() /]
                [@s.param][@ww.text name="expiry.global.logSettings"/][/@s.param]
            [/@s.text]
        [/#if]
    [/#assign]
    [@s.checkbox id='expiryConfig_result' name='${fieldPrefix}.expiryTypeResult' labelKey='buildExpiry.enable.type.result.withDeployments' /]
    [@s.checkbox name='${fieldPrefix}.expiryTypeArtifact' labelKey='buildExpiry.enable.type.artifact.withDeployments' cssClass='buildExpiryPartial' /]
    [@s.checkbox name='${fieldPrefix}.expiryTypeBuildLog' labelKey='buildExpiry.enable.type.buildlog.withDeployments'
        description=expiryDescription cssClass='buildExpiryPartial'/]

    [#assign periodValue]${stack.findString(fieldPrefix + '.period')!'days'}[/#assign]
    [@s.textfield name='${fieldPrefix}.duration' labelKey='buildExpiry.enableDeployment.timing' template='periodPicker' periodField='${fieldPrefix}.period' periodValue=periodValue/]
[/@ui.bambooSection]

[@ui.bambooSection titleKey="buildExpiry.exceptions" id="expiryExceptions" headerWeight='h4']
    [@s.textfield name="${fieldPrefix}.buildsToKeep" cssClass="short-field" labelKey="buildExpiry.enable.builds.part1"]
        [@s.param name="after"][@s.text name="buildExpiry.enable.builds.part2" /][/@s.param]
    [/@s.textfield]

    [@s.textfield name="${fieldPrefix}.labelsToKeep" longField=true labelKey="buildExpiry.enable.excludeLabels.labels"/]

    [@s.textfield name="${fieldPrefix}.deploymentsToKeep" cssClass="short-field" labelKey="buildExpiry.enable.deployments.part1"]
        [@s.param name="after"][@s.text name="buildExpiry.enable.deployments.part2" /][/@s.param]
    [/@s.textfield]
[/@ui.bambooSection]

<script type="text/javascript">
    require(['feature/expiry-checkbox-tree'], function(ExpiryCheckboxTree){
        return new ExpiryCheckboxTree({
            el: '#expiryTypeSelect',
            params: {
                parentSelector: '#expiryConfig_result',
                childrenSelector: ':input.buildExpiryPartial',
                blockSelector: "#expiryExceptions"
            }
        });
    });
</script>
