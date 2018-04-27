[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthor" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthor" --]
[#import "/fragments/buildResults/displayAuthorBuildsTable.ftl" as buildList]

<html>
<head>
    [@ui.header pageKey='author.view.profile' object=author.name title=true /]
</head>

<body>
    [@ui.header pageKey='author.view.summary' object=author.name headerElement='h2' /]


    [@dj.tabContainer headingKeys=['author.view.tabs.builds.summary', 'author.view.tabs.last.10.builds', 'author.view.tabs.last.10.broken', 'author.view.tabs.last.10.fixed']
                      selectedTab='${selectedTab!}']

        [@dj.contentPane labelKey='author.view.tabs.builds.summary']
            [@cp.displayAuthorSummary author=author /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='author.view.tabs.last.10.builds']
            [@buildList.displayAuthorBuildsTable buildResults=author.triggeredBuildResults totalBuildNumber=author.numberOfTriggeredBuilds /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='author.view.tabs.last.10.broken']
            [@buildList.displayAuthorBuildsTable buildResults=author.breakages totalBuildNumber=author.numberOfBreakages /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='author.view.tabs.last.10.fixed']
            [@buildList.displayAuthorBuildsTable buildResults=author.fixes totalBuildNumber=author.numberOfFixes /]
        [/@dj.contentPane]

    [/@dj.tabContainer ]

</body>
</html>