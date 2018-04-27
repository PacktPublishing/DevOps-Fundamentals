[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.plan.Plan" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="buildNumber" type="int" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]

[#include "notificationCommons.ftl"]

[#-- ============================================================================================= @nc.templateOuter --]
[#macro templateOuter baseUrl showTitleStatus=true statusMessage='']
    [#assign notificationTitleHtml]
        [#if buildSummary??]
            [#if !statusMessage?has_content]
                [#assign statusText][#if buildSummary.successful]was successful[#else]failed[/#if][/#assign]
            [#else]
                [#assign statusText = statusMessage /]
            [/#if]
            [@notificationTitleBuildStatus
                baseUrl=baseUrl
                status=getBuildStatus(buildSummary)
                build=buildSummary.immutablePlan
                buildResultKey=buildSummary.planResultKey
                buildNumber=buildSummary.buildNumber
                statusMessage=statusText
            /]
        [#elseif build?? && buildKey?? && buildNumber??]
            [@notificationTitleBuildStatus
                baseUrl=baseUrl
                status="unknown"
                build=build
                buildResultKey=buildKey
                buildNumber=buildNumber
                statusMessage=statusMessage
            /]
        [/#if]
    [/#assign]
    [@templateBase baseUrl=baseUrl notificationTitleHtml=notificationTitleHtml]
        [#nested /]
    [/@templateBase]
[/#macro]

[#macro templateBase baseUrl notificationTitleHtml='']
    <html>
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width" />
            <style type="text/css">
                a:hover, a:focus, input.postlink:hover, input.postlink:focus { text-decoration: underline !important;}
                a.button:focus, a.button:hover {
                    text-decoration: none !important;
                }
                @media handheld, only screen and (max-device-width: 480px) {
                    div, a, p, td, th, li, dt, dd {
                        -webkit-text-size-adjust: auto;
                    }
                    small, small a {
                        -webkit-text-size-adjust: 90%;
                    }
                    small[class=email-metadata] {
                        -webkit-text-size-adjust: 93%;
                        font-size: 12px;
                    }

                    table[id=email-wrap] > tbody > tr > td {
                        padding: 2px !important;
                    }
                    table[id=email-wrap-inner] > tbody > tr > td {
                        padding: 8px !important;
                    }
                    table[id=email-footer] td {
                        padding: 8px 12px !important;
                    }
                    table[id=email-actions] td {
                        padding-top: 0 !important;
                    }
                    table[id=email-actions] td.right {
                        text-align: right !important;
                    }
                    table[id=email-actions] .email-list-item {
                        display: block;
                        margin: 1em 0 !important;
                        word-wrap: normal !important;
                    }
                    span[class=email-list-divider] {
                        display: none;
                    }
                    .commentsummary small[class=email-metadata] {
                        display: block;
                    }
                    td.comment-avatar {
                        padding: 8px 8px 0 8px !important;
                    }
                    .comment > td + td {
                        padding: 8px 8px 8px 0 !important;
                    }
                }
            </style>
        </head>
        <body>
            <table id="email-wrap" align="center" cellpadding="0" cellspacing="0" width="100%">
                <tbody>
                <tr>
                    <td>
                        [#if notificationTitleHtml?has_content]
                            ${notificationTitleHtml}
                        [/#if]
                        <table id="email-wrap-inner" cellpadding="0" cellspacing="0" width="100%">
                            <tbody>
                            <tr>
                                <td>
                                    [#nested]
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        [@showEmailFooter baseUrl=baseUrl /]
                    </td>
                </tr>
                </tbody>
            </table>
        </body>
    </html>
[/#macro]

[#function getBuildStatus buildSummary]
    [#if buildSummary.successful]
        [#return "successful"]
    [#else]
        [#return "failed"]
    [/#if]
[/#function]

[#-- =================================================================================================== @nc.lozenge --]
[#-- Clone of the AUI lozenge for HTML notifications. --]
[#-- See: https://docs.atlassian.com/aui/latest/docs/lozenges.html --]
[#macro lozenge text color="" subtle=false]
    <span class="lozenge [#if color?has_content]lozenge-${color?html}[/#if] [#if subtle]lozenge-subtle[/#if]">${text?html}</span>
[/#macro]

[#-- =============================================================================================== @nc.showActions --]
[#macro showActions buttons=false]
    <table width="100%" cellpadding="0" cellspacing="0" id="email-actions" class="email-metadata">
        <tbody>
            <tr>
                <td class="left">
                    <div class="[#if buttons]buttons[/#if]">
                        [#nested]
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
[/#macro]


[#-- ================================================================================================= @nc.addAction --]
[#macro addAction name url addDelimeter=false]
    [#if addDelimeter]<span class="email-list-divider">|</span>[/#if]
    <span class="email-list-item"><a href="${url}">${name}</a></span>
[/#macro]

[#macro addMutativeAction name url first=false]
    [#if !first]<span class="email-list-divider">|</span>[/#if]
    <form method="post" action="${url}" class="postlink"><input type="submit" class="postlink email-list-item" value="${name}"/></form>
[/#macro]

[#macro addActionButton name url primary=false]
    <a class="button [#if primary]primary[/#if]" href="${url}">${name}</a>
[/#macro]

[#-- ==================================================================================== @nc.notificationTitleBlock --]
[#macro notificationTitleBlock baseUrl='' userName='' flavorHtml='']
    <table id="email-title" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
            <tr>
                <td id="email-title-avatar" rowspan="2" width="56">
                    [@displayGravatar baseUrl userName "48" /]
                </td>
                <td>
                    [#if flavorHtml?has_content]
                        <p id="email-title-flavor" class="email-metadata">${flavorHtml}</p>
                    [/#if]
                </td>
            </tr>
            <tr>
                <td>
                    [#nested]
                </td>
            </tr>
        </tbody>
    </table>
[/#macro]

[#-- ============================================================================== @nc.notificationTitleBuildStatus --]
[#macro notificationTitleBuildStatus baseUrl status build buildResultKey buildNumber statusMessage='']
    <div id="title-status" class="${status}">
        <table cellpadding="0" cellspacing="0" width="100%">
            <tbody>
                <tr>
                    <td id="title-status-icon">
                        [#if status == "successful"]
                            <img src="${baseUrl}/images/iconsv4/icon-build-successful-w.png" alt="Successful">
                        [#elseif status == "failed"]
                            <img src="${baseUrl}/images/iconsv4/icon-build-failed-w.png" alt="Failed">
                        [#else]
                            <img src="${baseUrl}/images/iconsv4/icon-build-unknown-w.png" alt="Unknown">
                        [/#if]
                    </td>
                    <td id="title-status-text">
                        [@displayBuildTitle baseUrl build buildResultKey buildNumber /]
                        <span class="status">${statusMessage?trim}[#if buildSummary??][@showRestartCount buildSummary/][/#if]</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
[/#macro]

[#-- ================================================================================ @nc.notificationTitleSpecError --]
[#macro notificationTitleSpecError baseUrl]
    <div id="title-status" class="failed">
        <table cellpadding="0" cellspacing="0" width="100%">
            <tbody>
            <tr>
                <td id="title-status-icon">
                    <img src="${baseUrl}/images/iconsv4/icon-build-spec-failure-w.png" alt="Bamboo Spec failed">
                </td>
                <td id="title-status-text">
                    Error in Bamboo Specs
                </td>
            </tr>
            </tbody>
        </table>
    </div>
[/#macro]

[#-- ================================================================================ @nc.notificationTitleSpecSuccess --]
[#macro notificationTitleSpecSuccess baseUrl]
<div id="title-status" class="successful">
    <table cellpadding="0" cellspacing="0" width="100%">
        <tbody>
        <tr>
            <td id="title-status-icon">
                <img src="${baseUrl}/images/iconsv4/icon-build-spec-success-w.png" alt="Bamboo Spec successful">
            </td>
            <td id="title-status-text">
                Specs execution successful
            </td>
        </tr>
        </tbody>
    </table>
</div>
[/#macro]


[#macro displayBranchIcon]
    <img class="icon-branch" alt="Branch" src="${baseUrl}/images/icons/branch.png"/>[#t]
[/#macro]

[#-- ========================================================================================= @nc.displayBuildTitle --]
[#-- This is just the name of the plan/result not the entire red/green section.--]
[#macro displayBuildTitle baseUrl build buildResultKey buildNumber]
    <span class="build">
        [#if build.parent?has_content]
            <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
            [#if build.parent.master?has_content]
                <a href="${baseUrl}/browse/${build.parent.master.key}/">${build.parent.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
            [/#if]
            <a href="${baseUrl}/browse/${build.parent.key}/">${build.parent.buildName}</a> &rsaquo;
            <a href="${baseUrl}/browse/${build.parent.key}-${buildNumber}/">#${buildNumber}</a> &rsaquo;
            <a href="${baseUrl}/browse/${buildResultKey}/">${build.buildName}</a>
        [#else]
            <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
            [#if build.master?has_content]
                <a href="${baseUrl}/browse/${build.master.key}/">${build.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
            [/#if]
            <a href="${baseUrl}/browse/${build.key}/">${build.buildName}</a> &rsaquo;
            <a href="${baseUrl}/browse/${buildResultKey}/">#${buildNumber}</a>
        [/#if]
    </span>
[/#macro]

[#macro displayPlanTitle baseUrl build]
<span class="build">
    [#if build.parent?has_content]
        <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
        [#if build.parent.master?has_content]
            <a href="${baseUrl}/browse/${build.parent.master.key}/">${build.parent.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
        [/#if]
        <a href="${baseUrl}/browse/${build.parent.key}/">${build.parent.buildName}</a> &rsaquo;
        <a href="${baseUrl}/browse/${build.key}/">${build.buildName}</a>
    [#else]
        <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
        [#if build.master?has_content]
            <a href="${baseUrl}/browse/${build.master.key}/">${build.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
        [/#if]
        <a href="${baseUrl}/browse/${build.key}/">${build.buildName}</a>
    [/#if]
</span>
[/#macro]

[#-- ====================================================================================== @nc.displayTriggerReason --]

[#macro displayTriggerReason]
    [#if triggerReasonDescription?? && triggerReasonDescription?has_content]
        <p class="trigger">${triggerReasonDescription}</p>
    [/#if]
[/#macro]

[#-- ================================================================================================ @nc.sectionHeader --]

[#macro sectionHeader baseUrl url title utilText='']
    <table width="100%" cellpadding="0" cellspacing="0" class="section-header">
        <tr>
            <td>
                <h3><a href="${url}">${title}</a></h3>
            </td>
            [#if utilText?has_content]
                <td class="utility">
                    <a href="${url}">${utilText}</a>
                </td>
            [/#if]
        </tr>
   </table>
[/#macro]

[#-- ================================================================================================ @nc.displayJobRow --]

[#macro displayJobRow jobResult stageResult]
    <tr>
        <td class="status-icon">
            [#if jobResult.successful]
                <img src="${baseUrl}/images/iconsv4/icon-build-successful.png" alt="Successful">
            [#elseif jobResult.failed]
                <img src="${baseUrl}/images/iconsv4/icon-build-failed.png" alt="Failed">
            [#else]
                <img src="${baseUrl}/images/iconsv4/icon-build-unknown.png" alt="Unknown">
            [/#if]
        </td>
        <td class="[#if jobResult.successful]successful[#elseif jobResult.failed]failed[#else]cancelled[/#if]">
            <a href="${baseUrl}/browse/${jobResult.planResultKey}/">${jobResult.immutablePlan.buildName}</a>
            <span>(${stageResult.name})</span>
        </td>
        <td width="120">
            [#if jobResult.finished]
                ${jobResult.durationDescription}
            [#else]
                &nbsp;
            [/#if]
        </td>
        <td width="130">
            [#if jobResult.finished]
                ${jobResult.testSummary}
            [#else]
                &nbsp;
            [/#if]
        </td>
        <td class="actions">
            [#if jobResult.finished]
                <a href="${baseUrl}/browse/${jobResult.planResultKey}/log">Logs</a> | <a href="${baseUrl}/browse/${jobResult.planResultKey}/artifact">Artifacts</a>
            [#else]
                &nbsp;
            [/#if]
        </td>
    </tr>
[/#macro]

[#-- ========================================================================================== @nc.showCommitsHtml --]
[#macro showCommits buildSummary baseUrl='']
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
    [#if buildSummary.commits?has_content]
        [#assign utilText]
            [#if buildSummary.commits?size gt 3]View all ${buildSummary.commits?size} code changes[#else]View full change details[/#if][#t]
        [/#assign]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/commit/" "Code Changes" utilText/]
        <table width="100%" cellpadding="0" cellspacing="0" class="commits">
            [#if buildSummary.repositoryChangesets?has_content]
                [#list buildSummary.repositoryChangesets as repositoryChangeset]
                    [#assign repositoryData=repositoryChangeset.repositoryData/]
                    [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
                        [#if commit_index gte 3][#break][/#if]
                        <tr>
                            <td class="commit-avatar">
                                [@displayGravatar baseUrl commit.author.linkedUserName!""/]
                            </td>
                            <td width="100%">
                                <a href="[@ui.displayAuthorOrProfileLink commit.author/]">${commit.author.fullName?html}</a><br>
                                ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commit.comment), buildSummary)}
                            </td>
                            <td class="revision">
                                [#assign revision = commit.guessChangeSetId()!("")]
                                [#assign commitUrl = (notification.getCommitUrl(repositoryData, revision))!('')]
                                [#if "Unknown" != commit.author.name && commitUrl?has_content]
                                    <a href="${commitUrl}" class="revision-id" title="View change set in Web Repository Viewer">${revision?html}</a>
                                [#elseif revision?has_content]
                                    <span class="revision-id">${revision?html}</span>
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                [/#list]
                [#if buildSummary.commits?size gt 3]
                    <tr>
                        <td colspan="3">
                            <a href="${baseUrl}/browse/${buildSummary.planResultKey}/commit">${buildSummary.commits?size - 3} more changes&hellip;</a>
                        </td>
                    </tr>
                [/#if]
            [#else]
                <tr>
                    <td>This build does not have any commits.</td>
                </tr>
            [/#if]
        </table>
    [/#if]
[/#macro]

[#-- ========================================================================================== @nc.displayGravatar --]
[#macro displayGravatar baseUrl userName size="24"]
<img src="${ctx.getGravatarUrl((userName)!, size)!(baseUrl + "/images/icons/useravatar.png")}" width="${size}" height="${size}">
[/#macro]


[#-- ========================================================================================== @nc.showCommitsHtmlNoBuildResult --]
[#macro showCommitsNoBuildResult commits baseUrl='' buildKey='']
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
    [#if commits?has_content]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildKey}/log" "Code Changes"/]
        <table width="100%" cellpadding="0" cellspacing="0" class="commits">
            [#if commits?has_content]
                [#list commits as commit]
                    [#if commit_index gte 3][#break][/#if]
                    <tr>
                        <td class="commit-avatar">
                            [@displayGravatar baseUrl commit.authorContext.linkedUserName!""/]
                        </td>
                        <td width="100%">
                            <a href="[@ui.displayAuthorOrProfileLink commit.authorContext/]">${commit.authorContext.name?html}</a><br>
                            ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commit.comment), buildKey, buildNumber)}
                        </td>
                        <td class="revision">
                            [#assign revision = commit.getChangeSetId()!("")]
                            [#-- should link to web repository viewer here  but the code below is outdated and doesn't work --]

                            [#--[#if (build.buildDefinition.repository.hasWebBasedRepositoryAccess())!false && "Unknown" != commit.author.name && guessedRevision?has_content]
                                [#assign commitUrl = (build.buildDefinition.repository.getWebRepositoryUrlForCommit(commit))!('') /]
                                [#if commitUrl?has_content]
                                    <a href="${commitUrl}" class="revision-id" title="View change set in Web Repository Viewer">${guessedRevision?html}</a>
                                [/#if]
                            [#else--]
                            [#if revision?has_content]
                                 <span class="revision-id">${revision?html}</span>
                            [/#if]
                        </td>
                    </tr>
                [/#list]
                [#if commits?size gt 3]
                    <tr>
                        <td colspan="3">
                            <a href="${baseUrl}/browse/${buildKey}/commit">${commits?size - 3} more changes&hellip;</a>
                        </td>
                    </tr>
                [/#if]
            [/#if]
        </table>
    [/#if]
[/#macro]

[#-- ============================================================================================ @nc.showAllCommits --]
[#macro showAllCommits commits baseUrl]
    [#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
    [#if commits?has_content]
        <table width="100%" cellpadding="0" cellspacing="0" class="one-line-table all-commits">
            <tr>
                <th class="all-commits__author">Author</th>
                <th class="all-commits__commit">Commit</th>
                <th class="all-commits__message">Message</th>
                <th class="all-commits__date">Commit date</th>
            </tr>
            [#list commits as commit]
                <tr>
                    <td class="all-commits__author">
                        [@displayGravatar baseUrl=baseUrl userName=commit.authorContext.linkedUserName!'' size='16'/]
                        ${commit.authorContext.name?html}
                    </td>
                    <td class="all-commits__commit">
                        [#assign revision = commit.getChangeSetId()!('')/]
                        [#if commit.url?has_content]
                        <a href="${commit.url}">${revision[0..10]?html}</a>
                        [#else]
                        ${revision[0..10]?html}
                        [/#if]
                    </td>
                    <td class="all-commits__message">
                        ${commit.comment?html}
                    </td>
                    <td class="all-commits__date">
                        [@ui.time datetime=commit.date format='datetime' /]
                    </td>
                </tr>
            [/#list]
        </table>
    [/#if]
[/#macro]

[#-- =================================================================================== @nc.showAllSpecFailedBuilds --]
[#macro showAllSpecFailedBuilds failedBuilds baseUrl projectsNames repositoriesIds]
[#-- @ftlvariable name="failedBuilds" type="java.util.Collection<com.atlassian.bamboo.notification.rss.RssAffectedPlan>" --]
[#-- @ftlvariable name="projectsNames" type="java.util.Map<String, String>" --]
[#-- @ftlvariable name="repositoriesIds" type="java.util.Map<String, Long>" --]
    [#if failedBuilds?has_content]
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <h3>Affected plans</h3>
                </td>
            </tr>
            <tr>
                <td>
                    Because of an error in Bamboo Specs, the following plans could not be updated.
                </td>
            </tr>
        </table>
        <table width="100%" cellpadding="0" cellspacing="0" class="one-line-table all-spec-failed-builds">
            <tr>
                <th class="all-spec-failed-builds__project">Project</th>
                <th class="all-spec-failed-builds__plan">Plan</th>
                <th class="all-spec-failed-builds__build">Build</th>
            </tr>
            [#list failedBuilds as build]
                <tr  [#if build.isRssMissingAnyAccess()]class="all-spec-failed-builds__missing-permissions"[/#if]>
                    <td class="all-spec-failed-builds__project">
                        <a href="${baseUrl}/browse/${build.projectKey}">${build.projectName}</a>
                    </td>
                    <td class="all-spec-failed-builds__plan">
                        <a href="${baseUrl}/browse/${build.planKey.key}">${build.name}</a>
                    </td>
                    <td class="all-spec-failed-builds__build">
                        [#if build.buildNumber??]
                            <a href="${baseUrl}/browse/${build.planKey.key}-${build.buildNumber}"><img src="${baseUrl}/images/iconsv4/icon-build-spec-failure.png" alt="Spec failed">#${build.buildNumber}</a>
                        [/#if]
                    </td>
                </tr>
                [#if build.isRssMissingAnyAccess()]
                    <tr class="all-spec-failed-builds__missing-permissions-projects">
                        <td colspan="3">
                            <img src="${baseUrl}/images/iconsv4/icon-warning.png" width="16" height="16">
                            <small>Bamboo Specs execution failed due to missing permissions.
                                Grant Bamboo Specs repository access to the following:
                                <ul>
                                [#if build.projectsMissingRssAccess?has_content]
                                    [#list build.projectsMissingRssAccess as projectKey]
                                        <li>
                                            <a href="${baseUrl}/project/admin/config/editProjectSpecsRepositories.action?projectKey=${projectKey}">${projectsNames[projectKey]}</a>
                                        </li>
                                    [/#list]
                                [/#if]
                                [#if build.repositoriesMissingRssAccess?has_content]
                                    [#list build.repositoriesMissingRssAccess as repositoryName]
                                        <li>
                                            <a href="${baseUrl}/admin/configureLinkedRepositories!doDefault.action?repositoryId=${repositoriesIds[repositoryName]}">${repositoryName}</a>
                                        </li>
                                    [/#list]
                                [/#if]
                                </ul>
                            </small>
                        </td>
                    </tr>
                [/#if]
            [/#list]
        </table>
    [/#if]
[/#macro]

[#-- =================================================================================== @nc.showAllSpecUpdatedBuilds --]
[#macro showAllSpecUpdatedBuilds affectedBuilds baseUrl]
[#-- @ftlvariable name="affectedBuilds" type="java.util.List<com.atlassian.bamboo.notification.rss.RssNotification.RssAffectedPlan>" --]
    [#if affectedBuilds?has_content]
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <h3>Plans updated</h3>
            </td>
        </tr>
        <tr>
            <td>
                Bamboo specs have been successfully imported and the following plans have been updated.
            </td>
        </tr>
    </table>
    <table width="100%" cellpadding="0" cellspacing="0" class="one-line-table all-spec-successful-builds">
        <tr>
            <th class="all-spec-successful-builds__project">Project</th>
            <th class="all-spec-successful-builds__plan">Plan</th>
            <th class="all-spec-successful-builds__build">Build</th>
        </tr>
        [#list affectedBuilds as build]
            <tr>
                <td class="all-spec-successful-builds__project">
                    <a href="${baseUrl}/browse/${build.projectKey}">${build.projectName}</a>
                </td>
                <td class="all-spec-successful-builds__plan">
                    <a href="${baseUrl}/browse/${build.planKey.key}">${build.name}</a>
                    [#if build.disabled]
                        [@lozenge text="Disabled" /]
                    [/#if]
                </td>
                <td class="all-spec-successful-builds__build">
                    [#if build.buildNumber??]
                        <a href="${baseUrl}/browse/${build.planKey.key}-${build.buildNumber}"><img src="${baseUrl}/images/iconsv4/icon-build-spec-success.png" alt="Spec successful">#${build.buildNumber}</a>
                    [/#if]
                </td>
            </tr>
        [/#list]
    </table>
    [/#if]
[/#macro]

[#-- =================================================================================== @nc.showAllSpecFailedDeployments --]
[#macro showAllSpecFailedDeployments failedDeployments baseUrl]
[#-- @ftlvariable name="failedDeployments" type="java.util.List<com.atlassian.bamboo.notification.rss.RssNotification.RssAffectedDeployment>" --]
    [#if failedDeployments?has_content]
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <h3>Deployments affected</h3>
            </td>
        </tr>
        <tr>
            <td>
                There was an error in Bamboo Specs and the following deployment projects could not be updated.
            </td>
        </tr>
    </table>
    <table width="100%" cellpadding="0" cellspacing="0" class="one-line-table all-spec-failed-builds">
        <tr>
            <th class="all-spec-failed-builds__project">Deployment project</th>
        </tr>
        [#list failedDeployments as deployment]
            <tr>
                <td class="all-spec-failed-builds__project">
                    <a href="${baseUrl}/deploy/viewDeploymentProjectVersions.action?id=${deployment.id}">${deployment.name}</a>
                </td>
            </tr>
        [/#list]
    </table>
    [/#if]
[/#macro]

[#-- =================================================================================== @nc.showAllSpecUpdatedDeployments --]
[#macro showAllSpecUpdatedDeployments affectedDeployments baseUrl]
[#-- @ftlvariable name="failedDeployments" type="java.util.List<com.atlassian.bamboo.notification.rss.RssNotification.RssAffectedDeployment>" --]
    [#if affectedDeployments?has_content]
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <h3>Deployments updated</h3>
            </td>
        </tr>
        <tr>
            <td>
                Bamboo specs have been successfully imported and the following deployment projects have been updated.
            </td>
        </tr>
    </table>
    <table width="100%" cellpadding="0" cellspacing="0" class="one-line-table all-spec-successful-builds">
        <tr>
            <th class="all-spec-successful-builds__project">Deployment project</th>
        </tr>
        [#list affectedDeployments as deployment]
            <tr>
                <td class="all-spec-successful-builds__project">
                    <a href="${baseUrl}/deploy/viewDeploymentProjectVersions.action?id=${deployment.id}">${deployment.name}</a>
                </td>
            </tr>
        [/#list]
    </table>
    [/#if]
[/#macro]

[#-- =========================================================================================== @nc.showFailingJobs --]
[#macro showFailingJobs buildSummary baseUrl]
    [#if buildSummary.failed]
        [#assign failingJob = false/]
        [#assign failingJobs]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/" "Failing Jobs"/]
        <table width="100%" cellpadding="0" cellspacing="0" class="aui failing-jobs">
            <thead>
                <tr>
                    <th colspan="2">Job</th>
                    <th>Duration</th>
                    <th>Tests</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                [#list buildSummary.stageResults as stageResult]
                    [#list stageResult.sortedBuildResults as jobResult]
                        [#if jobResult.failed]
                            [@displayJobRow jobResult stageResult/]
                            [#assign failingJob = true /]
                        [/#if]
                    [/#list]
                [/#list]
                [#if !failingJob]
                    <tr>
                        <td colspan="5">No failed jobs found.</td>
                    </tr>
                [/#if]
            </tbody>
        </table>
        [/#assign]
        [#if failingJob || !(buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()) ]
            ${failingJobs}
        [/#if]
    [/#if]
[/#macro]

[#-- ============================================================================================== @nc.showChainsTests --]
[#macro showChainTests crs testResults baseUrl]
[#-- @ftlvariable name="crs" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
    [#if testResults??]
        [@showTests crs baseUrl testResults /]
    [/#if]
[/#macro]

[#macro showJobTests buildSummary baseUrl]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
    [#if buildSummary.filteredTestResults??]
        [@showTests buildSummary baseUrl buildSummary.filteredTestResults false /]
    [/#if]
[/#macro]

[#macro showTests buildSummary baseUrl testResults showJob=true]
[#-- @ftlvariable name="testResults" type="com.atlassian.bamboo.resultsummary.tests.FilteredTestResults" --]
    [#assign testSummary = buildSummary.testResultsSummary /]
    [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
    [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
    [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
    [#assign numTests=0 /]
    [#assign maxTests=25 /]
    [#if hasExistingFailedTests || hasNewlyFailingTests || hasFixedTests]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/test" "Tests" "View full test details" /]
        [#if hasNewlyFailingTests]
            [@displayTestList "New Test Failures" testSummary.newFailedTestCaseCount testResults.newFailedTests "${baseUrl}/images/iconsv4/icon-build-failed.png" baseUrl numTests maxTests showJob/]
        [/#if]
        [#if hasExistingFailedTests]
            [@displayTestList "Existing Test Failures" testSummary.existingFailedTestCount testResults.existingFailedTests "${baseUrl}/images/iconsv4/icon-build-failed.png" baseUrl numTests maxTests showJob/]
        [/#if]
        [#if hasFixedTests]
            [@displayTestList "Fixed Tests" testSummary.fixedTestCaseCount testResults.fixedTests "${baseUrl}/images/iconsv4/icon-build-successful.png" baseUrl numTests maxTests showJob/]
        [/#if]
    [/#if]
[/#macro]

[#macro displayTestList title totalCount testList imageUrl baseUrl numTests maxTests showJob=true]
    [#if numTests lt maxTests]
        <h4>${totalCount} ${title}</h4>
        <table width="100%" cellpadding="0" cellspacing="0" class="aui tests">
            <thead>
                <tr>
                    <th colspan="2">Test</th>
                    [#if showJob]
                        <th>Job</th>
                    [/#if]
                </tr>
            </thead>
            <tbody>
                [#list testList.values() as testResult]
                    [#if numTests gte maxTests][#break][/#if]
                    [@displayTest testResult imageUrl baseUrl numTests maxTests showJob/]
                [/#list]
            </tbody>
        </table>
    [/#if]
[/#macro]

[#macro displayTest testResult img baseUrl numTests maxTests showJob=true]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
    [#assign numTests = numTests + 1 /]
    [#assign jobResult = testResult.testClassResult.buildResultsSummary /]
        <tr>
            <td class="status-icon">
                <img src="${img}">
            </td>
            <td>
                <span class="test-class">${testResult.testClassResult.shortName?html}</span>
                <a href="${baseUrl}${fn.getTestCaseResultUrl(jobResult.planKey, jobResult.buildNumber, testResult.testCase.id)}" class="test-name">${testResult.name?html}</a>
            </td>
            [#if showJob]
                <td>
                    <a href="${baseUrl}/browse/${jobResult.planResultKey}/test">${jobResult.immutablePlan.buildName}</a>
                </td>
            [/#if]
        </tr>
[/#macro]

[#macro displayBuildFailureMessage buildSummary totalJobCount=0]
    [#assign testSummary = buildSummary.testResultsSummary /]
    [#if testSummary.totalTestCaseCount == 0]
        [#if buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()]
            [@showMergeDetails buildSummary/]
        [#elseif totalJobCount?? && totalJobCount > 1]
            <strong>${failingJobCount}/${buildSummary.totalJobCount}</strong> jobs failed, no tests found.[#t]
        [#else]
            No failed tests found, a possible compilation error.
        [/#if]
    [#else]
        [#if buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()]
            [@showMergeDetails buildSummary/]
        [#elseif totalJobCount?? && totalJobCount > 1]
            <strong>${failingJobCount}/${buildSummary.totalJobCount}</strong> jobs failed with <strong>${testSummary.failedTestCaseCount}</strong> failing test[#if testSummary.failedTestCaseCount != 1]s[/#if].[#t]
        [#else]
            <strong>${testSummary.failedTestCaseCount}/${testSummary.totalTestCaseCount}</strong> tests failed.
        [/#if]
    [/#if]
[/#macro]

[#macro showMergeDetails buildSummary ]
    [#assign repositoryData=(buildSummary.repositoryChangesets?first).repositoryData/]
    [#assign mergeResult=buildSummary.mergeResult /]
    <table class="aui" id="mergeResults">
    <tr>
        [#if mergeResult.mergeState == "FAILED"]
            <th>Merge Failed:</th><td><pre>${mergeResult.failureReason?html?trim}</pre></td>
        [#else]
            <th>Push Failed:</th><td><pre>${mergeResult.failureReason?html?trim}</pre></td>
        [/#if]
    </tr>
    [#if (mergeResult.integrationStrategy!"") == "GATE_KEEPER"]
        [#assign checkoutRevision]
            [@showMergeRevision repositoryData mergeResult.integrationBranchVcsKey  mergeResult.integrationRepositoryBranchName /]
        [/#assign]
        [#assign mergedRevision]
            [@showMergeRevision repositoryData mergeResult.branchTargetVcsKey mergeResult.branchName /]
        [/#assign]
        [#assign pushedRevision]
            [@showMergeRevision repositoryData mergeResult.mergeResultVcsKey mergeResult.integrationRepositoryBranchName /]
        [/#assign]
    [#elseif (mergeResult.integrationStrategy!"") == "BRANCH_UPDATER"]
        [#assign checkoutRevision]
            [@showMergeRevision repositoryData mergeResult.branchTargetVcsKey mergeResult.branchName /]
        [/#assign]
        [#assign mergedRevision]
            [@showMergeRevision repositoryData mergeResult.integrationBranchVcsKey mergeResult.integrationRepositoryBranchName /]
        [/#assign]
        [#assign pushedRevision]
            [@showMergeRevision repositoryData mergeResult.mergeResultVcsKey mergeResult.branchName /]
        [/#assign]
    [/#if]
    <tr>
        <th>Checkout:</th><td>${checkoutRevision!}</td>
    </tr>
    <th>Merged From:</th><td>${mergedRevision!}</td>
    [#if pushedRevision?has_content]
        <th>Pushed:</th><td>${pushedRevision!}</td>
    [/#if]
    </table>

[/#macro]

[#macro showMergeRevision repositoryData vcsKey="" branchName="" ]
    [#if vcsKey?has_content]
        [#if branchName?has_content]<span class="branch-name">${branchName?html}:</span>[/#if] [#t]
        [@showRevision vcsKey repositoryData /] [#t]
    [/#if]
[/#macro]

[#macro showRevision revision repositoryData]
    [#if commit??]
        [#assign commitUrl = (notification.getCommitUrl(repositoryData, revision))!('') /]
        [#if commitUrl?has_content]
            <a href="${commitUrl}" class="revision-id" title="View change set in Web Repository Viewer">${revision!?html}</a>
        [#else]
            <span class="revision-id">${revision!}</span>
        [/#if]
    [#else ]
        <span class="revision-id">${revision!}</span>
    [/#if]
[/#macro]
[#-- ============================================================================================== @nc.showLogHtml --]
[#macro showLogs lastLogs='' baseUrl='' buildKey='']
    [#if lastLogs?has_content]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildKey}/log" "Last Logs" /]
        <table width="100%" cellpadding="0" cellspacing="0" class="log">
           [#list lastLogs as log]
                <tr>
                    <th>${log.formattedDate}</th>
                    <td>${log.log}</td>
                </tr>
            [/#list]
        </table>
    [/#if]
[/#macro]

[#-- ====================================================================================== @nc.showEmailFooterHtml --]
[#macro showEmailFooter baseUrl]
<table id="email-footer" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
        <tr>
            <td>
                <p><small>This message was sent by <a href="${baseUrl}">Atlassian Bamboo</a>[#-- ${appProperties.getVersion()}-${appProperties.getBuildNumber()}--].</small></p>
                <p><small>If you wish to stop receiving these emails edit your <a href="${baseUrl}/profile/userNotifications.action">user profile</a> or <a href="${baseUrl}/viewAdministrators.action">notify your administrator</a>.</small></p>
            </td>
        </tr>
    </tbody>
</table>
[/#macro]

[#-- ==================================================================================== @nc.atlassianEmailTemplate --]
[#macro atlassianEmailTemplate baseUrl headline]
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Atlassian</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <style type="text/css">
        /* CLIENT-SPECIFIC STYLES */
        #outlook a{padding:0;} /* Force Outlook to provide a "view in browser" message */
        .ReadMsgBody{width:100%;} .ExternalClass{width:100%;} /* Force Hotmail to display emails at full width */
        .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;} /* Force Hotmail to display normal line spacing */
        body, table, td, a{-webkit-text-size-adjust:100%; -ms-text-size-adjust:100%;} /* Prevent WebKit and Windows mobile changing default text sizes */
        table, td{mso-table-lspace:0pt; mso-table-rspace:0pt;} /* Remove spacing between tables in Outlook 2007 and up */
        img{-ms-interpolation-mode:bicubic;} /* Allow smoother rendering of resized image in Internet Explorer */
        /* RESET STYLES */
        body{margin:0; padding:0;}
        img{border:0; height:auto; line-height:100%; outline:none; text-decoration:none;}
        table{border-collapse:collapse !important;}
        body{height:100% !important; margin:0; padding:0; width:100% !important;}
        /* iOS BLUE LINKS */
        .appleBody a {color:#68440a; text-decoration: none;}
        .appleFooter a {color:#999999; text-decoration: none;}
        /* MOBILE STYLES */
        @media screen and (max-width: 480px) {
            .table_shrink {
                width:95% !important;
            }
        }
    </style>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#ffffff" class="table_shrink" align="center">
    <tr>
        <td>
            <!-- start body module -->
            <table width="520px" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" class="table_shrink"  align="center">
                <!-- start logo -->
                <tr valign="top">
                    <td align="top" style="padding-top:20px;" align="left"><a href="http://www.atlassian.com" alias="atlassian header logo"><img src="http://image.mailer.atlassian.com/lib/fec2157377620c74/m/3/logo-email-header.png" height="24" width="110" border="0" alt="Atlassian" style="display:block; color:#3572b0;"></a></td>
                </tr>
                <!-- end logo -->
                <!-- start hr -->
                <tr>
                    <td style="color:#cccccc; padding-top: 20px;" valign="top">
                        <hr color="cccccc" size="1">
                    </td>
                </tr>
                <!-- end hr -->
                <!-- start headline -->
                <tr>
                    <td valign="top" style="padding-top: 20px; font-family:Helvetica neue, Helvetica, Arial, Verdana, sans-serif; color: #205081; font-size: 20px; line-height: 32px; text-align:left; font-weight:bold;" align="left">
                    ${headline}
                    </td>
                </tr>
                <!-- end headline -->
                <!-- start content -->
                <tr>
                    <td valign="top" style="padding-top: 20px; padding-bottom: 20px; font-family: Helvetica, Helvetica neue, Arial, Verdana, sans-serif; color: #333333; font-size: 14px; line-height: 20px; text-align:left; font-weight:none;" align="left">
                        [#nested]
                    </td>
                </tr>
                <!-- end content -->
            </table>
            <!-- end body module -->
        </td>
    </tr>
    <tr>
        <td>
            <!-- start footer module -->
            <table width="520" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" class="table_shrink" align="center">
                <tr>
                    <td style="color:#cccccc;" valign="top">
                        <hr color="cccccc" size="1">
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="padding-top: 30px; font-family: Helvetica, Helvetica neue, Arial, Verdana, sans-serif; color: #707070; font-size: 12px; line-height: 18px; text-align:center; font-weight:none;" align="center">
                        This message was sent by <a style="text-decoration:none; color: #444;" href="${baseUrl}">Atlassian Bamboo</a>.
                        If you wish to stop receiving these emails edit your <a style="text-decoration:none; color: #444;" href="${baseUrl}/profile/userNotifications.action">user profile</a>
                        or <a style="text-decoration:none; color: #444;" href="${baseUrl}/viewAdministrators.action">notify your administrator</a>.
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="padding-top: 10px; font-family: Helvetica, Helvetica neue, Arial, Verdana, sans-serif; color: #707070; font-size: 12px; line-height: 18px; text-align:center; font-weight:none;" align="center">
                        Copyright 2006-${buildUtils.getCurrentBuildYear()} Atlassian Pty Ltd. All rights reserved.
                        We are located at 341 George Street, Sydney, NSW, 2000, Australia
                    </td>
                </tr>
                <tr valign="top">
                    <td align="center" style="padding-top: 20px; padding-bottom: 30px;">
                        <a href="http://www.atlassian.com" alias="atlassian footer logo"><img src="http://image.mailer.atlassian.com/lib/fec2157377620c74/m/3/logo-email-footer.png" height="20" width="91" border="0" alt="Atlassian" style="display:block; color:#3572b0;"></a>
                    </td>
                </tr>
            </table>
            <!-- end footer module -->
        </td>
    </tr>
</table>
</body>
</html>
[/#macro]
