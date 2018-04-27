[#import "/fragments/decorator/decorators.ftl" as decorators/]
[#import "/fragments/breadCrumbs.ftl" as bc]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "ace.editor"] withHeader=true /]

[#assign headerMainContent]
    [#if project?? && immutablePlan??]
        [@s.url var='projectUrl' value='/browse/${project.key}' /]
        [@s.url var='planUrl' value='/browse/${immutablePlan.key}' /]

        <ol id="breadcrumb" class="aui-nav aui-nav-breadcrumbs">[#t]
                    [@bc.showCrumb link=projectUrl id=project.key text=project.name /]
                    [@bc.showCrumb link=planUrl current=true id=immutablePlan.key text=immutablePlan.buildName /]
        </ol>[#t]

        [#assign configHeaderText]
            [@s.text name="yaml.config.export.view.title"]
                [@s.param]
                ${immutablePlan.buildName}
                [/@s.param]
            [/@s.text]
        [/#assign]
        [@bc.showCrumb link=planUrl current=true id=immutablePlan.key text=configHeaderText tagName="h1"/]
    [#elseif deploymentProject??]
        [@s.url var='allDeploymentProjectsUrl' value='/deploy/viewAllDeploymentProjects.action' /]
        [@s.url var='deploymentProjectUrl' value='/deploy/viewDeploymentProjectEnvironments.action?id=${deploymentProject.id}' /]

        <ol id="breadcrumb" class="aui-nav aui-nav-breadcrumbs">[#t]
                        [@bc.showCrumb link=allDeploymentProjectsUrl text=i18n.getText("deployment.breadcrumb.allProjects") /]
                        [@bc.showCrumb link=deploymentProjectUrl current=true text=deploymentProject.name /]
        </ol>[#t]
        [#assign configHeaderText]
            [@s.text name="yaml.config.export.view.title"]
                [@s.param]
                ${deploymentProject.name}
                [/@s.param]
            [/@s.text]
        [/#assign]
        <h1>${configHeaderText}</h1>
    [/#if]
[/#assign]

${soy.render("bamboo.layout.base", {
    "headerMainContent": headerMainContent!,
    "content": body
})}

[#include "/fragments/decorator/minimalFooter.ftl"]


