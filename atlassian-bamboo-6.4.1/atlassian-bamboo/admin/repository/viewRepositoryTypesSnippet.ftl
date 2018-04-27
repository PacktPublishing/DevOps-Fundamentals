<html>
<head>
[@ui.header pageKey="menu.vcs" title=true/]
<meta name="decorator" content="focusTask"/>
</head>
<body>
[#import "/build/common/repositoryCommon.ftl" as rc]

[@ww.url var="repositorySelectionUrl" action="addLinkedRepository" namespace="/admin" /]

[@rc.repositoryTypePicker vcsTypeSelectors=vcsTypeSelectors selectionUrl=repositorySelectionUrl /]
</body>
</html>
