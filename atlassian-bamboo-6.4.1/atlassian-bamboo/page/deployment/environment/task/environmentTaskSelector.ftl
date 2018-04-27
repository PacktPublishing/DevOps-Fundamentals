[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ViewEnvironmentTaskTypes" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ViewEnvironmentTaskTypes" --]

[#import "/feature/task/taskConfigurationCommon.ftl" as tc/]

[@ww.url var="taskSelectionUrl" action="addEnvironmentTask" namespace="/deploy/config" environmentId=environmentId returnUrl=returnUrl /]
[@tc.taskSelector availableTasks taskSelectionUrl /]
