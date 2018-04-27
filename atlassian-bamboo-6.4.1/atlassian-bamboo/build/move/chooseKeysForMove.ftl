[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
<html>
<head>
    <title>[@s.text name='build.move.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="moveBuilds">
</head>
<body>

[#assign chooseKeysToMoveDescription]
    [@s.text name='build.move.configure.description']
        [@s.param]${selectedProject.name?html}[/@s.param]
    [/@s.text]
[/#assign]
[#if selectedPlans?has_content]
    [@s.form action="moveBuilds" namespace="/admin"
              cancelUri='/admin/chooseBuildsToMove.action'
              submitLabelKey='global.buttons.move'
              description=chooseKeysToMoveDescription
              titleKey='build.move.configure.form.title']
        [@s.hidden name='projectKey' theme='simple' /]
        [@s.hidden name='projectName' theme='simple' /]
        [@s.hidden name='projectDescription' theme='simple' /]
        [@s.hidden name='existingProjectKey' theme='simple' /]

        [#if !action.isNewProject(existingProjectKey)]
            [#assign projectPlans = action.getSortedTopLevelPlans(selectedProject)/]
            [#if projectPlans?has_content]
                <p>[@s.text name='build.move.configure.existing' /]</p>
                <ul>
                    [#list projectPlans as chain]
                        <li>${chain.buildName} <i>(${chain.buildKey})</i></li>
                    [/#list]
                </ul>
            [/#if]
        [/#if]  

        <table class="aui">
            <thead>
                <tr>
                    <th>Original Project</th>
                    <th>Original Name</th>
                    <th>New Name</th>
                    <th>Original Key</th>
                    <th>New Key</th>
                </tr>
            </thead>
            <tbody>
            [#list selectedPlans as plan]
                <tr>
                    <td>
                        ${plan.project.name}<br><i>(${plan.project.key})</i>
                    </td>
                    <td>
                        ${plan.buildName}
                    </td>
                    <td>
                        [@s.hidden name='planIds' value='${plan.id}' theme='simple' /]
                        [@s.textfield name='planNameMappings[${plan.id}]' theme='inline'/]
                    </td>
                    <td>${plan.buildKey}</td>
                    <td>
                        [@s.textfield name='planKeyMappings[${plan.id}]' theme='inline'/]
                    </td>
                </tr>
            [/#list]
            </tbody>
        </table>
    [/@s.form]
[#else]
    [@s.text name='build.move.plans.none' /]
[/#if]
        