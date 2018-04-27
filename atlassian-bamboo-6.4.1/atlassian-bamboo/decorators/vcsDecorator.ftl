[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.ViewAllRepositories" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.ViewAllRepositories" --]
[#import "/fragments/decorator/decorators.ftl" as decorators/]
[#import "/lib/menus.ftl" as menu/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "atl.dashboard"] activeNavKey="dashboard" /]

[#assign headerContent]
<h1 id="dashboard-instance-name">[@s.text name="menu.vcs"/]</h1>
[/#assign]

${soy.render("bamboo.layout.base", {
"instanceName": instanceName?html,
"headerMainContent": headerContent,
"content": body
})}
[#include "/fragments/decorator/footer.ftl"]