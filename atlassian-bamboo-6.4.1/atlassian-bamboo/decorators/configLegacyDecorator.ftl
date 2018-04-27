[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.PlanActionSupport" --]
[#-- @ftlvariable name="decoratedPlan" type="com.atlassian.bamboo.ww2.beans.DecoratedPlan" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu]
[#import "/fragments/breadCrumbs.ftl" as bc]
[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.configuration"] /]
[#include "/fragments/showAdminErrors.ftl"]
[#if (navigationContext.currentObject)?? && !navigationContext.currentObject.isResult()]
    <script type="text/javascript">
        AJS.trigger('analyticsEvent', {
            name: 'bamboo.plan.configuration.visit',
            data: {
                readonly: ${fn.isConfigurationReadOnly(immutablePlan)?then('true', 'false')},
                yaml: ${fn.isYamlSpecsConfiguration(immutablePlan)?then('true', 'false')}
            }
        });
    </script>
    [#assign decoratedPlan = navigationContext.currentObject/]
    [#assign metaTabData = page.properties["meta.tab"]! /]

    [#if fn.isBranch(decoratedPlan)]
        [#assign navLocation = decoratedPlan.key /]
        [#assign tabLocation = "branchConfiguration.subMenu" /]
    [#elseif fn.isJob(decoratedPlan)]
        [#assign navLocation = decoratedPlan.key/]
        [#assign tabLocation = "planConfiguration.subMenu"/]
    [#else]
        [#assign navLocation = "chain.general" /]
        [#assign tabLocation = "chainConfiguration.subMenu" /]
    [/#if]

    [#assign headerImageContent]
        [@bc.showBreadcrumbsIcon decoratedPlan /]
    [/#assign]
    [#assign headerMainContent]
        [@bc.showBreadcrumbs decoratedObject=decoratedPlan isConfig=true isReadonly=fn.isConfigurationReadOnly(immutablePlan) /]
    [/#assign]

    [#assign headerActionsContent]
        [#if fn.isChain(immutablePlan)]
            [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(immutablePlan)/]
            [#assign planLevelItems]
                [#if !immutablePlan.suspendedFromBuilding]
                    [@menu.displayPlanSuspendLink immutablePlan planI18nPrefix+'.disable'/]
                [#else]
                    [@menu.displayPlanResumeLink immutablePlan planI18nPrefix+'.enable'/]
                [/#if]
                [@menu.displayAddPlanLabelLink immutablePlan planI18nPrefix+'.add.label' /]
                [#if fn.isBranch(immutablePlan)]
                    [@ww.url var='redirectUrl' value='/browse/${immutablePlan.master.key}/editConfig' /]
                    [@menu.displayPlanDeleteLink immutablePlan 'branch.delete' redirectUrl /]
                [#else]
                    [@ww.url var='redirectUrl' action='start' /]
                    [@menu.displayPlanDeleteLink immutablePlan 'chain.delete' redirectUrl /]
                    [@menu.displayPlanYamlLink immutablePlan 'chain.view.yaml' /]
                    [@menu.displayPlanSpecsLink immutablePlan 'chain.view.specs'/]
                [/#if]
            [/#assign]
        [#elseif immutablePlan?? && immutablePlan.planType == 'JOB']
            [#assign jobLevelItems]
                [#if !fn.isConfigurationReadOnly(immutablePlan)]
                    [#if !immutablePlan.suspendedFromBuilding]
                        [@menu.displayJobSuspendLink immutablePlan 'job.disable'/]
                    [#else]
                        [@menu.displayJobResumeLink immutablePlan 'job.enable'/]
                    [/#if]
                    [@ww.url var='redirectUrl' value='/browse/${immutablePlan.parent.key}' /]
                    [@menu.displayPlanDeleteLink immutablePlan 'job.delete' redirectUrl /]
                [/#if]
            [/#assign]
        [/#if]

        [#assign menuButtons]
            [@menu.displayChainRunMenu plan=((immutablePlan.parent)!immutablePlan)/]
            [@menu.displayHeaderActions jobItems=jobLevelItems! planItems=planLevelItems! /]
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

    [/#assign]

    [#assign headerExtraContent]
        [#if decoratedPlan??]
            [#assign planDescription]
                [#if fn.isBranch(decoratedPlan)]
                    ${(decoratedPlan.master.description)!""}
                [#elseif decoratedPlan.parent?has_content && fn.isBranch(decoratedPlan.parent)]
                    ${(decoratedPlan.parent.master.description)!""}
                [#elseif decoratedPlan.parent?has_content]
                    ${(decoratedPlan.parent.description)!""}
                [#elseif decoratedPlan.description?has_content]
                    ${(decoratedPlan.description)!""}
                [/#if]
            [/#assign]
            [#import "/fragments/labels/labels.ftl" as lb /]
            [@lb.showLabelEditorForPlan plan=decoratedPlan /]
        [/#if]
    [/#assign]

    [#assign configSidebar]
        <div id="config-sidebar">
            [#if fn.isMasterConfigurationReadOnly(immutablePlan)]
                <div class="configSideBarNotification">
                    [#assign rssRepositoryLink = ctx.getRssLink(immutablePlan)!('')/]
                    [#assign rssLinkUsedAnalyticEvent = fn.isYamlSpecsConfiguration(plan)?then('bamboo.plan.rss.yaml.repo.link.used','bamboo.plan.rss.java.repo.link.used')/]
                    [#if rssRepositoryLink?has_content]
                        [@s.text name="rss.specs.plan.managed"]
                            [@s.param]rssRepositoryLink[/@s.param]
                            [@s.param]${rssRepositoryLink}[/@s.param]
                            [@s.param]${rssLinkUsedAnalyticEvent}[/@s.param]
                        [/@s.text]
                    [#else]
                        [@s.text name="rss.specs.plan.managed.nolink"/]
                    [/#if]
                </div>
            [/#if]

            [#if navigationContext.navObject.master?has_content]
                [#-- TODO: The ?replace() below is a hack to compensate for navigationContext.navObject.master not being a DecoratedPlan --]
                [@ww.url value=navigationContext.getChainUrl(navigationContext.navObject)?replace(navigationContext.navObject.key, navigationContext.navObject.master.planKey.toString()) var='planUrl'/]
            [#else]
                [@ww.url value=navigationContext.getChainUrl(navigationContext.navObject) var='planUrl'/]
            [/#if]
            <h2[#if navLocation="chain.general"] class="active"[/#if]><a href="${planUrl}">[@ww.text name="plan.title"/] Configuration</a></h2>
            [@chains.planNavigator navigationContext true/]
            [@chains.branchNavigator navigationContext/]
            [@ui.renderWebPanels 'plan.navigator' /]
        </div>
    [/#assign]

    [#assign mainContent]
        [#assign sidebar]
            [#if fn.isConfigurationReadOnly(immutablePlan)]
                <script>
                    require('feature/plan-config-read-only').makeReadOnly('.aui-page-panel-content');
                </script>
            [/#if]
        [/#assign]
        [@menu.displayTabbedContent location=tabLocation selectedTab=metaTabData historyXhrDisabled=true sidebar=sidebar]
            [#if saved?? && saved]
                [@ui.messageBox type="success" titleKey="${tabLocation}.confirmsave" /]
            [/#if]
            ${body}
        [/@menu.displayTabbedContent]

        [#if fn.isYamlSpecsConfiguration(immutablePlan)]
        <script>
            require('feature/plan-yaml-config').initYamlConfig('.aui-page-panel-content > .aui-tabs');
        </script>
        [/#if]
        <script>
            BAMBOO.currentPlan = {
                key: '${decoratedPlan.key}',
                name: '${decoratedPlan.displayName?js_string}'
            };
            BAMBOO.ConfigSidebar.init();
        </script>
    [/#assign]

    ${soy.render("bamboo.layout.plan", {
        "headerImageContent": headerImageContent,
        "headerMainContent": headerMainContent,
        "headerActionsContent": headerActionsContent!,
        "headerExtraContent": headerExtraContent,
        "pageItemContent": configSidebar,
        "pageItemClass": "plan-sidebar",
        "content": mainContent,
        "planStatusHistory": chains.getPlanStatusHistoryDetails()
    })}

    <script>
        require('feature/plan-config-delete-confirmation')();
    </script>
[#else]
    <section id="content" role="main">
        <div class="aui-panel">
            [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)" /]
            ${body}
        </div>
    </section>
[/#if]
[#include "/fragments/decorator/footer.ftl"]
