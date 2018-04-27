[#-- @ftlvariable name="fieldPrefix" type="java.lang.String" --]
[#assign fieldPrefix = fieldPrefix!"expiryConfig"/]

[@ui.bambooSection titleKey="buildExpiry.enable.type.title" id="expiryTypeSelect" headerWeight='h4']
    [@s.checkbox id='expiryConfig_result' name='${fieldPrefix}.expiryTypeResult' labelKey='buildExpiry.enable.type.result' /]
    [@s.checkbox name='${fieldPrefix}.expiryTypeArtifact'labelKey='buildExpiry.enable.type.artifact' cssClass='buildExpiryPartial' /]
    [@s.checkbox name='${fieldPrefix}.expiryTypeBuildLog' labelKey='buildExpiry.enable.type.buildlog' cssClass='buildExpiryPartial'/]

    [#assign periodValue]${stack.findString(fieldPrefix + '.period')!'days'}[/#assign]
    [@s.textfield name='${fieldPrefix}.duration' labelKey='buildExpiry.enable.timing' template='periodPicker' periodField='${fieldPrefix}.period' periodValue=periodValue/]
[/@ui.bambooSection]

[@ui.bambooSection titleKey="buildExpiry.exceptions" id="expiryExceptions" headerWeight='h4']
    [@s.textfield labelKey="buildExpiry.enable.builds.part1" name='${fieldPrefix}.buildsToKeep']
        [@s.param name="after"]
            [@s.text name='buildExpiry.enable.builds.part2' /]
        [/@s.param]
    [/@s.textfield]

    [@s.textfield name='${fieldPrefix}.labelsToKeep' labelKey='buildExpiry.enable.excludeLabels.labels' /]
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