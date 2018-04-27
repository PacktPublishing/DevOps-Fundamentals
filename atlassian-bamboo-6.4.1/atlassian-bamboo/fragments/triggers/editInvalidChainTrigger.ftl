[#-- @ftlvariable name="planKey" type="java.lang.String" --]
[#-- @ftlvariable name="submitAction" type="java.lang.String" --]

[#import "/feature/triggers/triggersEditCommon.ftl" as tcc/]
[#assign showDeleteButton=(submitAction=="updateChainTrigger")/]
[@ww.url var="deleteUrl" action="confirmDeleteChainTrigger" namespace="/chain/admin/config" planKey=planKey triggerId=triggerId /]
[@tcc.invalidTriggerPlugin  showDeleteButton deleteUrl/]
