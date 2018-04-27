[#import "/feature/task/taskConfigurationCommon.ftl" as tcc/]
[#assign showDeleteButton=(submitAction=="updateEnvironmentTask")/]
[@ww.url var="deleteUrl" action="confirmDeleteEnvironmentTask" namespace="/deploy/config" environmentId=environmentId taskId=taskId /]
[@tcc.invalidTaskPlugin  showDeleteButton deleteUrl/]