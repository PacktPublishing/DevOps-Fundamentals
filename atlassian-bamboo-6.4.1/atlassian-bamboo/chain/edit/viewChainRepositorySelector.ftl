[#import "/build/common/repositoryCommon.ftl" as rc]

[@ww.url var="repositorySelectionUrl" action="addRepository" namespace="/chain/admin/config" planKey=planKey /]

[@rc.repositoryTypePicker vcsTypeSelectors=vcsTypeSelectors selectionUrl=repositorySelectionUrl planKey=planKey/]