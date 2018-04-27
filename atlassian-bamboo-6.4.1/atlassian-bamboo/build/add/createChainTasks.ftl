[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateTasksChainWizard" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateTasksChainWizard" --]

[#import "/fragments/docker/docker.ftl" as docker/]

<html>
<head>
    <meta name="tab" content="2"/>
    <title>[@s.text name="plan.create.tasks.title"/] - [@s.text name="plan.create.new.title"/]</title>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
    ${webResourceManager.requireResourcesForContext("ace.editor")}
</head>
<body>

[#if actionErrors?has_content]
    [#list actionErrors as error]
        [@ui.messageBox type="error"]${error}[/@ui.messageBox]
    [/#list]
[#else]
    [#assign planCreateTasksDescription]
        [@s.text name="job.create.tasks.description"]
            [@s.param][@help.href pageKey="tasks.builder"/][/@s.param]
            [@s.param][@help.href pageKey="tasks.configuring"/][/@s.param]
        [/@s.text]
    [/#assign]

    <div id="onePageCreate" class="align-left">
        [@ui.header pageKey="plan.create.tasks.title" headerElement="h2"/]
        <div class="description" [#if featureManager.dockerPipelinesEnabled]id="configureJobHeader"[/#if]><p>[@s.text name="plan.create.tasks.description"/]</p>
            [#if !featureManager.dockerPipelinesEnabled]<p>${planCreateTasksDescription}</p>[/#if]
        </div>

        <form id="finalisePlanCreation" name="finalisePlanCreation" action="${req.contextPath}/build/admin/create/finalisePlanCreation.action" method="post" class="aui">
            [@docker.dockerCreateConfigurationFragment
                headerKey="job.docker.isolate.header"
                descriptionKey="job.isolate.description"
                isolationTypeRadioLabelKey="job.docker.isolate.type"
                isolationTypeRadioName="jobIsolation"
                isolationOptions=action.environmentIsolationOptions/]

            [@s.hidden name="planKey"/]
            [@s.hidden name="chainEnabled" value="false"/]

            [#assign xsrfToken = ctx.xsrfToken!/]
            [#if xsrfToken?has_content]
                <input type="hidden" name="atl_token" value="${xsrfToken?html}" />
            [/#if]
        </form>

        [#if featureManager.dockerPipelinesEnabled]
            [@ui.header pageKey="job.create.tasks.header" id="configureJobTasksHeader" description=planCreateTasksDescription headerElement="h3" /]
        [/#if]

        [#include "/build/edit/editBuildTasksCommon.ftl"/]

        <div class="aui-toolbar2">
            <div class="aui-toolbar-2-inner">
                <div class="aui-toolbar2-primary">
                    <div class="aui-buttons">
                        <button class="aui-button aui-button-primary" id="createPlan" title="test">${action.getText("global.buttons.create")}</button>
                    </div>
                    <div class="aui-buttons save-and-continue">
                        <button class="aui-button" id="saveAndContinue">${action.getText("global.buttons.save.and.continue")}</button>
                    </div>
                    <div class="aui-buttons">
                        <a class="cancel mutative" href="[@s.url namespace="/build/admin/create" action="cancelPlanCreation" planKey=planKey newProject=newProject/]" accesskey="`">
                            [@s.text name="global.buttons.cancel"/]
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        require(['jquery', 'widget/submit-button'], function($, SubmitButton) {
            new SubmitButton({
                                 buttonSelector: '#createPlan',
                                 formSelector: '#finalisePlanCreation',
                                 callback: function() {
                                     $('#chainEnabled').val(true);
                                 },
                             });
            new SubmitButton({
                                 buttonSelector: '#saveAndContinue',
                                 formSelector: '#finalisePlanCreation',
                             });
        });
    </script>
[/#if]

</body>
</html>