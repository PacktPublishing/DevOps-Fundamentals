[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#import "/templates/plugins/webRepository/defaultCommitView.ftl" as dcv/]
<html>
<head>
	[@ui.header pageKey='buildResult.changes.title' object='${immutablePlan.name} ${resultsSummary.buildNumber}' title=true/]
    <meta name="tab" content="changes"/>
</head>

<body>
    <div id="fullChanges">
        [#if changeUrl??]<a href="${changeUrl}">[/#if][@ui.header pageKey='buildResult.changes.title' /][#if changeUrl??]</a>[/#if]
        [#if action.getSkippedCommitsCount(resultsSummary) gt 0]
            [@ww.text var='buildResultFilesSkipped' name='buildResult.changes.files.skipped' ]
                [@ww.param name="value" value="${resultsSummary.commits?size}"/]
                [@ww.param name="value" value="${resultsSummary.commits?size + action.getSkippedCommitsCount(resultsSummary)}"/]
            [/@ww.text]
            [@ui.messageBox title=buildResultFilesSkipped /]
        [/#if]
        [#assign changesetInformation]
            [#list resultsSummary.repositoryChangesets?sort_by("position") as repositoryChangeset]
                [#assign repositoryDefinition=action.getRepositoryData(repositoryChangeset)/]
                [#assign linkGenerator=action.getRepositoryViewer(repositoryDefinition)!/]
                [#if linkGenerator?has_content]
                    [@dcv.displayChangeSet resultsSummary repositoryDefinition repositoryChangeset linkGenerator/]
                [#else]
                    [@dcv.displayChangeSetWithoutViewer resultsSummary repositoryDefinition repositoryChangeset/]
                [/#if]
            [/#list]
        [/#assign]
        [#if changesetInformation?trim?has_content]
            ${changesetInformation}
        [#else]
            <p>[@ww.text name="buildResult.changes.none" /]</p>
        [/#if]
    </div>
</body>
</html>
