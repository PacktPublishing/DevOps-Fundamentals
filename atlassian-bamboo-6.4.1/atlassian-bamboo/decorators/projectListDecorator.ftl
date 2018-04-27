[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader
    requireResourcesForContext=["atl.general"]
    requireResources=['bamboo.web.resources.common:page-projects'] /]

[#assign headerMainContent]
<h1>[@s.text name='dashboard.projects.page.header' /]</h1>
[/#assign]

[#assign pageSidebarContent]
    [@sidebarMessage
        title="${i18n.getText('dashboard.projects.welcomemat.using.bamboo')}"
        content="${i18n.getText('dashboard.projects.welcomemat.using.bamboo.text')}"
        link="${ctx.helpLink.getUrl('dashboard.projects.projects.welcomemat.using.bamboo')}"]
    [/@sidebarMessage]
    [@sidebarMessage
        title="${i18n.getText('dashboard.projects.welcomemat.best.practice')}"
        content="${i18n.getText('dashboard.projects.welcomemat.best.practice.text')}"
        link="${ctx.helpLink.getUrl('dashboard.projects.projects.welcomemat.best.practice')}"]
    [/@sidebarMessage]
    [@sidebarMessage
        title="${i18n.getText('dashboard.projects.welcomemat.bamboo.faq')}"
        content="${i18n.getText('dashboard.projects.welcomemat.bamboo.faq.text')}"
        link="${ctx.helpLink.getUrl('dashboard.projects.projects.welcomemat.faq')}"]
    [/@sidebarMessage]
[/#assign]

${soy.render("bamboo.layout.base", {
    "headerMainContent": headerMainContent,
    "content": body,
    "pageSidebarContent": pageSidebarContent,
    "pageSidebarClass": 'welcomeMat'
})}

[#include "/fragments/decorator/footer.ftl"]


[#macro sidebarMessage title content link]
<div class="welcomeMat-sidebar">
    <h3>
        <a class="welcomeMat-sidebar_link" href="${link}"
           data-bamboo-analytics-event='{"name": "bamboo.project.welcome.mat.link.used"}'>${title}</a>
    </h3>
    <p>
    ${content}
    </p>
</div>
[/#macro]