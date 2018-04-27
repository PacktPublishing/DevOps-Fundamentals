[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionJiraIssues" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionJiraIssues" --]
[#import "deploymentComparisonVersionPicker.ftl" as dcvp/]
[#import "../../../plugins/jira-plugin/viewJiraIssueComponents.ftl" as jiraComponents /]

<html>
<head>
    <meta name="decorator" content="deploymentVersionDecorator"/>
    <meta name="tab" content="issues"/>
    [@s.text var='headerText' name='deployment.version.header'][@s.param]${deploymentVersion.name?html}[/@s.param][/@s.text]
    [@ui.header title=true object=deploymentProject.name page=headerText /]
</head>
<body>
    <h2 id="jiraIssuesHeader">[@ww.text name='deployment.version.jiraIssues.title' /]</h2>
    <p>[@ww.text name='deployment.version.jiraIssues.description' ][@ww.param][@help.href pageKey="integration.atlassian"/][/@ww.param][/@ww.text]</p>
    <p>[@ww.text name='deployment.version.sameBranchesInfo'/]</p>

    [#if hasVersionsToCompare!false]
        [@dcvp.deploymentComparisonVersionPicker "viewDeploymentVersionJiraIssues" deploymentProject deploymentVersion planResultKey compareWithVersion/]
    [/#if]

    [#if oauthAuthenticationRequired]
        [@cp.oauthAuthenticationRequest oauthLoginDanceUrl/]
    [#else]
        [@jiraComponents.displayJiraIssueList issues=pager.page.list totalSize=pager.totalSize resultsSummary='' heading='Related issues' showOperations=false showRelated=false showCaption=false/]
    [/#if]
</body>
</html>
