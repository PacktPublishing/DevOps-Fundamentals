[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]

[#-- ================================================================================================= HELPER MACROS --]
[#macro displayAUIDropdown2Section]
<div class="aui-dropdown2-section">
    <ul>[#nested /]</ul>
</div>
[/#macro]

[#macro displayHeaderActions buildItems='' jobItems='' planItems='' pluginItems='']
    [#local actionsText][@ww.text name="menu.actions" /][/#local]
    [#if planItems?has_content || jobItems?has_content || buildItems?has_content || pluginItems?has_content]
        [@ui.groupedMenu triggerText=actionsText id="buildMenuParent" icon="configure" useIconFont=true triggerBeforeDropdown=false cssClass="aui-dropdown2-in-page-header"]
            [#if buildItems?has_content]
                [@displayAUIDropdown2Section]${buildItems}[/@displayAUIDropdown2Section]
            [/#if]
            [#if jobItems?has_content]
                [@displayAUIDropdown2Section]${jobItems}[/@displayAUIDropdown2Section]
            [/#if]
            [#if planItems?has_content]
                [@displayAUIDropdown2Section]${planItems}[/@displayAUIDropdown2Section]
            [/#if]
            [#if pluginItems?has_content]
                [@displayAUIDropdown2Section]${pluginItems}[/@displayAUIDropdown2Section]
            [/#if]
        [/@ui.groupedMenu]
    [/#if]
[/#macro]

[#-- Renders all tabs and their contents, allows switching between them without reloading the page --]
[#macro displayInstantTabbedContent tabs]
    <div class="aui-tabs horizontal-tabs">
        <ul class="tabs-menu">
            [#list tabs as tab]
                [#if tab.skip!false][#break][/#if]
                <li class="menu-item ${(tab.active!false)?string('active-tab','')}">
                    <a href="#${tab.id}" data-tab-id="${tab.id}">${tab.label}</a>
                </li>
            [/#list]
        </ul>
        [#list tabs as tab]
            [#if tab.skip!false][#break][/#if]
            <div class="tabs-pane ${(tab.active!false)?string('active-pane','')}" id="${tab.id}">
                ${tab.contents}
            </div>
        [/#list]
    </div>
    <script>
        AJS.tabs.setup();
    </script>
[/#macro]

[#macro displayTabbedContent selectedTab location admin=false historyXhrDisabled=false sidebar="" linkCssClass="" analyticsEvent=""]
<div class="aui-tabs horizontal-tabs aui-tabs-disabled[#if historyXhrDisabled] history-xhr-disabled[/#if]">
    [#if sidebar?has_content]${sidebar}[/#if]
    <ul class="tabs-menu">
        [#if admin]
            [@displayTabsNoAction selectedTab=selectedTab location=location linkCssClass=linkCssClass analyticsEvent=analyticsEvent/]
        [#else]
            [@displayTabs selectedTab=selectedTab location=location linkCssClass=linkCssClass analyticsEvent=analyticsEvent/]
        [/#if]
    </ul>
    <div class="tabs-pane active-pane">
        [#nested /]
    </div>
</div>
[/#macro]

[#macro displayJobsTabs currentPlan selectedTab linkCssClass="jsLoadPage history-xhr-disabled'"]
    [#if fn.isBranch(currentPlan)]
        [#assign navLocation = currentPlan.key /]
        [#assign tabLocation = "branchConfiguration.subMenu" /]
    [#elseif fn.isJob(currentPlan)]
        [#assign navLocation = currentPlan.key/]
        [#assign tabLocation = "planConfiguration.subMenu"/]
    [#else]
        [#assign navLocation = "chain.general" /]
        [#assign tabLocation = "chainConfiguration.subMenu" /]
    [/#if]

    [@displayTabbedContent location=tabLocation selectedTab=selectedTab linkCssClass=linkCssClass]
        [#if saved?? && saved]
            [@ui.messageBox type="success" titleKey="${tabLocation}.confirmsave" /]
        [/#if]
    [/@displayTabbedContent]
[/#macro]


[#macro displayCombinedTabbedContent selectedTab location innerLocation admin=false historyXhrDisabled=false sidebar=""]
<div class="aui-tabs horizontal-tabs aui-tabs-disabled[#if historyXhrDisabled] history-xhr-disabled[/#if]">
    [#if sidebar?has_content]${sidebar}[/#if]
    <ul class="tabs-menu">
        [#if admin]
            [@displayTabsNoAction selectedTab location/]
        [#else]
            [@displayTabs selectedTab location innerLocation/]
        [/#if]
    </ul>
    <div class="tabs-pane active-pane">
        [#nested /]
    </div>
</div>
[/#macro]

[#macro displayTabs selectedTab location innerLocation="" linkCssClass="" analyticsEvent=""]
    [#assign selectedIndex = 0/]
    [#list action.getWebSectionsForLocation(location) as section ]
        [#assign actionItems=action.getWebItemsForSection(location + '/' + section.key) /]
        [#list actionItems as item]
            [#assign id=(item.link.getRenderedId(webFragmentsContextMap)!action.renderFreemarkerTemplate(item.key)?html)!""/]
            [#assign url=item.link.getDisplayableUrl(req, webFragmentsContextMap)]
            [@displaySingleTab item=item selectedTab=selectedTab id=id url=url linkCssClass=linkCssClass sectionKey=section.key analyticsEvent=analyticsEvent params=item.params/]
            [#if selectedTab == item.name]
                [#assign selectedIndex=item_index /]
            [/#if]
        [/#list]

        [#if innerLocation?has_content]
            [#list action.getWebSectionsForLocation(innerLocation) as innerSection ]
                [#assign actions=action.getJobsWebItemsForSection(innerLocation + '/' + innerSection.key, req)]
                [#list actions.keySet() as item]
                    [#assign id=(item.link.getRenderedId(webFragmentsContextMap)!action.renderFreemarkerTemplate(item.key)?html)!""/]
                    [#assign url=actions.get(item)]
                    [@displaySingleTab item=item selectedTab=selectedTab id=id url=url linkCssClass=linkCssClass analyticsEvent=analyticsEvent params=item.params/]
                    [#if selectedTab == item.name]
                        [#assign selectedIndex=item_index+actionItems.size() /]
                    [/#if]
                [/#list]
            [/#list]
        [/#if]
    [/#list]
[/#macro]

[#macro displayTabsNoAction selectedTab location linkCssClass="" analyticsEvent=""]
    [#assign selectedIndex = 0/]
    [#local webFragmentsContext = ctx.getWebFragmentsContextMapNoAction(req)/]
    [#list ctx.getWebSectionsForLocationNoAction(location, req) as section ]
        [#list ctx.getWebItemsForSectionNoAction(location + '/' + section.key, req) as item]
            [#assign url=item.link.getDisplayableUrl(req)]
            [#assign id=item.link.getRenderedId(webFragmentsContext)/]
            [#if !id??]
                [#assign id=ctx.renderFreemarkerTemplateNoAction(item.key, req)?html/]
            [/#if]
            [@displaySingleTab item=item selectedTab=selectedTab id=id url=url linkCssClass=linkCssClass analyticsEvent=analyticsEvent params=item.params/]
        [/#list]
    [/#list]
[/#macro]

[#macro displaySingleTab item selectedTab id url linkCssClass sectionKey="" analyticsEvent="" params=[]]
    <li class="menu-item[#if selectedTab == item.name] active-tab[/#if]" [#if sectionKey?has_content]data-section="${sectionKey}"[/#if] data-params=${action.toJson(params)}>
        <a [#t]
            [#if id?has_content] id="${id}"[/#if] [#t]
            href="${url}" [#t]
            class="${linkCssClass}" [#t]
            [#if analyticsEvent?has_content]
                [#assign analyticsEventPayload]
                    { [#t]
                        "name": "${analyticsEvent}", [#t]
                        "data": {"tabName": "${item.name}"} [#t]
                    } [#t]
                [/#assign]
                data-bamboo-analytics-event='${analyticsEventPayload}' [#t]
            [/#if]
        ><strong>${item.webLabel.displayableLabel}</strong></a>
    </li>
[/#macro]

[#function getNavItems selectedTab location innerLocation="" admin=false]
    [#local navItems = [] /]
    [#if admin]
        [#local webFragmentsContext = ctx.getWebFragmentsContextMapNoAction(req)/]
        [#list ctx.getWebSectionsForLocationNoAction(location, req) as section ]
            [#list ctx.getWebItemsForSectionNoAction(location + '/' + section.key, req) as item]
                [#local url=item.link.getDisplayableUrl(req)]
                [#local id=item.link.getRenderedId(webFragmentsContext)/]
                [#if !id??]
                    [#local id=ctx.renderFreemarkerTemplateNoAction(item.key, req)?html/]
                [/#if]
                [#local navItems = navItems + [{
                "content": item.webLabel.displayableLabel,
                "linkId": id!,
                "href": url!,
                "isSelected": (selectedTab == item.name),
                "badge": {"text": item.badgeProvider.getBadge(webFragmentsContext)!""},
                "extraClasses": item.styleClass!
                }] /]
            [/#list]
        [/#list]
    [#else]
        [#list action.getWebSectionsForLocation(location) as section]
            [#local actionItems=action.getWebItemsForSection(location + '/' + section.key) /]
            [#list actionItems as item]
                [#local id=(item.link.getRenderedId(webFragmentsContextMap)!action.renderFreemarkerTemplate(item.key)?html)!""/]
                [#local url=item.link.getDisplayableUrl(req, webFragmentsContextMap)]
                [#local navItems = navItems + [{
                "content": item.webLabel.displayableLabel,
                "linkId": id!,
                "href": url!,
                "isSelected": (selectedTab == item.name),
                "badge": {"text": item.badgeProvider.getBadge(webFragmentsContextMap)!""},
                "extraClasses": item.styleClass!
                }] /]
            [/#list]

            [#if innerLocation?has_content]
                [#list action.getWebSectionsForLocation(innerLocation) as innerSection ]
                    [#local actions=action.getJobsWebItemsForSection(innerLocation + '/' + innerSection.key, req)]
                    [#list actions.keySet() as item]
                        [#local id=(item.link.getRenderedId(webFragmentsContextMap)!action.renderFreemarkerTemplate(item.key)?html)!""/]
                        [#local url=actions.get(item)]
                        [#local navItems = navItems + [{
                        "content": item.webLabel.displayableLabel,
                        "linkId": id!,
                        "href": url!,
                        "isSelected": (selectedTab == item.name),
                        "badge": {"text": item.badgeProvider.getBadge(webFragmentsContextMap)!""},
                        "extraClasses": item.styleClass
                        }] /]
                    [/#list]
                [/#list]
            [/#if]
        [/#list]
    [/#if]
    [#return navItems /]
[/#function]

[#macro displayManualStartButton plan labelKey]
    [#if !ctx.storageCappingService.hardLimitExceeded]
        [#if fn.hasPlanPermission('BUILD', plan)]
            [#if !plan.suspendedFromBuilding]
                [#if isUnderMaxConcurrentBuilds(plan)]
                    [@ww.url var='startPlanUrl' action="triggerManualBuild" namespace="/build/admin" buildKey="${plan.key}" /]
                <a href="${startPlanUrl}" class="mutative" id="manualBuild_${plan.key}">[@ui.icon type="build-run"/] [@ww.text name=labelKey/]</a>
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayManualStartLink plan labelKey]
    [#if !ctx.storageCappingService.hardLimitExceeded]
        [#if fn.hasPlanPermission('BUILD', plan)]
            [#if !plan.suspendedFromBuilding]
                [#if isUnderMaxConcurrentBuilds(plan)]
                    [@ww.url var='startPlanUrl' action="triggerManualBuild" namespace="/build/admin" buildKey="${plan.key}" /]
                    [@ui.displayLink id="manualBuild_${plan.key}"
                    titleKey=labelKey
                    href=startPlanUrl
                    showIcon=false
                    inList=true mutative=true/]
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayParametrisedManualStartLink plan labelKey]
    [#if !ctx.storageCappingService.hardLimitExceeded]
        [#if fn.canRunParameterisedBuild(plan)]
            [#if !plan.suspendedFromBuilding]
                [#if isUnderMaxConcurrentBuilds(plan)]
                    [@ww.url var="editParameterisedManualBuild" action="editParameterisedManualBuild" namespace="/ajax" planKey=plan.key returnUrl=currentUrl /]
                    [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(plan)/]
                    [#local helpText][@ww.text name="chain.run.parameterised.hint"][@ww.param][@help.href pageKey="plan.run.parameterised" /][/@ww.param][/@ww.text][/#local]
                    [@dj.simpleDialogForm triggerSelector="#parameterisedManualBuild_${plan.key}"
                    width=800
                    height=400
                    headerKey="${planI18nPrefix}.editParameterisedManualBuild.form.title"
                    submitCallback="redirectAfterReturningFromDialog"
                    help=helpText/]

                    [@ui.displayLinkForAUIDialog id="parameterisedManualBuild_${plan.key}"
                    titleKey=labelKey
                    inList=true
                    href=editParameterisedManualBuild/]
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayPlanStopLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [#assign numberOfRunningChains = action.getNumberOfCurrentlyBuildingPlans(plan.key) /]
        [#if numberOfRunningChains > 0]
            [#if numberOfRunningChains > 1]
                [@ww.url var="viewRunningPlansUrl" action="viewRunningPlans" namespace="/ajax" planKey=plan.key returnUrl=currentUrl/]
                [@dj.simpleDialogForm triggerSelector=".build-stop_${plan.key}"
                actionUrl="${viewRunningPlansUrl}"
                width=800
                height=400
                submitLabelKey="build.stop.confirmation.button" /]
                [@ui.displayLinkForAUIDialog id="stopBuild_${plan.key}"
                titleKey=labelKey
                cssClass="mutative build-stop_${plan.key}"
                icon="build-stop"
                showTitle=true
                inList=true /]
            [#else]
                [@ww.url var='stopPlanUrl'  action='stopPlan' namespace='/build/admin' planKey='${plan.key}'  returnUrl='/browse/${plan.key}' /]
                [@ui.displayLink id="stopPlan_${plan.key}"
                titleKey=labelKey
                href=stopPlanUrl
                mutative=true
                icon="build-stop"
                inList=true /]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayResultStopLink resultSummary labelKey]
    [#if fn.hasPlanPermission('BUILD', resultSummary.immutablePlan)]
        [@ww.url var='stopResultUrl' action='stopPlan' namespace='/build/admin'
        planResultKey='${resultSummary.planResultKey}' returnUrl='/browse/${resultSummary.planResultKey}' /]
        [@ui.displayLink mutative=true id="stopBuild_${resultSummary.planResultKey}"
        titleKey=labelKey
        href=stopResultUrl
        icon="build-stop"
        inList=true /]
    [/#if]
[/#macro]

[#macro displayConfigureLink plan labelKey]
    [#if fn.hasPlanPermission('WRITE', plan)]
        [@ww.url var='editPlanUrl' value="/browse/${plan.key}/editConfig" /]
        [@ui.displayLink id="editBuild:${plan.key}"
        titleKey=labelKey
        href=editPlanUrl
        icon="build-configure"
        inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanResumeButton plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url var='resumePlanUrl' action="resumeBuild" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
    <a href="${resumePlanUrl}" class="mutative" id="resumeBuild:${plan.key}">[@ui.icon type="build-enable"/] [@ww.text name=labelKey/]</a>
    [/#if]
[/#macro]

[#macro displayPlanResumeLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url var='resumePlanUrl' action="resumeBuild" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        [@ui.displayLink id="resumeBuild:${plan.key}"
        titleKey=labelKey
        href=resumePlanUrl
        icon="build-enable"
        mutative=true
        inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanSuspendLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url var='suspendBuildUrl' action="suspendBuild" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        [@ui.displayLink id="suspendBuild:${plan.key}"
        titleKey=labelKey
        href=suspendBuildUrl
        icon="build-disable"
        inList=true
        mutative=true /]
    [/#if]
[/#macro]

[#macro displayJobResumeLink plan labelKey]
    [#if fn.hasPlanPermission('WRITE', plan)]
        [@ww.url var='resumeJobUrl' action="resumeJob" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        [@ui.displayLink id="resumeJob:${plan.key}"
        titleKey=labelKey
        href=resumeJobUrl
        icon="build-enable"
        mutative=true
        inList=true /]
    [/#if]
[/#macro]

[#macro displayJobSuspendLink plan labelKey]
    [#if fn.hasPlanPermission('WRITE', plan)]
        [@ww.url var='suspendJobUrl' action="suspendJob" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        [@ui.displayLink id="suspendJob:${plan.key}"
        titleKey=labelKey
        href=suspendJobUrl
        icon="build-disable"
        inList=true
        mutative=true /]
    [/#if]
[/#macro]

[#macro displayPlanWallboardLink plan ]
    [#if !fn.isBranch(plan)]
        [@ww.url var='wallboardUrl' value="/telemetry.action?filter=showPlanAndBranches&planKey=${plan.key}" /]
        [@ui.displayLink id="wallboard:${plan.key}"
        titleKey="chain.wallboard"
        href=wallboardUrl
        icon="wallboard"
        inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanDeleteLink plan labelKey redirectUrl='' useIcon=true]
    [#assign icon = useIcon?then('remove','') /]

    [#if fn.isJob(plan)]
        [#assign title=action.getText('job.delete')]
    [#elseif fn.isBranch(plan)]
        [#assign title=action.getText('branch.delete')]
    [#else]
        [#assign title=action.getText('plan.delete.title')]
    [/#if]

    [#if fn.hasPlanPermission('ADMINISTRATION', plan)]
        [@ww.url var='deletePlanUrl' action='confirmDeleteChain' namespace="/ajax" buildKey="${plan.key}" /]
        [@ui.displayLink id="deleteBuild:${plan.key}"
        cssClass='plan-delete-link'
        titleKey=labelKey
        href=deletePlanUrl
        icon=icon
        useIconFont=true
        inList=true
        extraAttributes={
            'data-redirect': redirectUrl,
            'data-title': title
        }/]
    [/#if]
[/#macro]

[#macro displayProjectDeleteLink projectKey projectWithPlans labelKey confirmMessage redirectUrl='' tooltipLabel='']
    [#assign title=action.getText(labelKey)]

    [@ui.asyncLink
        id='deleteProject_${project.key}'
        url='${req.contextPath}/rest/api/latest/project/${projectKey}'
        type='DELETE'
        label=title
        icon='remove'
        confirmationMessage=confirmMessage
        returnUrl=redirectUrl
        tooltip=tooltipLabel?has_content?then(action.getText(tooltipLabel), '')
        disabled=projectWithPlans
        cssClass='aui-button'
    /]
[/#macro]


[#macro displayViewPlanConfigurationLink plan labelKey]
    [@ww.url var='viewPlanConfigurationUrl' value="/browse/${plan.key}/config" /]
    [@ui.displayLink id="viewPlanConfiguration:${plan.key}"
    titleKey=labelKey
    href=viewPlanConfigurationUrl
    icon="view-plan"
    inList=true/]
[/#macro]

[#macro displayPlanYamlLink plan labelKey]
    [#if featureManager.isExportToYamlUiEnabled()
        && fn.hasPlanPermission('WRITE', plan)]
        [@s.url var='exportPlanUrl' action="plan" namespace="/export" buildKey="${plan.key}" /]
        [@ui.displayLink id="exportPlan:${plan.key}"
        titleKey=labelKey
        href=exportPlanUrl
        icon="file-code"
        useIconFont=true
        inList=true
        extraAttributes={
            "target": "_blank",
            "data-bamboo-analytics-event": '{"name": "bamboo.export.yaml.view.chain"}'?html
        }
        /]
    [/#if]
[/#macro]

[#macro displayPlanSpecsLink plan labelKey]
    [#if fn.hasPlanPermission('WRITE', plan)]
        [@s.url var='exportPlanUrl' action="plan" namespace="/exportSpecs" buildKey="${plan.key}" /]
        [@ui.displayLink id="exportPlanSpecs:${plan.key}"
        titleKey=labelKey
        href=exportPlanUrl
        icon="file-code"
        useIconFont=true
        inList=true
        extraAttributes={
        "target": "_blank",
        "data-bamboo-analytics-event": '{"name": "bamboo.export.specs.view.chain"}'?html
        }
        /]
    [/#if]
[/#macro]

[#macro displayCreateNewIssue plan labelKey]
    [#if user?has_content]
        [#if !planResultKey?has_content][#assign planResultKey="${plan.key}-${buildNumber}" /][/#if]

        [#if JiraApplicationLinkDefined]
            [@ww.url var="editCreateNewJiraIssueForBuildResult" action="editCreateNewJiraIssueForBuildResult" namespace="/ajax" planResultKey=planResultKey returnUrl=currentUrl appLinkId=createIssueAppLinkId /]
            [@dj.simpleDialogForm triggerSelector="#editCreateNewJiraIssueForBuildResult"
            width=680
            height=520
            headerKey="buildResult.create.issue.title"
            submitCallback="BAMBOO.JIRAISSUECREATION.returnFromDialog" /]

            [@ui.displayLinkForAUIDialog id="editCreateNewJiraIssueForBuildResult"
            titleKey=labelKey
            icon="jiraissue-new"
            inList=true
            href=editCreateNewJiraIssueForBuildResult/]

            [#if createIssueAppLinkId?has_content]
            <script type="text/javascript">
                BAMBOO.FORCEJIRAISSUECREATIONPOPUP = (function ($) {
                    return {
                        init: function (options) {
                            $("#editCreateNewJiraIssueForBuildResult").click();
                        }
                    };
                })(jQuery);
                BAMBOO.FORCEJIRAISSUECREATIONPOPUP.init();
            </script>
            [/#if]
        [#else]
            [@ui.displayLinkForAUIDialog id="editCreateNewJiraIssueNoApplinks"
            titleKey=labelKey
            icon="jiraissue-new"
            inList=true/]

        <script type="text/x-template" title="create-no-applinks">[#rt/]
            <div class="create-issue-teaser">
                <p>[@ww.text name="buildResult.create.issue.noAppLinks" /]</p>

                <div><img src="${req.contextPath}/images/createIssueTeaser.png"/></div>
                [#if !fn.hasAdminPermission()]
                    <p>[@ww.text name="buildResult.create.issue.noApplinks.notAdmin" /]</p>
                [/#if]
            </div>
        </script>[#lt/]

        <script>
            BAMBOO.JIRAISSUECREATION.NOAPPLINK.init({
                trigger: "#editCreateNewJiraIssueNoApplinks",
                contentTemplate: "create-no-applinks",
                appLinksAdminUrl: "[@ww.url value='/plugins/servlet/applinks/listApplicationLinks'/]",
                admin: ${fn.hasAdminPermission()?string},
                i18n: {
                    header: "[@ww.text name='buildResult.create.issue.title'/]",
                    cancel: "[@ww.text name='global.buttons.cancel'/]",
                    connect: "[@ww.text name='buildResult.create.issue.noAppLinks.connect'/]"
                }
            });
        </script>
        [/#if]

    <script type="text/javascript">
        AJS.whenIType("[@ww.text name='buildResult.create.new.issue.keyboardshortcut'/]").click("#editCreateNewJiraIssue");
    </script>
    [/#if]
[/#macro]

[#macro displayAddPlanLabelLink plan labelKey withShortcut=true]
    [#if user?has_content && fn.hasPlanPermission('WRITE', plan)]
        [@ww.url var="editLabelUrl" action='editLabels' namespace='/build/label/ajax']
            [@ww.param name='buildKey']${plan.key}[/@ww.param]
        [/@ww.url]
        [@ui.displayLinkForAUIDialog
        id="addPlanLabel"
        href=editLabelUrl
        titleKey=labelKey
        icon="devtools-tag"
        useIconFont=true
        inList=true/]
        <script type="text/javascript">
            new BAMBOO.LABELS.LabelDialog({
                trigger: "#addPlanLabel",
                labelView: "#planLabel .label-list, #planLabel .label-none, #planLabelDialog .label-list, #planLabelDialog .label-none",
                labelsDialog: {
                    id: "planLabelDialog",
                    header: "[@ww.text name='plan.labels.title' /]",[#if !withShortcut]
                        shortcutKey: null[/#if]
                },
                removeUrl: '${req.contextPath}/build/label/ajax/deleteLabel.action?buildKey=${plan.key}'
            });
        </script>
    [/#if]
[/#macro]

[#macro displayResultDeleteLink resultsSummary labelKey]
    [#if fn.hasPlanPermission('WRITE', resultsSummary.immutablePlan)]
        [@ww.url var='deleteResultUrl' namespace='/build/admin' action='deletePlanResults'
        buildKey='${resultsSummary.planKey}'
        buildNumber='${resultsSummary.buildNumber}'/]
        [@ui.displayLink id="deleteBuildResult_${resultsSummary.planResultKey}"
        titleKey=labelKey
        href=deleteResultUrl
        icon="remove"
        useIconFont=true
        inList=true
        mutative=true
        requiresConfirmation=true /]
    [/#if]
[/#macro]

[#macro displayWebItems plan location ]
    [#list action.getWebSectionsForLocation(location) as section ]
        [#list action.getWebItemsForSection(location + '/' + section.key) as item]
            [#if item.link.id?has_content]
                [#assign linkId = item.link.id /]
            [#elseif item.key?has_content]
                [#assign linkId = item.key /]
            [/#if]
            [@ui.displayLink id="${linkId!}"
            titleKey="${item.webLabel.displayableLabel}"
            href="${item.link.getDisplayableUrl(req, webFragmentsContextMap)}"
            iconPath="${(item.icon.url.getDisplayableUrl(req, webFragmentsContextMap))!}"
            inList=true /]
        [/#list]
    [/#list]
[/#macro]

[#macro displayFavouriteToggler plan]
    [#if user?has_content && plan.type != 'JOB']
        [#assign planI18nPrefix = fn.getPlanI18nKeyPrefix(plan)/]
        [#assign isFavourite = ctx.isFavourite(plan, req)/]
        [@ww.url var='setFavouriteUrl' action='setFavourite' namespace='/build/label' planKey='${plan.key}' newFavStatus='${(!isFavourite)?string}'  returnUrl=currentUrl/]
        [#if isFavourite ]
            [#assign favIcon='star'/]
            [#assign labelKey=planI18nPrefix+'.favourite.off'/]
        [#else]
            [#assign favIcon='unstar'/]
            [#assign labelKey=planI18nPrefix+'.favourite.on'/]
        [/#if]
        [@ui.displayLink id="toggleFavourite_${plan.key}"
        titleKey=labelKey
        href=setFavouriteUrl
        icon=favIcon
        useIconFont=true
        inList=true mutative=true /]
    [/#if]
[/#macro]

[#macro displayCustomisedRunStageLink resultsSummary]
    [#if !ctx.storageCappingService.hardLimitExceeded]
        [#if fn.hasPlanPermission("BUILD", resultsSummary.immutablePlan)]
            [#if !resultsSummary.immutablePlan.suspendedFromBuilding && resultsSummary.continuable!false]
                [#if isUnderMaxConcurrentBuilds(resultsSummary.immutablePlan)]
                    [#if stageToContinue??]
                        [@s.text var="customisedButtonLabel" name="chain.continue.parameterised.build"]
                            [@s.param]${stageToContinue.name}[/@s.param]
                        [/@s.text]

                        [@s.url var="editParameterisedManualBuild" action="editParameterisedManualBuild" namespace="/ajax" planKey=resultsSummary.planResultKey.planKey buildNumber=resultsSummary.planResultKey.buildNumber stageToContinue=stageToContinue.name returnUrl=currentUrl /]

                        [@ui.displayLinkForAUIDialog id="parameterisedManualBuild_${resultsSummary.planResultKey}"
                            title=customisedButtonLabel
                            showTitle=true
                            inList=true
                            href=editParameterisedManualBuild
                            cssClass="run-custom-stage"/]
                    [/#if]
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayRerunFailedJobsLink resultsSummary]
    [#if !ctx.storageCappingService.hardLimitExceeded]
        [#if fn.hasPlanPermission('BUILD', resultsSummary.immutablePlan)]
            [#if !resultsSummary.immutablePlan.suspendedFromBuilding && action.isRestartable(resultsSummary)!false]
                [#if isUnderMaxConcurrentBuilds(resultsSummary.immutablePlan)]
                    [@ww.url var='restartPlanUrl' action="restartBuild" namespace="/build/admin" planKey=resultsSummary.planResultKey.planKey buildNumber=resultsSummary.planResultKey.buildNumber /]
                    [#if resultsSummary.failed]
                        [#assign buttonLabel = "chain.restart.build.button" /]
                    [#else]
                        [#assign buttonLabel = "chain.restart.build.button.incomplete" /]
                    [/#if]
                    [@ui.displayLink id="restartBuild_${resultsSummary.planResultKey}" titleKey=buttonLabel href=restartPlanUrl showIcon=false inList=true mutative=true/]
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayRerunThisBuildLink resultsSummary]
    [#if !ctx.storageCappingService.hardLimitExceeded]
        [#if fn.hasPlanPermission('BUILD', resultsSummary.immutablePlan)]
            [#if !resultsSummary.immutablePlan.suspendedFromBuilding && !resultsSummary.failed && (resultsSummary.finished || resultsSummary.notBuilt)]
                [#if isUnderMaxConcurrentBuilds(resultsSummary.immutablePlan)]
                    [@ww.url var="editRerunBuild" action="editRerunBuild" namespace="/ajax" planKey=resultsSummary.planResultKey.planKey buildNumber=resultsSummary.planResultKey.buildNumber returnUrl=currentUrl /]
                    [@dj.simpleDialogForm triggerSelector="#rerunBuild_${immutablePlan.key}"
                    width=400
                    height=330
                    headerKey="rerunBuild.form.title"
                    submitCallback="redirectAfterReturningFromDialog"/]
                    [@ui.displayLinkForAUIDialog id="rerunBuild_${immutablePlan.key}"
                    titleKey="chain.restart.build.button.rerun"
                    inList=true
                    href=editRerunBuild/]
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayChainRunMenu plan]
    [#if resultsSummary??]
        [#assign result=(resultsSummary.chainResultsSummary)!resultsSummary /]
        [#if result??]
            [#assign stageLevelRunMenuItems]
                [@displayCustomisedRunStageLink resultsSummary=(resultsSummary.chainResultsSummary)!resultsSummary /]
            [/#assign]
            [#assign buildLevelRunMenuItems]
                [@displayRerunFailedJobsLink resultsSummary=(resultsSummary.chainResultsSummary)!resultsSummary /]
                [@displayRerunThisBuildLink resultsSummary=(resultsSummary.chainResultsSummary)!resultsSummary /]
            [/#assign]
        [/#if]
    [/#if]
    [#assign planLevelRunMenuItems]
        [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(plan)/]
        [@displayManualStartLink plan=plan labelKey='${planI18nPrefix}.run.menuitem' /]
        [@displayParametrisedManualStartLink plan=plan labelKey="${planI18nPrefix}.run.parameterised" /]
    [/#assign]

    [@ww.text var="runTriggerText" name="chain.run"/]
    [#if planLevelRunMenuItems?has_content || buildLevelRunMenuItems?has_content || stageLevelRunMenuItems?has_content]
        [@ui.groupedMenu triggerText=runTriggerText id="runMenuParent" icon="build-run" cssClass="aui-dropdown2-in-page-header"]
            [#if stageLevelRunMenuItems?has_content]
                [@displayAUIDropdown2Section]${stageLevelRunMenuItems}[/@displayAUIDropdown2Section]
            [/#if]
            [#if buildLevelRunMenuItems?has_content]
                [@displayAUIDropdown2Section]${buildLevelRunMenuItems}[/@displayAUIDropdown2Section]
            [/#if]
            [#if planLevelRunMenuItems?has_content]
                [@displayAUIDropdown2Section]${planLevelRunMenuItems}[/@displayAUIDropdown2Section]
            [/#if]
        [/@ui.groupedMenu]
    [#elseif fn.hasPlanPermission('BUILD', plan)]
        [#local triggerId = "runMenuParentDisabled" /]
        [@ui.groupedMenu triggerText=runTriggerText id="runMenuParent" icon="build-run-disabled" triggerId=triggerId disabled=true cssClass="aui-dropdown2-in-page-header" /]
        [#assign chainRunDisabledText]
            [#if plan.suspendedFromBuilding]
                [@ww.text name="chain.run.disabled.suspended" /]
            [#elseif !isUnderMaxConcurrentBuilds(plan)]
                [@ww.text name="chain.run.disabled.concurrentLimit" /]
            [#elseif ctx.storageCappingService.hardLimitExceeded]
                [@ww.text name="chain.run.disabled.storageQuotaExceeded" /]
            [/#if]
        [/#assign]
        <script>
            (function ($) {
                var triggerSelector = '#${triggerId}';
                var inlineDialog = AJS.InlineDialog(triggerSelector, 'build-run-disabled', function (contents, trigger, doShowPopup) {
                    contents.text('${chainRunDisabledText?trim?js_string}');
                    doShowPopup();
                }, {
                    useLiveEvents: true,
                    noBind: true,
                    addActiveClass: false
                });
                $(document).on('mouseenter', triggerSelector, function () {
                    if (!inlineDialog.is(':visible')) {
                        inlineDialog.show();
                    }
                }).on('mouseleave', triggerSelector, function () {
                    if (inlineDialog.is(':visible')) {
                        inlineDialog.hide();
                    }
                });
            }(jQuery));
        </script>
    [/#if]
[/#macro]

[#function isUnderMaxConcurrentBuilds plan]
    [#return action.getNumberOfCurrentlyBuildingPlans(plan.planKey.key) < plan.buildDefinition.configObjects.get("custom.concurrentBuilds.planLevelConfig").effectiveNumberOfConcurrentBuilds /]
[/#function]


