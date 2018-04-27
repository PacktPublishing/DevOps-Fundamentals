[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.repository.EditChainBranchRepository" --]
[#import "/build/common/repositoryCommon.ftl" as rc]
[#assign pageContent]
    [#if currentVcsTypeSelector?has_content]

        [#assign repo=currentVcsTypeSelector/]

        [#if resetDone]
            [@ui.messageBox titleKey="branch.config.repository.parent.reset"/]
        [/#if]

        [#if parentRemoved]
            [@ui.messageBox type="error" titleKey="branch.config.repository.removed.parent"/]
        [/#if]

        [#if defaultRepositoryTypeDifferent]
            [@ui.messageBox type="warning"]
                [@s.text name="branch.config.repository.override.repositoryTypeIsDifferent"]
                    [@s.param][@s.url action="resetChainBranchRepository" namespace="/branch/admin/config" planKey=planKey/][/@s.param]
                [/@s.text]
            [/@ui.messageBox]
        [/#if]

        [@s.form
            action="saveChainBranchRepository"
            method='POST'
            enctype='multipart/form-data'
            namespace="/branch/admin/config"
            submitLabelKey="repository.update.button"
            cancelUri="/browse/${planKey}/config"]

            <div id="repository-selector">

                [@ui.bambooSection id='repository-id']
                    [@s.label labelKey="branch.config.repository.type" value=repo.type?html /]
                    [#if repo.optionDescription??]
                        <div class="description">${repo.optionDescription}</div>
                    [/#if]

                    [@s.label labelKey="branch.config.repository.name" value=repo.name?html /]

                    [#if action.canOverrideBranch()]
                        [@ui.bambooSection id='branch-configuration']
                            ${repo.htmlFragments.branchHtml!}
                        [/@ui.bambooSection]
                    [/#if]
                [/@ui.bambooSection]

                [@ui.bambooSection id='repository-configuration']
                    [@s.hidden id="overrideRepositoryLocation" name="overrideRepositoryLocation"/]

                    [#if repositoryEditable && !defaultRepositoryTypeDifferent && !parentRemoved]
                        [@ui.bambooSection titleKey='branch.config.repository.override']
                            <div id="overrideToggle" class="aui-toggle" style="margin-top:-24px;margin-bottom:15px;">
                                    <span class="aui-toggle-view">
                                        <span class="aui-toggle-tick aui-icon aui-icon-small aui-iconfont-success"></span>
                                        <span class="aui-toggle-cross aui-icon aui-icon-small aui-iconfont-close-dialog"></span>
                                    </span>
                            </div>
                        [/@ui.bambooSection]
                    [/#if]
                    [@displayRepositoryConfiguration "serverConfiguration" repo true/]
                    [@displayRepositoryConfiguration "inheritedServerConfiguration" parentVcsTypeSelector false/]
                [/@ui.bambooSection]

                [@s.hidden name="planKey" value=planKey /]
                [@s.hidden name="repositoryId" value=repositoryId /]
                [@s.hidden id="selectedRepository" name="selectedRepository" value=selectedRepository toggle=true /]
                [@s.hidden name="resetDone" value=false/]
            </div>
        [/@s.form]
    [#else]
        [#--This has a customised template because I don't want the "unexpected error has occured" bit.--]
        [#if action.hasActionErrors() ]
            [#if actionErrors.size() == 1 ]
                [#assign heading]${formattedActionErrors.iterator().next()}[/#assign]
                [@ui.messageBox type="error" title=heading /]
            [#else ]
                [@ui.messageBox type="error" titleKey="error.multiple"]
                <ul>
                    [#list formattedActionErrors as error]
                        <li>${error}</li>
                    [/#list]
                </ul>
                [/@ui.messageBox]
            [/#if]
        [/#if]
    [/#if]


<script type="text/javascript">
    require(['feature/repository-overrides'], function(RepositoryOverrides) {
        var repositoryOverrides = new RepositoryOverrides({
            el: '#repository-configuration',
            selectors: {
                overrideToggle: '#overrideToggle',
                overrideRepositoryLocation: '#overrideRepositoryLocation',
                serverConfiguration: '#serverConfiguration',
                inheritedConfiguration: '#inheritedServerConfiguration'
            }
        });
        repositoryOverrides.render();
    });
</script>
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.repository" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]

[#macro displayRepositoryConfiguration id repo mutable]
    [@ui.bambooSection id=id]
        [@ui.bambooSection id='location-configuration']
        ${repo.htmlFragments.locationHtml!}
            [#if mutable && repo.supportsConnectionTesting]
                [@rc.testRepositoryConnectionButton id="test-connection-" + repo.key?replace('[^a-zA-Z0-9]', '-', 'r') /]
            [/#if]
        [/@ui.bambooSection]

        [@ui.bambooSection id='advanced-configuration']
        ${repo.htmlFragments.advancedServerOptionsHtml!}
        [/@ui.bambooSection]

        [@ui.bambooSection id='cd-configuration']
            [#if repo.htmlFragments.changeDetectionOptionsHtml?has_content]
            ${repo.htmlFragments.changeDetectionOptionsHtml!}
            [/#if]
        [/@ui.bambooSection]

        [#if mutable]
            [@ui.bambooSection id='viewer-configuration']
                [@ui.bambooSection]
                    [@s.select id="selectedWebRepositoryViewer" labelKey='webRepositoryViewer.type' name='selectedWebRepositoryViewer' toggle='true'
                    list='viewerSelectors' listKey='key' listValue='name']
                    [/@s.select]
                [/@ui.bambooSection]

                [#list viewerSelectors as viewer]
                    [#if viewer.html!?has_content]
                        [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn=viewer.key]
                        ${viewer.html!}
                        [/@ui.bambooSection]
                    [/#if]
                [/#list]
            [/@ui.bambooSection]
        [#else]
            [@ui.bambooSection id='viewer-configuration']
                [@ui.bambooSection]
                    [@s.select
                        name="parentViewer"
                        labelKey='webRepositoryViewer.type'
                        value=parentViewerSelector.name
                        list=[parentViewerSelector.name]
                        disabled=true/]
                [/@ui.bambooSection]

                [#if parentViewerSelector.html!?has_content]
                    ${parentViewerSelector.html!}
                [/#if]
            [/@ui.bambooSection]
        [/#if]
    [/@ui.bambooSection]
[/#macro]