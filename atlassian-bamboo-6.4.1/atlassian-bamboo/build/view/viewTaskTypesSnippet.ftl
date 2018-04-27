[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ViewBuildTaskTypes" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ViewBuildTaskTypes" --]
<meta name="decorator" content="main"/>

[#import "/feature/task/taskConfigurationCommon.ftl" as tc/]
[@ww.url var="taskSelectionUrl" action="addTask" namespace="/build/admin/edit" planKey=planKey returnUrl=returnUrl /]

[@tc.taskSelector availableTasks taskSelectionUrl /]
