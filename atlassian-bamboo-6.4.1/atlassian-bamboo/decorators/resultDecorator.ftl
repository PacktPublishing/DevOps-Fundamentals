[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedResult" type="com.atlassian.bamboo.ww2.beans.DecoratedResult" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu]
[#import "/fragments/breadCrumbs.ftl" as bc]
[#import "/fragments/decorator/decorators.ftl" as decorators/]


[#if ctx.featureManager.limitedTimeQuarantineEnabled]
    [@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.result", "bamboo.result.quarantine.limited"]/]
[#else]
    [@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.result", "bamboo.result.quarantine"]/]
[/#if]

[@displayFavicon navigationContext.currentObject navigationContext.navObject/]
[#include "/fragments/showAdminErrors.ftl"]

[#if (navigationContext.currentObject)?? && navigationContext.currentObject.isResult()]
    [#assign decoratedResult = navigationContext.currentObject/]
    [#assign metaTabData = page.properties["meta.tab"]! /]
    [#assign navPlan = navigationContext.navObject/]

    [#assign headerImageContent]
        [@bc.showBreadcrumbsIcon decoratedResult /]
    [/#assign]
    [#assign headerMainContent]
        [@bc.showBreadcrumbs decoratedResult /]
        [@ui.renderWebPanels location='plan.result.header.breadcrumbs' /]
    [/#assign]

    [#assign headerActionsContent]
        [#if immutablePlan??]
            [#if fn.isChain(decoratedResult)]
                [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(immutablePlan)/]
                [#assign planLevelItems]
                    [#if !immutablePlan.suspendedFromBuilding]
                        [@menu.displayPlanSuspendLink immutablePlan planI18nPrefix+'.disable'/]
                    [#else]
                        [@menu.displayPlanResumeLink immutablePlan planI18nPrefix+'.enable'/]
                    [/#if]
                    [#if user??]
                        [@menu.displayFavouriteToggler plan=immutablePlan/]
                    [/#if]
                    [#if fn.isConfigurationReadOnly(immutablePlan)]
                        [@menu.displayConfigureLink immutablePlan planI18nPrefix+".configuration.view"/]
                    [#else]
                        [@menu.displayConfigureLink immutablePlan planI18nPrefix+".configuration.edit"/]
                    [/#if]
                    [@menu.displayAddPlanLabelLink immutablePlan planI18nPrefix+".add.label" false/]
                [/#assign]
                [#assign buildLevelItems]
                    [#if resultsSummary.active]
                        [@menu.displayResultStopLink resultsSummary planI18nPrefix+'.stop.result'/]
                    [/#if]
                    [#if resultsSummary.finished || resultsSummary.notBuilt]
                        [@menu.displayResultDeleteLink resultsSummary planI18nPrefix+'.remove.result'/]
                    [/#if]
                    [@menu.displayCreateNewIssue immutablePlan 'buildResult.create.new.issue' /]
                [/#assign]
                [#assign pluginItems]
                    [@menu.displayWebItems plan=immutablePlan location="chainResult.actions" /]
                [/#assign]
            [#else]
                [#assign jobLevelItems]
                    [#if !fn.isConfigurationReadOnly(immutablePlan)]
                        [#if immutablePlan.suspendedFromBuilding]
                            [@menu.displayJobResumeLink immutablePlan "job.enable"/]
                        [#else]
                            [@menu.displayJobSuspendLink immutablePlan "job.disable"/]
                        [/#if]
                    [/#if]
                    [#if fn.isBranch(immutablePlan.parent)]
                        [#if fn.isConfigurationReadOnly(immutablePlan.parent)]
                            [@menu.displayConfigureLink immutablePlan.getMaster() "job.configuration.view"/]
                        [#else]
                            [@menu.displayConfigureLink immutablePlan.getMaster() "job.configuration.edit"/]
                        [/#if]
                    [#else]
                        [#if fn.isConfigurationReadOnly(immutablePlan)]
                            [@menu.displayConfigureLink immutablePlan "job.configuration.view"/]
                        [#else]
                            [@menu.displayConfigureLink immutablePlan "job.configuration.edit"/]
                        [/#if]
                    [/#if]
                [/#assign]
                [#assign buildLevelItems]
                    [#if resultsSummary.active]
                        [#if resultsSummary.inProgress || resultsSummary.queued]
                            [@menu.displayResultStopLink resultsSummary "job.stop"/]
                        [/#if]
                    [/#if]
                [/#assign]
                [#assign pluginItems]
                    [@menu.displayWebItems plan=immutablePlan location="jobResult.actions" /]
                [/#assign]
            [/#if]

            [#assign menuButtons]
                [@menu.displayChainRunMenu plan=((immutablePlan.parent)!immutablePlan)/]
                [@menu.displayHeaderActions buildItems=buildLevelItems! jobItems=jobLevelItems! planItems=planLevelItems! pluginItems=pluginItems! /]
            [/#assign]

            ${soy.render('aui.buttons.buttons', {
                'extraClasses': 'aui-dropdown2-trigger-group',
                'content': menuButtons}
            )}

            [#if immutablePlan??]
                ${soy.render("bamboo.deployments:linked-deployment-shortcut", 'feature.plan.linkedDeployment.linkedDeploymentHeaderDropdown', {
                    'immutablePlan': ((immutablePlan.parent)!immutablePlan),
                    'hasLinkedDeployments': ctx.hasLinkedDeployments(((immutablePlan.parent)!immutablePlan).planKey)
                })}
            [/#if]

        [/#if]
    [/#assign]

    [#assign headerExtraContent]
        [#if decoratedResult??]
            [#if decoratedResult.parent?has_content]
                [#if decoratedResult.parent.linkedJiraIssue?has_content]
                    <div class="plan-description" data-jira-issue-key="${decoratedResult.parent.linkedJiraIssue?html}" data-remote-jira-link-required="${decoratedResult.parent.remoteJiraLinkRequired?string}"></div>
                [#elseif decoratedResult.parent.description?has_content]
                    <div class="plan-description" title="${decoratedResult.parent.description?html}">${decoratedResult.parent.description?html}</div>
                [/#if]
            [#else]
                [#if decoratedResult.linkedJiraIssue?has_content]
                    <div class="plan-description" data-jira-issue-key="${decoratedResult.linkedJiraIssue?html}" data-remote-jira-link-required="${decoratedResult.remoteJiraLinkRequired?string}"></div>
                [#elseif decoratedResult.description?has_content]
                    <div class="plan-description" title="${decoratedResult.description?html}">${decoratedResult.description?html}</div>
                [/#if]
            [/#if]
        [/#if]
        [@chains.statusRibbon navigationContext /]
    [/#assign]

    [#if !decoratedResult.status.isSpecsResult()]
        [#assign resultSidebar]
            <div id="plan-navigator">
                [@chains.planNavigator navigationContext /]
                [@ui.renderWebPanels 'plan.navigator' /]
            </div>
        [/#assign]
    [/#if]

    [#assign mainContent]
        [@menu.displayTabbedContent selectedTab=metaTabData location=fn.isChain(decoratedResult)?string("chainResults.subMenu", "results.subMenu")]${body}[/@menu.displayTabbedContent]

        [@dj.simpleDialogForm
            triggerSelector=".run-custom-stage"
            width=800
            height=400
            submitCallback="redirectAfterReturningFromDialog"/]

        <a id="editPlanLink" class="hidden" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${decoratedResult.planKey}" accesskey="E">Edit Plan</a>
        <script type="text/javascript">
            AJS.whenIType("e").followLink("#editPlanLink");
                [#if decoratedResult?? && ((decoratedResult.parent)!decoratedResult).linkedJiraIssue?has_content]
                BAMBOO.PLAN.LinkedJiraIssueDescription({
                    planKey: '${((decoratedResult.parent)!decoratedResult).planKey}'
                });
                [/#if]
        </script>
    [/#assign]

    ${soy.render("bamboo.layout.plan", {
        "headerImageContent": headerImageContent,
        "headerMainContent": headerMainContent,
        "headerActionsContent": headerActionsContent,
        "headerExtraContent": headerExtraContent,
        "pageItemContent": resultSidebar!,
        "pageItemClass": "plan-sidebar" + (!((navPlan.navGroups?has_content && (navPlan.navGroups?size > 1 || navPlan.navGroups?first.children?size > 1)) || decoratedResult.parent??))?string(" collapsed", ""),
        "content": mainContent,
        "planStatusHistory": chains.getPlanStatusHistoryDetails()
    })}
[#else]
    <section id="content" role="main">
        <div class="aui-panel">
            [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)" /]
            ${body}
        </div>
    </section>
[/#if]
[#include "/fragments/decorator/footer.ftl"]

[#macro displayFavicon decoratedResult navObject]
[#-- @ftlvariable name="decoratedResult" type="com.atlassian.bamboo.ww2.beans.DecoratedNavObject" --]
    [#assign favicoUrl = "/images/icons/favicon.ico"/]
    [#assign favicoType = "image/x-icon"/]
    [#if decoratedResult.status.buildState == "Successful"]
        [#if decoratedResult.status.specsSuccess]
            [#assign favicoUrl = "/images/iconsv4/icon-build-spec-success-64x64.png"/]
            [#assign favicoType = "image/png"/]
        [#elseif decoratedResult.status.continuable]
            [#assign favicoUrl = "/images/iconsv4/icon-build-continue-64x64.png"/]
            [#assign favicoType = "image/png"/]
        [#else]
            [#assign favicoUrl = "/images/iconsv4/icon-build-successful-64x64.png"/]
            [#assign favicoType = "image/png"/]
        [/#if]
    [#elseif decoratedResult.status.buildState == "Failed"]
        [#if decoratedResult.status.specsFailure]
            [#assign favicoUrl = "/images/iconsv4/icon-build-spec-failure-64x64.png"/]
            [#assign favicoType = "image/png"/]
        [#else]
            [#assign favicoUrl = "/images/iconsv4/icon-build-failed-64x64.png"/]
            [#assign favicoType = "image/png"/]
        [/#if]
    [#elseif decoratedResult.status.lifeCycleState == "Queued" || decoratedResult.status.lifeCycleState == "Pending"]
        [#assign favicoUrl = "/images/iconsv4/icon-build-queued-64x64.png"/]
        [#assign favicoType = "image/png"/]
    [#elseif decoratedResult.status.lifeCycleState == "InProgress"]
        [#assign favicoUrl = "/images/iconsv4/icon-building-static-64x64.png"/]
        [#assign favicoType = "image/png"/]
    [#elseif decoratedResult.status.notRunYet]
        [#assign favicoUrl = "/images/iconsv4/icon-build-job-64x64.png"/]
        [#assign favicoType = "image/png"/]
    [#else]
        [#assign favicoUrl = "/images/iconsv4/icon-build-unknown-64x64.png"/]
        [#assign favicoType = "image/png"/]
    [/#if]
    <script type="text/javascript">
         AJS.$(function ($) {
            Piecon.setFavicon('[@cp.getStaticResourcePrefix /]' + '${favicoUrl}');
        });
    </script>
[/#macro]