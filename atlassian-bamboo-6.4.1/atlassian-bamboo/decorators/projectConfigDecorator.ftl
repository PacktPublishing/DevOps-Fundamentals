[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.ProjectActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.ProjectActionSupport" --]

[#import '/fragments/breadCrumbs.ftl' as bc]
[#import '/fragments/decorator/decorators.ftl' as decorators/]
[#import "/lib/menus.ftl" as menu]

[@decorators.displayHtmlHeader requireResourcesForContext=['atl.general', 'bamboo.configuration'] /]

[#assign headerImageContent]
    [@bc.showBreadcrumbsIcon project!{} /]
[/#assign]

[#if project??]

    [#assign headerMainContent]
        [#-- breadcrumbs for project configuration --]
        [@s.url var='projectUrl' value='/browse/${project.key}' /]
        [@bc.showCrumbContainer]
            [@bc.showCrumb link=projectUrl id=project.key text=project.name /]
        [/@bc.showCrumbContainer]

        [@s.url var='configUrl' namespace='/project/admin/config' action='editProjectDetails' projectKey=project.key /]
        [#assign configHeaderText]
            [@s.text name='project.configuration.breadcrumbs.header']
                [@s.param]${project.name}[/@s.param]
            [/@s.text]
        [/#assign]
        [@bc.showCrumb link=configUrl current=true text=configHeaderText tagName='h1' /]
    [/#assign]

    [#assign headerActionsContent]
        [#if fn.hasEntityPermission('ADMINISTRATION', project) ]
            [@menu.displayProjectDeleteLink
            projectKey=project.key
            projectWithPlans=projectWithPlans
            labelKey='project.delete.title'
            confirmMessage=action.getTextWithArgs('project.delete.confirm', project.name)
            redirectUrl='${req.contextPath}/allProjects.action'
            tooltipLabel='project.delete.plans.not.empty.tooltip'
            /]
        [/#if]
    [/#assign]
    [#assign pageNavContent]
        [#-- crumb from page meta tags to highlight currently active page link --]
        [#assign projectCrumb = page.getProperty('meta.projectCrumb')!'' /]

        [#-- helper macros to define navigation panel --]
        [#macro navSection labelKey='']
            [#if labelKey??]
                <div class="aui-nav-heading"><strong>[@s.text name=labelKey /]</strong></div>
            [/#if]
            <ul class="aui-nav">
                [#nested]
            </ul>
        [/#macro]

        [#macro navItem id labelKey link target=""]
            <li class="${(projectCrumb == id)?then('aui-nav-selected', '')}">
                <a id="${id}" href="${link?html}" [#if target?has_content]target="${target}"[/#if]>[@s.text name=labelKey /]</a>
            </li>
        [/#macro]

        [#-- navigation sidebar --]
        <nav id="project-config-menu" class="aui-navgroup aui-navgroup-vertical">
            <div class="aui-navgroup-inner">
                [@navSection]
                    [@s.url var='projectDetailsUrl' value='/project/admin/config/editProjectDetails.action' projectKey=projectKey /]
                    [@navItem id='project.details' labelKey='project.configuration.nav.element.project.details' link=projectDetailsUrl /]
                [/@navSection]

                [@navSection labelKey='project.configuration.nav.section.security']
                    [@s.url var='projectPermissionsUrl' value='/project/admin/config/editProjectPermissions.action' projectKey=projectKey /]
                    [@navItem id='project.permissions' labelKey='project.configuration.nav.element.project.permissions' link=projectPermissionsUrl /]

                    [@s.url var='planPermissionsUrl' value='/project/admin/config/editPlanPermissions.action' projectKey=projectKey /]
                    [@navItem id='plan.permissions' labelKey='project.configuration.nav.element.plan.permissions.inheritance' link=planPermissionsUrl /]

                    [#if featureManager.repositoryStoredSpecsEnabled]
                        [@s.url var='projectSpecsRepositoriesUrl' value='/project/admin/config/editProjectSpecsRepositories.action' projectKey=projectKey /]
                        [@navItem id='project.repositories' labelKey='project.configuration.nav.element.project.repositories' link=projectSpecsRepositoriesUrl /]
                    [/#if]
                [/@navSection]

                [@navSection labelKey='project.configuration.nav.section.addons']
                    [@s.url var='applicationLinksUrl' value='/plugins/servlet/applinks/listEntityLinks/com.atlassian.applinks.api.application.bamboo.BambooProjectEntityType/' + projectKey /]
                    [@navItem id='application.links' labelKey='project.configuration.nav.element.application.links' link=applicationLinksUrl target="_blank" /]
                [/@navSection]
            </div>
        </nav>
    [/#assign]

    [#assign mainContent]
        ${body}
    [/#assign]

[#else]

    [#assign headerMainContent]
        [#-- limited breadcrumbs (without project name) --]
        [@bc.showCrumbContainer /]
        [#assign configHeaderText]
            [@s.text name='build.configuration.title']
                [@s.param][@s.text name='project' /][/@s.param]
            [/@s.text]
        [/#assign]
        [@bc.showCrumb link=currentUrl current=true text=configHeaderText tagName='h1' /]
    [/#assign]

    [#assign headerActionsContent]
    [/#assign]

    [#assign pageNavContent]
    [/#assign]

    [#assign mainContent]
        [#list actionErrors as actionError]
            ${soy.render('aui.message.error', { 'content': actionError?html })}
        [/#list]
    [/#assign]

[/#if]

${soy.render('bamboo.layout.base', {
    'headerImageContent': headerImageContent,
    'headerMainContent': headerMainContent,
    'headerActionsContent': headerActionsContent,
    'pageNavContent': pageNavContent,
    'content': mainContent
})}

[#include '/fragments/decorator/footer.ftl']
