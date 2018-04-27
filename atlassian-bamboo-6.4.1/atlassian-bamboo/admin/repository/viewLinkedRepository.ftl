[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.ViewLinkedRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.ViewLinkedRepository" --]
[#import "/build/common/repositoryCommon.ftl" as rc]

[#assign viewRepositoryHeaderText]
[@ww.text name="repository.details.title"]
    [@ww.param][#if vcsRepositoryData??]${vcsRepositoryData.name}[/#if][/@ww.param]
[/@ww.text]
[/#assign]

<html>
<head>
[@ui.header page=viewRepositoryHeaderText title=true/]
    <meta name="decorator" content="focusTask">
</head>
<body>
<h2>
    ${viewRepositoryHeaderText}
</h2>

[@ww.form action="viewAllRepositories"
    method='GET'
    namespace="/vcs"
    submitLabelKey="global.buttons.close"]
    [#if vcsTypeSelector??]
        [@rc.displayLinkedRepository vcsTypeSelector=vcsTypeSelector plan="" /]
    [/#if]
[/@ww.form]
<body>
