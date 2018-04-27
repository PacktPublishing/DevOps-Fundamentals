[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
<title>Add a new Stage</title>
[@s.form action="createStage" namespace="/chain/admin/ajax"
        submitLabelKey="global.buttons.create"]
    [@s.hidden name="returnUrl" /]
    [@s.textfield labelKey='stage.name' name='stageName' required=true /]
    [@s.textfield labelKey='stageDescription' name='stageDescription' required=false /]
    [@s.checkbox labelKey='stage.manual' name='stageManual' /]
    [#if featureManager.isFinalStagesEnabled()]
        [@s.checkbox labelKey="stage.final" name='finalStage'/]
    [/#if]
    [@ww.hidden name="buildKey"/]
[/@s.form]