[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchDetails" --]

[#import "/lib/menus.ftl" as menu]
[#import "branchesCommon.ftl" as bc/]

[#macro branchRepositoriesDiscoveryDialog]
<aui-inline-dialog id="branch-repositories-discovery-dialog" class="aui-help" alignment="bottom left"
                   persistent="true">
    <p>${action.getText("branch.config.repository.discovery.widget.content")}</p>
    <br/>
    <button class="aui-button close">${action.getText("branch.config.repository.discovery.widget.ok.button")}</button>
</aui-inline-dialog>
<script type="text/javascript">
    require(['widget/feature-discovery-dialog'], function (DiscoveryDialog) {
        // hack: tabs on the branch page are created dynamically from web-items; as they cannot have extra
        // attributes, we can't pass them in system-webUI-plugin.xml; thus they're added dynamically
        let repositoriesTab = AJS.$('ul.tabs-menu > li.menu-item > a#repository_${immutableChain.key}');
        repositoriesTab.attr('aria-controls', 'branch-repositories-discovery-dialog');

        // show the dialog
        new DiscoveryDialog({
            el: '#branch-repositories-discovery-dialog',
            preferenceKey: 'branch.repositories.discovery.dialog.displayed'
        });
    });
</script>
[/#macro]

[#macro repositoryAndBranchItem repositoryName branchName='' branchLozenge='' statusLozenge='']
<tr>
    <td>${repositoryName?html}</td>
    <td class="long-text">
        [#if branchName?has_content][@ui.icon type="devtools-branch" useIconFont=true /] <span>${branchName?html}</span>[/#if]
        [#if branchLozenge?has_content]<span class="aui-lozenge aui-lozenge-complete aui-lozenge-subtle">${branchLozenge?html}</span>[/#if]
    </td>
    <td>
        [#if statusLozenge?has_content]<span class="aui-lozenge aui-lozenge-complete aui-lozenge-subtle">${statusLozenge?html}</span>[/#if]
    </td>
</tr>
[/#macro]

[#macro repositoryAndBranchListSection partialVcsRepositories]
    [#-- we don't show this section if there are no repositories in the plan --]
    [#if !partialVcsRepositories.empty]
        [@ui.bambooSection id="repository-branch-list" titleKey='branch.repository.list.header' descriptionKey='branch.repository.list.description']
            [@ui.displayFieldGroup]
                <table class="aui">
                    <tbody>
                        [#list partialVcsRepositories as partialVcsRepository]
                            [#if action.getRepositoryBranchName(partialVcsRepository)?has_content]
                                [#assign branchLozenge=''/]
                            [#else]
                                [#assign branchLozenge=i18n.getText('branch.repository.list.branches.unsupported') /]
                            [/#if]
                            [#assign statusLozenge=action.isRepositoryOverridden(partialVcsRepository)?then(
                                    i18n.getText('branch.repository.list.overridden.settings'), '') /]

                            [@repositoryAndBranchItem
                                    repositoryName=partialVcsRepository.name
                                    branchName=action.getRepositoryBranchName(partialVcsRepository)
                                    branchLozenge=branchLozenge
                                    statusLozenge=statusLozenge/]
                        [/#list]
                    </tbody>
                </table>
            [/@ui.displayFieldGroup]
        [/@ui.bambooSection]
    [/#if]
[/#macro]

<html>
<head>
    [#if fn.isConfigurationReadOnly(immutablePlan)]
        [@ui.header pageKey="branch.configuration.view.title.long" object=immutablePlan.name title=true /]
    [#else]
        [@ui.header pageKey="branch.configuration.edit.title.long" object=immutablePlan.name title=true /]
    [/#if]
    <meta name="tab" content="branch.details"/>
</head>
<body>

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@ui.header pageKey="branch.details.edit" headerElement='h2' /]
[#else]
    [@ui.header pageKey="branch.details.edit" descriptionKey="branch.details.edit.description" headerElement='h2' /]
[/#if]

[#assign pageContent]
    [#if repositoryDefinitions.size() > 1  ]
        [#-- show dialog only for multi-repository plans --]
        [@branchRepositoriesDiscoveryDialog/]
    [/#if]

    [@ww.form action="saveChainBranchDetails" namespace="/branch/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
        [@ww.textfield labelKey='branch.name' name='branchName' required=true /]
        [@ww.textfield labelKey='branch.branchDescription' name='branchDescription' required=false longField=true /]
        [@ww.checkbox labelKey='branch.enabled' name="enabled" /]
        [@ww.hidden name="returnUrl" /]
        [@ww.hidden name="planKey" /]
        [@ww.hidden name="buildKey" /]
        [@ww.hidden name="planBranchCreation" /]

        [#if branchDetectionCapable]
            [#assign inactiveAndRemovedBranchCleanUpPlanLevelEnabled = removedBranchCleanUpPlanLevelEnabled && inactiveBranchCleanUpPlanLevelEnabled /]
            [#if inactiveAndRemovedBranchCleanUpPlanLevelEnabled]
                [#assign branchCleanupDescription]
                    [#if removedBranchCleanUpPeriod == 0]
                        [@ww.text name='daily.removed.and.inactive.branch.removal.summary']
                            [@ww.param]${inactiveBranchCleanUpPeriod}[/@ww.param]
                        [/@ww.text]
                    [#else]
                        [@ww.text name='removed.and.inactive.branch.removal.summary']
                            [@ww.param]${removedBranchCleanUpPeriod}[/@ww.param]
                            [@ww.param]${inactiveBranchCleanUpPeriod}[/@ww.param]
                        [/@ww.text]
                    [/#if]
                [/#assign]
            [#elseif removedBranchCleanUpPlanLevelEnabled]
                [#assign branchCleanupDescription]
                    [#if removedBranchCleanUpPeriod == 0]
                        [@ww.text name='daily.removed.branch.removal.summary'/]
                    [#else]
                        [@ww.text name='removed.branch.removal.summary']
                            [@ww.param]${removedBranchCleanUpPeriod}[/@ww.param]
                        [/@ww.text]
                    [/#if]
                [/#assign]
            [#elseif inactiveBranchCleanUpPlanLevelEnabled]
                [#assign branchCleanupDescription]
                    [@ww.text name='inactive.branch.removal.summary']
                        [@ww.param]${inactiveBranchCleanUpPeriod}[/@ww.param]
                    [/@ww.text]
                [/#assign]
            [/#if]
            [@ww.checkbox labelKey='branch.cleanup.description' name='planBranchCleanUpEnabled' description=branchCleanupDescription/]
        [/#if]

        [#include "/build/common/configureTrigger.ftl"]
        [@ui.bambooSection titleKey='repository.change']
            [@ww.checkbox labelKey='branch.trigger.override' name="overrideBuildStrategy" toggle=true helpKey='branch.buildStrategy.override'/]
            [@ui.bambooSection dependsOn="overrideBuildStrategy" showOn=true]
                [@configureTrigger /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]

        [#if mergeCapable]
            [@bc.showIntegrationStrategyConfiguration chain=immutableChain branchesForAutoIntegration=branchesForAutoIntegration/]
        [#elseif defaultRepositoryDefinition??]
            [@bc.mergingNotAvailableMessage action.isGitRepository() defaultRepositoryDefinition defaultRepositoryType/]
        [/#if]

        [@repositoryAndBranchListSection partialVcsRepositories=partialVcsRepositoryData/]

    [/@ww.form]
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.details" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]

</body>
</html>

