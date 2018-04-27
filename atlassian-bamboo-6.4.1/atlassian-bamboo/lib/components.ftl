[#-- @ftlvariable name="ctx" type="com.atlassian.bamboo.ww2.FreemarkerContext" --]
[#-- @ftlvariable name="buildResultsSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]

[#-- ========================================================================================= @cp.displayJiraIssuesSummary --]
[#-- Displays a summary of JIRA Issues. --]
[#macro displayJiraIssuesSummary buildResultsSummary maxIssues=5 ]
    [#import '../plugins/jira-plugin/viewJiraIssueComponents.ftl' as jiraComponents /]

    [#if jiraApplicationLinkDefined!false]
        [@jiraComponents.jiraIssueSummaryHolder resultsSummary=buildResultsSummary maxIssues=maxIssues/]
    [#else]
        [@jiraComponents.jiraMissingApplinkInfo /]
    [/#if]
[/#macro]

[#-- ================================================================================ @cp.oAuthAuthenticationRequest --]

[#macro oauthAuthenticationRequest authenticationUrl authenticationInstanceName='']
    [#if !authenticationInstanceName?has_content]
        [#assign jiraName][@ww.text name="jira.title"/][/#assign]
    [#else]
        [#assign jiraName]${authenticationInstanceName}[/#assign]
    [/#if]

    [@ui.messageBox type="info"]
    <p>[@ww.text name="oauth.authentication.request.explanation"][@ww.param]${jiraName}[/@ww.param][/@ww.text]</p>
    <a class="oauth-approve" href="${authenticationUrl}">[@ww.text name="oauth.authentication.title"/]</a>
    [/@ui.messageBox]
[/#macro]


[#-- ================================================================================== @cp.displayAuthorSummary --]

[#macro displayAuthorSummary author]
    [@ui.bambooInfoDisplay title='Builds triggered by ${author.name?html}' height='300px' cssClass='authorSummary']
        [@ui.displayText]
        Builds triggered by an author are those builds which contains changes committed by the author.
        [/@ui.displayText]

        [@ww.label labelKey='author.summary.all.builds.triggered' name='author.numberOfTriggeredBuilds'/]

        [#if author.numberOfTriggeredBuilds gt 0]
            [#assign failedPercent=author.numberOfFailedBuilds / author.numberOfTriggeredBuilds]
            [#assign successPercent=author.numberOfSuccessfulBuilds / author.numberOfTriggeredBuilds]
        [#else]
            [#assign failedPercent=0 /]
            [#assign successPercent=0 /]
        [/#if]

        [@ww.label labelKey='build.common.fail' value='${author.numberOfFailedBuilds} (${failedPercent?string.percent})' /]
        [@ww.label labelKey='build.common.successful' value='${author.numberOfSuccessfulBuilds} (${successPercent?string.percent}) ' /]
    [/@ui.bambooInfoDisplay]
    [@ui.bambooInfoDisplay titleKey='author.summary.breakages.and.fixes' height='300px' cssClass='authorSummary']
        [@ui.displayText]
        <i>Broken</i> means the build has failed but the previous build was successful.<br/>
        <i>Fixed</i> means that the build was successful but the previous build has failed.
        [/@ui.displayText]

        [#if author.numberOfTriggeredBuilds gt 0]
            [#assign breakagePercent=author.numberOfBreakages / author.numberOfTriggeredBuilds]
            [#assign fixesPercent=author.numberOfFixes / author.numberOfTriggeredBuilds]
        [#else]
            [#assign breakagePercent=0 /]
            [#assign fixesPercent=0 /]
        [/#if]


        [@ww.label labelKey='author.summary.broken.by.author']
            [@ww.param name='value' ]
                [@ww.text name='author.summary.of.all.builds.triggered']
                    [@ww.param]${author.numberOfBreakages}[/@ww.param]
                    [@ww.param]${breakagePercent?string.percent}[/@ww.param]
                [/@ww.text]
            [/@ww.param]
        [/@ww.label]
        [@ww.label labelKey='author.summary.fixed.by.author']
            [@ww.param name='value' ]
                [@ww.text name='author.summary.of.all.builds.triggered']
                    [@ww.param]${author.numberOfFixes}[/@ww.param]
                    [@ww.param]${fixesPercent?string.percent}[/@ww.param]
                [/@ww.text]
            [/@ww.param]
        [/@ww.label]

        [#assign difference=author.numberOfFixes - author.numberOfBreakages /]

        [#if difference > 0]
            [#assign textColour='Successful' /]
        [#else]
            [#assign textColour='Failed' /]
        [/#if]
        [@ww.label labelKey='author.summary.difference.of.fixes.and.breaks' name='author.numberOfFixes - author.numberOfBreakages' cssClass='${textColour}' /]
    [/@ui.bambooInfoDisplay]
<div class="clearer"></div>
[/#macro]

[#-- ================================================================================ @cp.displayAuthorOrProfileLink --]

[#macro displayAuthorOrProfileLink author]
    [@compress singleLine=true]
        [#if author.linkedUserName?has_content]
            [@s.url action='viewUserSummary' namespace='/users']
                [@s.param name='currentUserName' value=author.linkedUserName /]
            [/@s.url]
        [#else]
            [@s.url action='viewAuthor' namespace='/authors']
                [@s.param name='authorName' value=author.name /]
            [/@s.url]
        [/#if]
    [/@compress]
[/#macro]

[#-- ================================================================================ @cp.displayNotificationWarnings --]
[#macro displayNotificationWarnings messageKey='' addServerKey='' cssClass='info'  allowInlineEdit=false id='' hidden=false]
    [#if allowInlineEdit]
        [@dj.simpleDialogForm
        triggerSelector=".addInstantMessagingServerInline"
        actionUrl="/ajax/configureInstantMessagingServerInline.action?returnUrl=${currentUrl?url}"
        width=800
        height=415
        submitLabelKey="global.buttons.update"
        submitMode="ajax"
        submitCallback="function() {window.location.reload();}"
        /]
        [@dj.simpleDialogForm
        triggerSelector=".addMailServerInline"
        actionUrl="/ajax/configureMailServerInline.action?returnUrl=${currentUrl?url}"
        width=860
        height=540
        submitLabelKey="global.buttons.update"
        submitMode="ajax"
        submitCallback="function() {window.location.reload();}"
        /]
    [/#if]
    [#if messageKey?has_content]
        [#assign notificationWarningMsg][#rt]
            [@ww.text name=messageKey]
                [@ww.param name="value"]<a href="${req.contextPath}/profile/userProfile.action">[/@ww.param]
                [@ww.param name="value"]</a>[/@ww.param]
            [/@ww.text][#t]
            [#if fn.hasAdminPermission()][#lt]<br/> <span>[#rt]
                [@ww.text name=addServerKey]
                    [@ww.param name="value"]
                    <a id="addMailServerInline" class="addMailServerInline" title="${action.getText('config.email.title')}">[/@ww.param]
                    [@ww.param name="value"]
                    <a id="addInstantMessagingServerInline" class="addInstantMessagingServerInline" title="${action.getText('instantMessagingServer.admin.add')}">[/@ww.param]
                    [@ww.param name="value"]</a>[/@ww.param]
                [/@ww.text]</span>[#t]
            [/#if]
        [/#assign][#lt]
        [@ui.messageBox type=cssClass id=id hidden=hidden]${notificationWarningMsg}[/@ui.messageBox]
    [/#if]
[/#macro]

[#-- ============================================================================================= @cp.favouriteIcon --]
[#macro favouriteIcon plan operationsReturnUrl user='']
    [#if user?has_content && plan.type != 'JOB']
        [@compress single_line=true]

            [#assign isFavourite = action.isFavourite(plan)]
            [@ww.url var='setFavouriteUrl'
            action='setFavourite'
            namespace='/build/label'
            planKey='${plan.key}'
            newFavStatus='${(!isFavourite)?string}'
            returnUrl='${operationsReturnUrl}' /]
            [#if isFavourite ]
            <a href="${setFavouriteUrl}" class="internalLink mutative" id="toggleFavourite_${plan.key}">[@ui.icon useIconFont=true type="star" text="Remove this plan from your favourites" /]</a>
            [#else]
            <a href="${setFavouriteUrl}" class="internalLink mutative" id="toggleFavourite_${plan.key}">[@ui.icon useIconFont=true type="unstar" text="Add this plan to your favourites" /]</a>
            [/#if]

        [/@compress]
    [/#if]
[/#macro]

[#-- ============================================================================================= @cp.dashboardFavouriteIcon --]
[#macro dashboardFavouriteIcon plan operationsReturnUrl user='']
    [#if user?has_content]
        [@compress single_line=true]
            [#assign isFavourite = action.isFavourite(plan)]
            [@ww.url var='setFavouriteUrl'
            action='setFavourite'
            namespace='/build/label'
            planKey='${plan.key}'
            newFavStatus='${(!isFavourite)?string}'
            returnUrl='${operationsReturnUrl}' /]

            [#assign planI18nPrefix = fn.getPlanI18nKeyPrefix(plan)/]
            [#if isFavourite]
            [#--this is counter intuitive but "star" and "unstar" is action in AUI while we're showing state--]
            <a class="unmarkBuildFavourite usePostMethod" id="toggleFavourite_${plan.key}" href="${setFavouriteUrl}" data-plan-key="${plan.key}" title="[@ww.text name=planI18nPrefix+'.favourite.off'/]">[@ui.icon useIconFont=true type="star" textKey=planI18nPrefix+'.favourite.off'/]</a>
            [#else]
            <a class="markBuildFavourite usePostMethod" id="toggleFavourite_${plan.key}" href="${setFavouriteUrl}" data-plan-key="${plan.key}" title="[@ww.text name=planI18nPrefix+'.favourite.on'/]">[@ui.icon useIconFont=true type="unstar" textKey=planI18nPrefix+'.favourite.on'/]</a>
            [/#if]

        [/@compress]
    [/#if]
[/#macro]

[#-- ==================================================================================== @cp.currentBuildStatusIcon --]
[#macro currentBuildStatusIcon build id='' classes='' showLink=true]
    [@compress single_line=true]
        [#if showLink]
                <a [#if id?has_content]
                id="${id}" [#t]
        [/#if]
            [#if classes?has_content]
                    class="${classes}" [#t]
            [#elseif build.active]
                    class="${build.key}_active" [#t]
            [/#if]
            [#assign lastResult=build.lastResultKey!]
            [#if lastResult?has_content]
                    href="${req.contextPath}/browse/${lastResult.key}">[#t/]
            [#else]
                href="${req.contextPath}/browse/${build.key}">[#t/]
            [/#if]
        [/#if]
        [#assign latestResultsSummary=build.latestResultsSummary! /]

        [#if build.suspendedFromBuilding]
            ${soy.render("widget.icons.statusIcon", {
                "status":  "task-disabled",
                "text": "Plan Disabled"
            })}
        [#elseif build.active && build.isExecuting()]
            ${soy.render("widget.icons.statusIcon", {
                "status":  "building",
                "text": "Build in progress"
            })}
        [#elseif build.active]
            ${soy.render("widget.icons.statusIcon", {
                "status":  "task-in-progress",
                "text": "Build queued"
            })}
        [#elseif build.isBusy?? && build.isBusy()]
            ${soy.render("widget.icons.statusIcon", {
                "status":  "sync",
                "text": "Checking out source code"
            })}
        [#elseif latestResultsSummary?has_content ]
            [#if latestResultsSummary.continuable]
                ${soy.render("widget.icons.statusIcon", {
                    "status":  "successfulpartial",
                    "text": "Last build stopped at manual stage"
                })}
            [#elseif latestResultsSummary.successful]
                [#if fn.isSpecsSuccess(latestResultsSummary)]
                    ${soy.render("widget.icons.statusIcon", {
                        "status":  "specs-success",
                        "text": "Specs execution was successful"
                    })}
                [#else]
                    ${soy.render("widget.icons.statusIcon", {
                        "status":  "approve",
                        "text": "Last build was successful"
                    })}
                [/#if]
            [#elseif latestResultsSummary.failed]
                [#if fn.isSpecsFailure(latestResultsSummary)]
                    ${soy.render("widget.icons.statusIcon", {
                        "status":  "specs-failure",
                        "text": "Specs execution failed"
                    })}
                [#else]
                    ${soy.render("widget.icons.statusIcon", {
                        "status":  "error",
                        "text": "The last build was not built"
                    })}
                [/#if]
            [#elseif latestResultsSummary.notBuilt]
                ${soy.render("widget.icons.statusIcon", {
                    "status":  "task-cancelled",
                    "text": "The last build was not built"
                })}
            [/#if]
        [#else]
            ${soy.render("widget.icons.statusIcon", {
                "status":  "task-disabled",
                "text": "No build history"
            })}
        [/#if]
        [#if showLink]
        </a>[#t/]
        [/#if]
    [/@compress]
[/#macro]

[#-- ============================================================================================ @cp.resultsSubMenu --]
[#macro resultsSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ============================================================================================ @cp.resultsSubMenu --]
[#macro buildResultSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ============================================================================================ @cp.chainResultsSubMenu --]
[#macro chainResultSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.buildSubMenu --]
[#macro buildSubMenu selectedTab='summary']
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]plan[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.chainSubMenu --]
[#macro chainSubMenu selectedTab='summary']
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]plan[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.editPlanConfigurationTabs --]
[#macro editPlanConfigurationTabs build formId selectedTab='build.details' location="planConfiguration.subMenu"]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]planConfig[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]

[#-- ========================================================================-===================== @cp.profileSubMenu --]
[#macro profileSubMenu selectedTab='personalDetails']
    [#import "menus.ftl" as menu/]
    [@menu.displayTabbedContent location="system.user" selectedTab=selectedTab admin=true]
        [#nested /]
    [/@menu.displayTabbedContent]
[/#macro]

[#-- ================================================================================================ @cp.pagination --]
[#macro pagination ]
<ul class="pager">
    [#if pager.hasPreviousPage]
        <li>
            <a href="${req.contextPath}${pager.firstPageUrl}" class="firstLink" title="First"></a>
        </li>
        <li>
            <a href="${req.contextPath}${pager.previousPageUrl}" class="previousLink" accesskey="P" title="Previous"></a>
        </li>
    [#else]
        <li><span class="firstLink"></span></li>
        <li><span class="previousLink"></span></li>
    [/#if]
    <li class="label">Showing ${pager.page.startIndex + 1}-${pager.page.endIndex} of ${pager.totalSize}</li>
    [#if pager.hasNextPage]
        <li>
            <a href="${req.contextPath}${pager.nextPageUrl}" class="nextLink" accesskey="N" title="Next"></a>
        </li>
        <li>
            <a href="${req.contextPath}${pager.lastPageUrl}" class="lastLink" title="Last"></a>
        </li>
    [#else]
        <li><span class="nextLink"></span></li>
        <li><span class="lastLink"></span></li>
    [/#if]
</ul>
[/#macro]

[#-- ========================================================================-===================== @cp.commentIndicatorAsText --]
[#--used for jira bamboo plugin--]
[#macro commentIndicatorAsText buildResultsSummary]
    [#if buildResultsSummary.comments?has_content]
        [@ww.url var='commentUrl'  value="/browse/${buildResultsSummary.planResultKey}" /]

    <a id="comment:${buildResultsSummary.planResultKey}" href="${commentUrl}">
        [@ww.text name='buildResult.comment.count' ]
                [@ww.param name="value" value="${buildResultsSummary.comments.size()}"/]
            [/@ww.text]
    </a>
    [/#if]
[/#macro]

[#-- ========================================================================================== @cp.commentIndicator --]
[#macro commentIndicator resultsSummary]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ImmutableResultsSummary" --]
    [#if ctx.hasComments(resultsSummary)]
        [@s.url var='commentUrl'  value="/browse/${resultsSummary.planResultKey}" /]

        [#assign commentId = "comment_${resultsSummary.planResultKey}" /]
        <a id="${commentId}" href="${commentUrl}">[@ui.icon type="comment" useIconFont=true text="Commented" /]</a>
        <script type="text/javascript">
            AJS.$(function () {
                initCommentTooltip("${commentId}", "${resultsSummary.planKey}", "${resultsSummary.buildNumber}")
            });
        </script>
    [/#if]
[/#macro]


[#-- ======================================================================================== @cp.getStaticResourcePrefix --]
[#macro getStaticResourcePrefix]
${staticResourcePrefix!req.contextPath}[#t]
[/#macro]

[#-- ======================================================================================== @cp.toggleDisplayByGroup --]
[#macro toggleDisplayByGroup toggleGroup_id jsRestore=true]
<script type="text/javascript">
    AJS.$("#${toggleGroup_id}_toggler_on").bind("click", function ()
    {
        toggleOff(null, '${toggleGroup_id}');
    });
    AJS.$("#${toggleGroup_id}_toggler_off").bind("click", function ()
    {
        toggleOn(null, '${toggleGroup_id}');
    });

        [#if jsRestore]
        AJS.$("#${toggleGroup_id}_target").ready(function ()
                                                 {
                                                     restoreTogglesFromCookie('${toggleGroup_id}');
                                                 });
        [/#if]
</script>
[/#macro]


[#-- ======================================================================================== @cp.entityPagination --]
[#--
    Shows pagination links for Users and Group browsers.

    @requires actionUrl - the url to post back to for the page numbers
    @requires paginagionSupport - paginationSupport object
--]

[#macro entityPagination actionUrl paginationSupport ]
[#-- @ftlvariable name="paginationSupport" type="bucket.core.actions.PagerPaginationSupport" --]
    [#assign sanitizedActionUrl=fn.sanitizeUri(actionUrl)/]

    [#assign previousIndexes=paginationSupport.previousStartIndexes! /]
    [#assign nextIndexes=paginationSupport.getNextStartIndexes()! /]
    [#if paginationSupport.items?has_content]
        [#assign startIndex=paginationSupport.startIndex + 1 /]
        [#assign endIndex=paginationSupport.endIndex /]
    [/#if]
    [#assign currentPageNumber=1]
    [#assign pageLimit=5]

<div>
    <ul class="pager">
        [#if previousIndexes?has_content]
            <li>
                <a href="${sanitizedActionUrl}startIndex=${paginationSupport.previousIndex}" class="previousLink" title="Previous">Previous</a>
            </li>

            [#if previousIndexes?size > pageLimit]
                <li>&hellip;</li>
            [/#if]

            [#assign currentPageNumber = currentPageNumber + previousIndexes?size /]
            [#assign previousIndexesShort = previousIndexes?reverse?chunk(pageLimit)?first?reverse /]
            [#list previousIndexesShort as pageIndex]
                [#assign pageNumber = currentPageNumber - previousIndexesShort?size + pageIndex?index /]
                <li>
                    <a href="${sanitizedActionUrl}startIndex=${pageIndex}" class="numberedLink">${pageNumber}</a>
                </li>
            [/#list]
        [#else ]
            <li><span class="previousLink"></span></li>
        [/#if]

        <li><span class="numberedLink">${currentPageNumber}</span></li>

        [#if nextIndexes?has_content]
            [#assign nextIndexesShort = nextIndexes?chunk(pageLimit)?first /]
            [#list nextIndexesShort as pageIndex]
                [#assign pageNumber = currentPageNumber + pageIndex?index + 1 /]
                <li>
                    <a href="${sanitizedActionUrl}startIndex=${pageIndex}" class="numberedLink">${pageNumber}</a>
                </li>
            [/#list]

            [#if nextIndexes?size > pageLimit]
                <li>&hellip;</li>
            [/#if]
            <li>
                <a href="${sanitizedActionUrl}startIndex=${paginationSupport.nextIndex}" class="nextLink" title="Next">Next</a>
            </li>
        [#else ]
            <li><span class="nextLink"></span></li>
        [/#if]
    </ul>
</div>
[/#macro]

[#-- =========================================================================================== @cp.displayErrorsForPlan --]
[#macro displayErrorsForPlan plan errorAccessor]
    [#assign buildErrors=errorAccessor.getErrors(plan.planKey)]
    [@displayErrors buildErrors plan.key /]
[/#macro]

[#macro displayErrorsForResult planResult errorAccessor manualReturnUrl=""]
    [#assign buildErrors=errorAccessor.getErrors(planResult.planResultKey)]
    [@displayErrors buildErrors planResult.planResultKey.planKey.key planResult.planResultKey.buildNumber manualReturnUrl/]
[/#macro]

[#macro displayErrors buildErrors planKey="" buildNumber="" manualReturnUrl=""]
    [#if buildErrors?has_content]
    <div id="plan-errors">
        [#if fn.hasAdminPermission()]
            <div class="floating-toolbar">
                <a class="aui-button mutative" href="[@ww.url value='/chain/removePlanErrorsFromLog.action?' errorKey=planKey buildNumber=buildNumber returnUrl=currentUrl /]">[@ww.text name="plan.error.bulk.delete"/]</a>
            </div>
        [/#if]
        <h2 id="buildPlanSummaryErrorLog">[@ww.text name='plan.error.title'/]</h2>

        <ol>
            [#list buildErrors as error]
                [#if manualReturnUrl?has_content]
                    [@cp.showSystemError error=error returnUrl=manualReturnUrl webPanelLocation='chain.errors'/]
                [#else]
                    [@cp.showSystemError error=error returnUrl=currentUrl webPanelLocation='chain.errors'/]
                [/#if]
            [/#list]
        </ol>
    </div>
    [/#if]
[/#macro]

[#macro displayDeploymentErrors buildErrors deploymentResult manualReturnUrl=""]
    [#if buildErrors?has_content]
    <div id="deployment-errors">
        <h2 id="buildPlanSummaryErrorLog">[@ww.text name='plan.error.title'/]</h2>
        <ol>
            [#list buildErrors as error]
                [#if manualReturnUrl?has_content]
                    [@cp.showSystemError error=error returnUrl=manualReturnUrl deploymentResult=deploymentResult webPanelLocation='deployment.errors'/]
                [#else]
                    [@cp.showSystemError error=error returnUrl=currentUrl deploymentResult=deploymentResult webPanelLocation='deployment.errors'/]
                [/#if]
            [/#list]
        </ol>
    </div>
    [/#if]
[/#macro]

[#-- =========================================================================================== @cp.showSystemError --]
[#--
    Shows a @ui.messageBox showing the build errors

    @requires error - A DecoratedErrorDetailsImpl object.  Undecorated ErrorDetails objects will lead to errors
--]
[#macro showSystemError error webPanelLocation='general.errors' returnUrl='' deploymentResult='']
[#-- @ftlvariable name="error" type="com.atlassian.bamboo.logger.DecoratedErrorDetailsImpl" --]
    [@ui.messageBox type="warning" cssClass='system-error-message' closeable=fn.hasAdminPermission()]
    <p class="title">[#rt]
        [#if error.buildSpecific]
            [#if webPanelLocation != 'chain.errors' && !deploymentResult?has_content]
                <a href="[@ww.url value='/browse/${error.buildKey}' /]">${error.buildName}</a>
                [#if error.buildNumber?? && error.buildExists]
                    &rsaquo; <a href="[@ww.url value='/browse/${error.buildResultKey}' /]">${error.buildResultKey}</a>
                [/#if]
            : [#lt]
            [/#if]
        [#elseif error.elastic]
            Elastic Bamboo Error : [#lt]
        [#else]
            General Error : [#lt]
        [/#if]
        ${htmlUtils.getTextAsHtml(error.context)}[#lt]
    </p>

    [@ui.renderWebPanels location=webPanelLocation params={"error": error}/]

    [#if error.elastic]
        [#if error.instanceIds?has_content]
        <em>Elastic Instances : </em>
            [#list error.instanceIds as instanceId]
            ${instanceId?html}[#t]
                [#if instanceId_has_next]
                ,[#lt]
                [/#if]
            [/#list]
        [/#if]
    [/#if]

    <div>
        (${error.lastOccurred?datetime}[#rt]
        [#if error.numberOfOccurrences > 1]
            , Occurrences: ${error.numberOfOccurrences}[#lt][#rt]
        [/#if]
        [#if error.agentIds?has_content]
            , Agents: [#lt]
            [#list error.agentIdentifiers as agent]
                [#if agent.name?has_content]
                    <a href="[@ww.url action='viewAgent' namespace='/agent' agentId=agent.id /]">${agent.name?html}</a>[#t]
                [#else]
                    id: ${agent.id}
                [/#if]
                [#if agent_has_next]
                    ,[#lt]
                [/#if]
            [/#list]
        [/#if]
        )[#lt]
    </div>
    [#if error.throwableDetails??]
        <div class="footer">
            [@ww.url var='viewErrorUrl' value='/admin/viewError.action'
                buildKey=error.buildKey
                error=error.errorNumber
            /]
            <a href="${viewErrorUrl}" rel="help" data-use-help-popup="true" id="viewPlanError_${error.errorNumber}">[@ww.text name="plan.error.view"/]</a>
        </div>
    [/#if]
    [#if fn.hasAdminPermission() ]
        [@s.url var='removeErrorFromLogUrl' namespace='/' action='removeErrorFromLog'
            errorKey=error.buildKey
            error=error.errorNumber
            returnUrl=removeErrorReturnUrl
        /]
        <a href="${removeErrorFromLogUrl}" class="system-error-message-remove mutative"></a>
    [/#if]
    [/@ui.messageBox]
[/#macro]

[#macro printAuditLogEntity auditLogMessage]
    [#if auditLogMessage.entityType??]${auditLogMessage.entityType}: [/#if]${auditLogMessage.entityHeader?html}[#t]
[/#macro]

[#-- =================================================================== @cp.configChangeHistory changeListPager --]
[#macro configChangeHistory pager showChangedEntityDetails=false jobMap=""]
[#-- @ftlvariable name="pager" type="com.atlassian.bamboo.filter.Pager" --]
    [#if pager.totalSize > 0]
    <div id="audit-log">
        <table id="audit-log-table" class="aui">
            <thead>
            <tr>
                <th id="al-timestamp">[@ww.text name='auditlog.timestamp' /]</th>
                <th id="al-user">[@ww.text name='auditlog.user' /]</th>
                [#if showChangedEntityDetails]
                    <th id="al-entity">[@ww.text name='auditlog.entity' /]</th>
                [/#if]
                <th id="al-change">[@ww.text name='auditlog.changed.field' /]</th>
                <th class="value-column" id="al-old-value">[@ww.text name='auditlog.old.value' /]</th>
                <th class="value-column" id="al-new-value">[@ww.text name='auditlog.new.value' /]</th>
            </tr>
            </thead>
            <tfoot>
            <tr>
                <td colspan="7">[@cp.pagination /]</td>
            </tr>
            </tfoot>
            <tbody>
                [#list pager.page.list as message]
                <tr>
                    <td headers="al-timestamp" style="white-space:nowrap;">${message.date?datetime?string("HH:mm, d MMM")}</td>
                    <td headers="al-user">
                        [#if message.username?? && message.username != "SYSTEM"]
                            <a href="[@ww.url value='/browse/user/${message.username}'/]">${message.username?html}</a>
                        [#else]
                            SYSTEM
                        [/#if]
                    </td>
                    [#if showChangedEntityDetails]
                        <td headers="al-entity">
                            [#if message.jobKey??]
                                <a href="${req.contextPath}/build/admin/edit/editBuildDetails.action?buildKey=${message.jobKey}">${jobMap.get(message.jobKey)}</a>
                                [#if message.entityHeader?has_content]
                                    <span class="audit-log-item-separator">&rsaquo;</span> [@printAuditLogEntity message/]
                                [/#if]
                            [#elseif message.entityHeader?has_content]
                                [@printAuditLogEntity message/]
                            [#else]
                                &nbsp;
                            [/#if]
                        </td>
                    [/#if]

                    [#if message.messageType == "FIELD_CHANGE"]
                        <td headers="al-change">${message.message!}</td>
                        <td class="value-column" headers="al-old-value">${(message.oldValue!)?html}</td>
                        <td class="value-column" headers="al-new-value">${(message.newValue!)?html}</td>
                    [#else]
                        <td headers="al-change" colspan="3">${message.message}</td>
                    [/#if]
                </tr>
                [/#list]
            </tbody>
        </table>
    </div>
    [#else]
    <p>[@ww.text name='auditlog.no.changes.recorded' /]</p>
    [/#if]

[/#macro]

[#-- ========================================================================================= @cp.startAgentCommand --]
[#macro startAgentCommand baseUrl systemProperties=""
            jarFile="atlassian-bamboo-agent-installer-${buildUtils.getCurrentVersion()}.jar" highlightJarFile=false
            securityTokenRequired=false securityToken="" highlightSecurityToken=false]
[@compress single_line=true]
    [#assign jarFileParam]${jarFile}[/#assign]
    [#if highlightJarFile]
        [#assign jarFileParam]<strong>${jarFileParam}</strong>[/#assign]
    [/#if]

    [#assign securityTokenParam=""/]
    [#if securityTokenRequired]
        [#assign securityTokenParam]-t ${securityToken}[/#assign]
        [#if highlightSecurityToken]
            [#assign securityTokenParam]<strong>${securityTokenParam}</strong>[/#assign]
        [/#if]
    [/#if]

    java ${systemProperties} -jar ${jarFileParam} ${baseUrl}/agentServer/ ${securityTokenParam}
[/@compress]
[/#macro]

[#macro successStatistics statistics averageDuration isJob]
<div id="successRate">
    <div class="successRatePercentage">
        <p>
            <span>${statistics.successPercentage}%</span>
            [@ww.text name='build.common.statSuccessful' /]
        </p>
    </div>
    <!-- END #successRatePercentage -->
    <dl>
        <dt>
            [#if isJob]
                [@ww.text name='build.common.successful' /]:
            [#else]
                [@ww.text name='chain.summary.graph.successfulBuilds' /]:
            [/#if]
        </dt>
        <dd>${statistics.totalSuccesses} / ${statistics.totalNumberOfResults}</dd>
        <dt>[@ww.text name='build.common.averageDuration' /]:</dt>
        <dd>${durationUtils.getPrettyPrint(averageDuration)}</dd>
    </dl>
</div> <!-- END #successRate -->
[/#macro]

[#macro buildStatistics statistics averageDuration hasResults]
<ul id="build-statistics">
    <li class="builds">
        <span class="value">${statistics.totalNumberOfResults}</span>
        <span class="key">[@ww.text name="build.statistics.builds" /]</span>
    </li>
    <li class="successful">
        <span class="value">${statistics.successPercentage}%</span>
        <span class="key">[@ww.text name="build.statistics.successful" /]</span>
        [#if hasResults]
            <figure id="build-success-chart" data-successful="${statistics.successPercentage}" data-failed="${(100-statistics.successPercentage)}"></figure>
        [/#if]
    </li>
    <li class="duration">
        <span class="value">${durationUtils.getPrettyPrint(averageDuration, PrettyLength.SHORT)}</span>
        <span class="key">[@ww.text name="build.statistics.averageDuration" /]</span>
        [#if hasResults]
            [@ww.action name="viewBuildNumberChart" namespace="/charts" executeResult="true" /]
        [/#if]
    </li>
</ul>
    [#if hasResults]
    <script type="text/javascript">
        BAMBOO.BuildStatistics.init();
    </script>
    [/#if]
[/#macro]

[#macro filterDropDown filterController isAgentFilter=false]
    [#if filterController??]
    <div id="filterButton" class="toolbar aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item aui-dd-parent">
                <a class="toolbar-trigger">
                    Showing
                    [#if isAgentFilter]
                    ${filterController.agentFilterName}
                    [#else]
                    ${filterController.selectedFilterName}
                    [/#if]
                    [@ui.icon type="drop" /]
                </a>
                <ul class="aui-dropdown aui-dropdown-right hidden">
                    [#list filterController.filterMap.keySet() as key]
                            [#if isAgentFilter]
                        [@ww.url var="filterUrl" action="setResultsFilter" namespace="/agent" returnUrl=currentUrl]
                            [@ww.param name="filterController.agentFilterKey"]${key}[/@ww.param]
                        [/@ww.url]
                    [#else]
                        [@ww.url var="filterUrl" action="setResultsFilter" namespace="/build" returnUrl=currentUrl buildKey="${immutablePlan.key}"]
                            [@ww.param name="filterController.selectedFilterKey"]${key}[/@ww.param]
                        [/@ww.url]
                    [/#if]
                            [@ui.displayLink id="filter:${key}"
                    title=filterController.filterMap[key]
                    href=filterUrl
                    inList=true /]
                        [/#list]
                </ul>
            </li>
        </ul>
    </div>
    <script type="text/javascript">
        AJS.$(function ()
              {
                  AJS.$("#filterButton .aui-dd-parent").dropDown("Standard", { trigger: "a.toolbar-trigger" });
              });
    </script>
    [/#if]
[/#macro]

[#macro displayCommentList result resultComments headingLevel='h3']
    [#assign commentList = [] /]
    [#list resultComments as comment]
        [#assign renderedComment][@ui.renderValidJiraIssues comment.content!'' result /][/#assign]
        [#assign userDisplayName][#if comment.user??][@ui.displayUserFullName user=comment.user /][/#if][/#assign]
        [#assign commentList = commentList + [{
        "id": comment.id,
        "comment": renderedComment,
        "lastModificationDate": comment.lastModificationDate?string("yyyy-MM-dd'T'HH:mm:ss"),
        "prettyLastModificationDate": durationUtils.getRelativeDate(comment.lastModificationDate),
        "avatar": ctx.getGravatarUrl((comment.user.name)!'', "32")!'',
        "user": comment.user!false,
        "userDisplayName": userDisplayName,
        "result": result
        }] /]
    [/#list]
    [#if featureManager.removingLabelsAndCommentsAllowedForNonPlanAdmin]
        [#if fn.hasPlanPermission('READ', result.immutablePlan)]
            [#local showOperations]true[/#local]
        [/#if]
    [#else]
        [#if fn.hasPlanPermission('WRITE', result.immutablePlan)]
            [#local showOperations]true[/#local]
        [/#if]
    [/#if]
${soy.render("bamboo.feature.comments.commentList", {
"comments": commentList,
"showOperations": showOperations??,
"headingLevel": headingLevel,
"showTopLevelHeading": (headingLevel == 'h3')
})}
[/#macro]

[#--Displays existing comments and button-triggered form to add a new comment.  Whilst it is a component, the delete links currently dont use the return url--]
[#macro displayComments result comments returnUrl showFormOnLoad=false]
[#-- @ftlvariable name="result" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
    [#if user?? || comments?has_content]
    <div class="comments" id="comments">
        [#if comments.get(result.id)?has_content]
            [@displayCommentList result=result resultComments=comments.get(result.id)/]
        [/#if]

        [#if user?? && fn.hasPlanPermission('READ', result.immutablePlan)]
            [#include "/feature/comments/commentForm.ftl" /]
        [/#if]

        [#if result.stageResults?has_content]
            [#assign aggregatedJobResultComments]
                [#list result.stageResults as stage]
                    [#list stage.sortedBuildResults as buildResult]
                        [#if comments.get(buildResult.id)?has_content]
                            [#assign job = buildResult.immutablePlan/]
                            <h3>Comments on
                                <a href="${req.contextPath}/browse/${buildResult.planResultKey}">${job.buildName}</a>
                            </h3>
                            [@displayCommentList result=buildResult resultComments=comments.get(buildResult.id) headingLevel='h4'/]
                        [/#if]
                    [/#list]
                [/#list]
            [/#assign]
            [#if aggregatedJobResultComments?has_content]
            ${aggregatedJobResultComments}
            [/#if]
        [/#if]
    </div>
    [/#if]
[/#macro]

[#import "/fragments/variable/variables.ftl" as variables/]
[#import "/lib/resultSummary.ftl" as ps]
[#--Displays manually overriden variables--]
[#macro displayManualVariables result manualVariables]
    [#if manualVariables?has_content || (result.onceOff && result.repositoryChangesets?has_content)]
        <div class="variables">
            <h2>[@ww.text name='buildResult.variable.title' /]</h2>
            [#if result.onceOff && result.repositoryChangesets?has_content]
                [#local defaultRepositoryChangeset=result.repositoryChangesets?sort_by("position")?first /]
                <dl class="details-list">
                    <dt>[@ww.text name='buildResult.variable.customRevision' /]</dt>
                    <dd>[@ps.showCommit plan=result.immutablePlan repositoryChangeset=defaultRepositoryChangeset/]</dd>
                </dl>
            [/#if]
            [#if manualVariables?has_content]
                [@variables.displayManualVariables id="chainManualVariables" variablesList=manualVariables /]
            [/#if]
        </div>
    [/#if]
[/#macro]

[#macro captcha]
    [@ww.textfield labelKey="user.captcha" name="captcha" required=true /]
    <div class="field-group">
        <img id="captcha-image" class="captcha-image" src="${req.contextPath}/captcha?atl_token=${ctx.xsrfToken?url}"/>
        [@dj.imageReload target="captcha-image" titleKey="user.captcha.reload"/]
    </div>
[/#macro]

[#-- @deprecated since 5.10 use @bulkSelectionLinks macro --]
[#macro displayOperationsHeader applicableForRepositories tagName='span']
    <${tagName} class="bulk-command">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_all">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_none">[@ww.text name='global.selection.none' /]</span>[#rt]
        [#if applicableForRepositories]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_plans">[@ww.text name='bulk.selection.plans' /]</span>[#rt]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_jobs">[@ww.text name='bulk.selection.jobs' /]</span>
        [/#if]
    </${tagName}>
    <script type="text/javascript">
        AJS.$(function () {
            BulkSelectionActions.init();
        });
    </script>
[/#macro]

[#-- @deprecated since 5.10 use @bulkSelectionLinks macro --]
[#macro displayProjectOperationsHeader key class applicableForRepositories enableProjectCheckbox ]
    <span class="${class}">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_sub_${key}">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_sub_none_${key}">[@ww.text name='global.selection.none' /]</span>[#rt]
        [#if applicableForRepositories]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_sub_plans_${key}">[@ww.text name='bulk.selection.plans' /]</span>[#rt]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_sub_jobs_${key}">[@ww.text name='bulk.selection.jobs' /]</span>
        [/#if]
    </span>
    <script type="text/javascript">
        AJS.$(function () {
            BulkSubtreeSelectionActions.init("${key}", ${enableProjectCheckbox?string});
        });
    </script>
[/#macro]

[#-- @deprecated since 5.10 use @bulkSelectionLinks macro --]
[#macro displaySubtreeOperationsHeader key class ]
    <span class="${class}">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_sub_${key}">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_sub_none_${key}">[@ww.text name='global.selection.none' /]</span>
    </span>
    <script type="text/javascript">
        AJS.$(function () {
            BulkSubtreeSelectionActions.init("${key}", false);
        });
    </script>
[/#macro]


[#macro displayBulkActionSelector bulkAction checkboxFieldValueType planCheckboxName repoCheckboxName="" enableProjectCheckbox=false]
    [@ww.hidden name="selectedBulkActionKey" /]

    [@displayOperationsHeader bulkAction.applicableForRepositories 'p' /]

    [#local hiddenForProjects = false/]
    [#local hiddenForPlans = false/]
    [#local hiddenForRepositories = false/]

    [#list sortedProjects as project]
        [#if action.isApplicable(bulkAction, project)]
            <div class="bulk-project-bar">
                [#if enableProjectCheckbox]
                    [#if checkboxFieldValueType == "id"]
                        [#local checkboxFieldValue = project.id! /]
                    [#else]
                        [#local checkboxFieldValue = project.key! /]
                    [/#if]
                    <div class="bulk-project-name">
                        [@ww.checkbox name='selectedProjects'
                            cssClass='bulk bulkProject bulkPlan bulk' + project.key + ' bulkProject' + project.key
                            id='checkbox_${project.key!}'
                            fieldValue=checkboxFieldValue
                            label='${project.name!}'
                            checked=action.isProjectSelected(project.key)?string
                            skipHiddenField = true/]
                        [#local hiddenForProjects = true/]
                    </div>
                [#else]
                    <span class="bulk-project-name">${project.name?html}</span>
                [/#if]
                [@displayProjectOperationsHeader project.key 'bulk-project-links' bulkAction.applicableForRepositories enableProjectCheckbox=enableProjectCheckbox /]
            </div>

            [#list action.getSortedTopLevelPlans(project) as plan]
                [#if bulkAction.isApplicable(plan)]
                    <div class="bulk-plan">
                        [#if checkboxFieldValueType == "id"]
                            [#local checkboxFieldValue = plan.id! /]
                        [#else]
                            [#local checkboxFieldValue = plan.key! /]
                        [/#if]

                        <div class="bulk-plan-left">
                            <div class="bulk-plan-name">
                                [@ww.checkbox name=planCheckboxName
                                    cssClass='bulk bulkPlan bulk' + project.key + ' bulkPlan' + project.key
                                    id='checkbox_${plan.key!}'
                                    fieldValue=checkboxFieldValue
                                    label='${plan.buildName?html}'
                                    checked="${action.isPlanSelected(plan.key)?string}"
                                    skipHiddenField=true/]
                                [#local hiddenForPlans = true/]
                            </div>
                        </div>

                        [#if bulkAction.applicableForRepositories]
                            <div class="bulk-plan-right">
                                [#local repositories= bulkAction.getRepositoryDefinitions(plan)]
                                [#if repositories?has_content]
                                    <fieldset class="bulk-job">
                                        [#if repositories.size() > 1]
                                            [@displaySubtreeOperationsHeader plan.key 'bulk-job-links' /]
                                        [/#if]
                                        [#list repositories as repositoryDefinition]
                                            [#local checkboxFieldValue = repositoryDefinition.id! /]
                                            [@ww.checkbox name=repoCheckboxName
                                                cssClass='bulk bulkJob bulk' + project.key + ' bulk' + plan.key + ' bulkJob' + project.key
                                                id='checkbox_${repositoryDefinition.id!}'
                                                fieldValue=checkboxFieldValue
                                                label='${repositoryDefinition.name?html}'
                                                checked="${action.isRepositorySelected(repositoryDefinition.id)?string}"
                                                skipHiddenField=true/]
                                            [#local hiddenForRepositories = true/]
                                        [/#list]
                                    </fieldset>
                                [/#if]
                            </div>
                        [/#if]
                    </div>
                [/#if]
            [/#list]
        [/#if]
    [/#list]
    [#if hiddenForProjects]
        [@s.hidden name="checkBoxFields" value='selectedProjects'/]
    [/#if]
    [#if hiddenForPlans]
        [@s.hidden name="checkBoxFields" value=planCheckboxName/]
    [/#if]
    [#if hiddenForRepositories]
        [@s.hidden name="checkBoxFields" value=repoCheckboxName/]
    [/#if]
[/#macro]

[#-- displays links for bulk selection and un-selection of checkboxes --]
[#macro bulkSelectionLinks containerId checkboxClass containerClass=""]
    <span id="${containerId}" class="${containerClass}"></span>
    <script type="text/javascript">
        require(['widget/bulk-selection-links'], function(BulkSelectionLinks) {
            new BulkSelectionLinks({
                el: '#${containerId}',
                checkboxClass: '${checkboxClass}'
            })
        });
    </script>
[/#macro]

[#macro displayLinkButton buttonId buttonLabel buttonUrl='' iconClass='' altText="" altTextKey="" cssClass="" primary=false disabled=false mutative=false extraAttributes={}]
    [#local title][@ww.text name=buttonLabel/][/#local]
    [#if altTextKey?has_content || altText?has_content]
        [#local altTextVal = fn.resolveName(altText, altTextKey) /]
    [#else]
        [#local altTextVal = title /]
    [/#if]
    [#local extraAttributes = extraAttributes + {
        "title": altTextVal
    } /]
    [#if !disabled && buttonUrl?has_content]
        [#local extraAttributes = extraAttributes + {
            "href": buttonUrl?replace("&amp;", "&", "i") [#-- replace is required to prevent double escaping of ampersands when Soy escapes the output --]
        } /]
    [/#if]

    [#local extraClasses]
        [#if primary]aui-button-primary[/#if][#t]
        [#if cssClass?has_content] ${cssClass}[/#if][#t]
    [/#local]

    [#local iconType][#if iconClass?has_content]aui[/#if][/#local]

${soy.render("aui.buttons.button", {
    "tagName": "a",
    "id": buttonId,
    "isDisabled": disabled,
    "text": title,
    "iconType": iconType,
    "iconClass": "aui-icon-small " + iconClass,
    "hasLabel": iconClass?has_content,
    "extraAttributes": extraAttributes,
    "extraClasses": extraClasses + mutative?string(" mutative", "")
})}
[/#macro]
