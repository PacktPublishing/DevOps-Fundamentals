[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.ViewProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.ViewProject" --]

[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

<html>
<head>
    [@ui.header pageKey='project.summary.title' object='${project.name}' title=true /]
</head>
<body>

[#if !plans?has_content]
    [#-- empty state --]
    [#assign imageUrl = req.contextPath + '/images/project-plan-empty.svg' /]

    [#if !(user?has_content)]
        [#-- empty state with links to log in or sign up --]
        [@ui.emptyState
                headerKey='project.empty.state.header'
                descriptionKey='project.empty.state.description'
                imageUrl=imageUrl]
            [@s.url var="loginUrl" value="/userlogin!doDefault.action?os_destination=${ctx.getCurrentUrl(req)?url}" /]
            [@s.url var="signupUrl" value="/signupUser!doDefault.action" /]
            <a href="${loginUrl}" class="aui-button aui-button-primary">[@s.text name='bamboo.banner.login' /]</a>[#t]
            <a href="${signupUrl}" class="aui-button">[@s.text name='bamboo.banner.signup' /]</a>[#t]
        [/@ui.emptyState]

    [#elseif ctx.canCreatePlanInProject(project)]
        [#-- empty state with link to create plan --]
        [@ui.emptyState
                headerKey='project.empty.state.header'
                descriptionKey='project.empty.state.description'
                imageUrl=imageUrl]
            [@s.url var="createUrl" value="/build/admin/create/newPlan.action?existingProjectKey=${project.key}" /]
            <a id="createNewPlanLink" href="${createUrl}" class="aui-button aui-button-primary">
                [@s.text name='project.empty.state.create.action.label' /]
            </a>
        [/@ui.emptyState]

    [#else]
        [#-- passive empty state, no action links --]
        [#assign description]
            [@s.text name="project.empty.state.description.passive"]
                [@s.param][@s.text name='permissions.howtheywork'/][/@s.param]
            [/@s.text]
        [/#assign]
        [@ui.emptyState headerKey='project.empty.state.header.passive'
                description=description
                imageUrl=imageUrl]
        [/@ui.emptyState]
    [/#if]

[#else]
    [#-- list of plans --]
    [@planList.displayWideBuildPlansList builds=plans showProject=false/]
[/#if]

[#include "/fragments/showEc2Warning.ftl"]

<script>
    AJS.trigger('analytics',
            {
                name: 'bamboo.page.visited.project',
            }
    );
</script>
</body>
</html>
