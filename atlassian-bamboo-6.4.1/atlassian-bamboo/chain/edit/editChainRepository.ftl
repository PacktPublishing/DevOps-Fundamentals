[#import "editChainConfigurationCommon.ftl" as eccc/]
[@s.text var="repositoryDescription" name="repositories.title"]
    [@s.param]<a href="[@s.url action="editChainDetails" namespace="/chain/admin/config" planKey=planKey /]">[/@s.param]
    [@s.param]</a>[/@s.param]
[/@s.text]

[@eccc.editChainConfigurationPage description=repositoryDescription plan=immutablePlan selectedTab='repository' titleKey='repository.title']
    [#include "/build/common/configureChangeDetectionRepository.ftl"]
[/@eccc.editChainConfigurationPage]
