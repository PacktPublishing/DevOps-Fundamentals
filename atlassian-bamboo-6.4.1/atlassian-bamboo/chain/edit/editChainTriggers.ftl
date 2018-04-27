[#import "editChainConfigurationCommon.ftl" as eccc/]
[#import "/feature/triggers/triggersEditCommon.ftl" as triggers/]

[#assign triggersToolbar]
[@help.url pageKey="plan.triggers.howtheywork"][@ww.text name="plan.triggers.howtheywork.title"/][/@help.url]
[/#assign]

[@eccc.editChainConfigurationPage descriptionKey="chain.triggers.description" plan=immutablePlan selectedTab='triggers' titleKey='chain.triggers' tools=triggersToolbar]

    [@ww.url var="triggerSelectorUrl" action="viewTriggerTypes" namespace="/chain/admin/config" planKey=planKey/]
    [@ww.url var="editChainTriggerUrl" action="editChainTrigger" namespace="/chain/admin/config" planKey=planKey/]
    [@ww.url var="confirmDeleteChainTriggerUrl" action="confirmDeleteChainTrigger" namespace="/chain/admin/config" planKey=planKey /]
    [@ww.url var="addChainTriggerUrl" action="addChainTrigger" namespace="/chain/admin/config" planKey=planKey returnUrl=currentUrl /]

    [@triggers.triggersMainPanel triggers=chainTriggers triggerSelectorUrl=triggerSelectorUrl addTriggerUrl=addChainTriggerUrl editTriggerUrl=editChainTriggerUrl confirmDeleteTriggerUrl=confirmDeleteChainTriggerUrl/]

[/@eccc.editChainConfigurationPage]



