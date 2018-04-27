[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#-- @ftlvariable name="planKey" type="java.lang.String" --]
[#import "/feature/task/taskConfigurationCommon.ftl" as tcc/]

[@ww.url var="taskSelectorUrl" action="viewTaskTypes" namespace="/build/admin/edit" planKey=planKey returnUrl=currentUrl /]
[@ww.url var="agentAvailabilityUrl" action="showAgentNumbers" namespace="/ajax" planKey=immutablePlan.key /]
[@ww.url var="editTaskUrl" action="editTask" namespace="/build/admin/edit" planKey=planKey /]
[@ww.url var="deleteTaskUrl" action="confirmDeleteTask" namespace="/build/admin/edit" planKey=planKey /]
[@ww.url var="moveTaskUrl" action="moveTask" namespace="/build/admin/ajax" planKey=planKey /]
[@ww.url var="moveFinalBarUrl" action="moveFinalBar" namespace="/build/admin/ajax" planKey=planKey /]

[@tcc.editTasksCommon taskSelectorUrl agentAvailabilityUrl editTaskUrl deleteTaskUrl moveTaskUrl moveFinalBarUrl/]
