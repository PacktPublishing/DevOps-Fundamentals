[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]

[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/build.ftl" as builds]
[#include "/fragments/buildResults/showBuildResultsTable.ftl" /]

[@cp.filterDropDown filterController=filterController/]
[#if fn.isBranch(immutablePlan)]
    [@ui.header pageKey='build.summary.title' /]
[#elseif fn.isChain(immutablePlan)]
    [@ui.header pageKey='chain.summary.title.long' /]
[#else]
    [@ui.header pageKey='job.summary.title.long' /]
[/#if]

<div class="aui-group">
    <div id="planDetailsSummary" class="aui-item">

        <div id="activitySummary">
            <h2>[@ww.text name='build.currentactivity.title'/]</h2>
            [#if fn.isChain(immutablePlan)]
                [@chains.liveActivity expandable=false /]
            [#else]
                [@builds.liveActivity expandable=false /]
            [/#if]
        </div>

        <div class="recentHistorySummary">
            <h2>[@ww.text name='chain.summary.history'/]</h2>
            [@showBuildResultsTable
                pager=pager
                sort=false
                showAgent=false
                showOperations=false
                showArtifacts=false
                showDuration=false
                showHeader=false
                showPager=false
                useRelativeDate=true
                showFullBuildName=false/]

            [#if latestSummary?? || lastSuccessfulSummary??]
                <ul class="history-permalinks">
                    [#if latestSummary??]
                        <li>
                            <a id="buildResult_${latestSummary.planResultKey}" href="${req.contextPath}/browse/${planKey}/latest">
                                [@ui.icon type="permalink" /]
                                [@ww.text name="chain.summary.latest"/][#t]
                            </a>
                        </li>
                    [/#if]
                    [#if lastSuccessfulSummary??]
                        <li>
                            <a id="buildResult_${lastSuccessfulSummary.planResultKey}" href="${req.contextPath}/browse/${planKey}/latestSuccessful">
                                [@ui.icon type="permalink" /]
                                [@ww.text name="chain.summary.lastSuccessful"/][#t]
                            </a>
                        </li>
                    [/#if]
                </ul>
            [/#if]
        </div>

        [@cp.displayErrorsForPlan immutablePlan errorAccessor/]
    </div>
    [#assign isJob=immutablePlan.type.equals('JOB')/]
    <div id="planStatsSummary" class="aui-item">
        [#assign planI18nPrefix = fn.getPlanI18nKeyPrefix(immutablePlan)]
        <h2>[@ww.text name=planI18nPrefix+'.statistics.title.long'/]</h2>
        [@cp.buildStatistics statistics immutablePlan.averageBuildDuration resultsList?has_content /]
        [#if !navigationContext.currentObject.parent?? && (navigationContext.navObject.branches)?has_content]
            <div id="quick-branch-list">
                <h2>[@ww.text name="chain.branches.title" /]</h2>
                [#assign branches=chainBranchesByDate/]
                [#if branches?size > 10]
                    [#assign branchesSubList=branches[0..9] /]
                [#else]
                    [#assign branchesSubList=branches /]
                [/#if]
                [@planList.displayWideBuildPlansList builds=branchesSubList showProject=false showActions=false showHeadings=false showBuildDetails=false setColumnWidths=false showBranchIcons=true/]
                [#if branches?size > 10]
                    <a class="more-link" href="${req.contextPath}/browse/${planKey}/branches">[@ww.text name="branch.complete.listing"/]</a>
                [/#if]
            </div>
        [/#if]
        [@displayBranchInformation immutablePlan/]
    </div>
</div>

<p class="plan-rss-feed">
    [#assign allBuildsUrl="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${immutablePlan.key}${rssSuffix}" /]
    [#assign allBuildsTitle="&ldquo;${immutablePlan.name?html}&rdquo; all builds RSS feed" /]

    [#assign failedBuildsUrl="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${immutablePlan.key}${rssSuffix}" /]
    [#assign failedBuildsTitle="&ldquo;${immutablePlan.name?html}&rdquo; failed builds RSS feed" /]

    <a href="${allBuildsUrl}">[@ui.icon useIconFont=true type="rss" text="${allBuildsTitle}" /]</a>
    Feed for <a id="allBuildsPlanRSS" href="${allBuildsUrl}" title="${allBuildsTitle}">all builds</a>
    or just the <a id="failedBuildsPlanRSS" href="${failedBuildsUrl}" title="${failedBuildsTitle}">failed builds</a>.
</p>

[#macro displayBranchInformation plan]
    [#assign isBranch = fn.isBranch(plan)/]
    [#if isBranch??]
        [#if (plan.commitInformation?? && (plan.commitInformation.creatingCommitDate?? || plan.commitInformation.creatingAuthor??))]
            <h2>[@ww.text name='branch.vcsBranchDetails.title' /]</h2>
            <dl id="branch-information">
                [#if (plan.commitInformation.creatingAuthor)??]
                    <dt>[@ww.text name="branch.vcsBranchDetails.creator" /]</dt>
                    <dd><a href="[@cp.displayAuthorOrProfileLink author=plan.commitInformation.creatingAuthor /]">[@ui.displayAuthorFullName author=plan.commitInformation.creatingAuthor /]</a></dd>
                [/#if]
                [#if (plan.commitInformation.creatingCommitDate)??]
                    <dt>[@ww.text name="branch.vcsBranchDetails.created" /]</dt>
                    <dd>[@ui.time datetime=plan.commitInformation.creatingCommitDate cssClass="revision-date" showTitle=true]${action.getRelativeDateString(plan.commitInformation.creatingCommitDate)!}[/@ui.time]</dd>
                [/#if]
            </dl>
        [/#if]
    [/#if]

    <script type="application/javascript">
        AJS.trigger('analyticsEvent', {
            name: 'bamboo.plan.summary.viewed',
            data: {
                planbranch: ${isBranch?string("true", "false")}
            }
        });
    </script>
[/#macro]