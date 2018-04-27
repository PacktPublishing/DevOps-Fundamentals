[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#-- @ftlvariable name="immutableBuild" type="com.atlassian.bamboo.plan.cache.ImmutableBuildable" --]

[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu/]
[#import "/fragments/breadCrumbs.ftl" as bc]
[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/showAdminErrors.ftl"]

[#if project?? || immutablePlan?? || (immutableBuild?? && immutableBuild.description?has_content)]
    [#assign headerImageContent]
        [@bc.showBreadcrumbsIcon (immutableBuild!immutablePlan)!project /]
    [/#assign]

    [#assign headerMainContent]
        [@ww.url var='projectUrl' value='/browse/${project.key}' /]
        [#if immutablePlan??]
            [@bc.showCrumbContainer]
                [@bc.showCrumb link=projectUrl id=project.key text=project.name /]
            [/@bc.showCrumbContainer]
            [#if immutablePlan.parent??]
                [@ww.url var='planUrl' value='/browse/${immutablePlan.parent.key}' /]
                [@bc.showCrumb link=planUrl current=true id=immutablePlan.parent.key text=immutablePlan.parent.buildName tagName='h1' /]
            [#else]
                [@ww.url var='planUrl' value='/browse/${immutablePlan.key}' /]
                [@bc.showCrumb link=planUrl current=true id=immutablePlan.key text=immutablePlan.buildName tagName='h1' /]
            [/#if]
        [#else]
            [@bc.showCrumbContainer /]
            [@bc.showCrumb link=projectUrl current=true id=project.key text=project.name tagName='h1' /]
        [/#if]
    [/#assign]

    [#assign headerActionsButtons]
        [#if project?? && !immutablePlan??]
            ${soy.render("bamboo.layout.projectActions", {
                "projectKey": "${project.key}",
                "hasAdminPermission" : ctx.hasProjectAdminPermission(project)
            })}
        [/#if]
    [/#assign]

    [#assign headerExtraContent]
        [#if immutablePlan??]
            [#if immutablePlan.parent??]
                [#if immutablePlan.parent.linkedJiraIssue?has_content]
                    <div class="plan-description" data-jira-issue-key="${immutablePlan.parent.linkedJiraIssue?html}" data-remote-jira-link-required="${immutablePlan.parent.remoteJiraLinkRequired?string}"></div>
                [#elseif immutablePlan.parent.description?has_content]
                    <div class="plan-description" title="${immutablePlan.parent.description?html}">${immutablePlan.parent.description?html}</div>
                [/#if]
            [#else]
                [#if immutablePlan.linkedJiraIssue?has_content]
                    <div class="plan-description" data-jira-issue-key="${immutablePlan.linkedJiraIssue?html}" data-remote-jira-link-required="${immutablePlan.remoteJiraLinkRequired?string}"></div>
                [#elseif immutablePlan.description?has_content]
                    <div class="plan-description" title="${immutablePlan.description?html}">${immutablePlan.description?html}</div>
                [/#if]
            [/#if]
        [#elseif immutableBuild??]
            [#if immutableBuild.linkedJiraIssue?has_content]
                <div class="plan-description" data-jira-issue-key="${immutableBuild.linkedJiraIssue?html}" data-remote-jira-link-required="${immutableBuild.remoteJiraLinkRequired?string}"></div>
            [#elseif immutableBuild.description?has_content]
                <div class="plan-description" title="${immutableBuild.description?html}">${immutableBuild.description?html}</div>
            [/#if]
        [#elseif project??]
            [#if (project.description!'')?trim?has_content]
                <div class="project-description" title="${project.description?html}">${project.description?html}</div>
            [/#if]
        [/#if]
        [#if immutablePlan??]
            [#import "/fragments/labels/labels.ftl" as lb /]
            [@lb.showLabelEditorForPlan plan=immutablePlan /]
        [/#if]
        [#if (immutablePlan?? && ((immutablePlan.parent)!immutablePlan).linkedJiraIssue?has_content) || (immutableBuild?? && immutableBuild.linkedJiraIssue?has_content)]
            <script type="text/javascript">
                BAMBOO.PLAN.LinkedJiraIssueDescription({
                    planKey: '${(((immutablePlan.parent)!immutablePlan)!immutableBuild).key}'
                });
            </script>
        [/#if]
    [/#assign]
[/#if]

${soy.render("bamboo.layout.base", {
    "headerImageContent": headerImageContent!,
    "headerMainContent": headerMainContent!,
    "headerActionsButtons": headerActionsButtons!,
    "headerExtraContent": headerExtraContent!,
    "content": body
})}

[#if immutablePlan??]
    <a id="editPlanLink" class="hidden" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${immutablePlan.key}" accesskey="E">Edit Plan</a>
    <script type="text/javascript">
        AJS.whenIType("e").followLink("#editPlanLink");
    </script>
[#elseif project??]
    [@s.url var="editProjectLinkUrl" action="editProjectDetails" namespace="/project/admin/config" projectKey=project.key /]
    <a id="editProjectLink" class="hidden" href="${editProjectLinkUrl}" accesskey="E">Edit Project</a>
    <script type="text/javascript">
        AJS.whenIType("e").followLink("#editProjectLink");
    </script>
[/#if]

[#include "/fragments/decorator/footer.ftl"]
