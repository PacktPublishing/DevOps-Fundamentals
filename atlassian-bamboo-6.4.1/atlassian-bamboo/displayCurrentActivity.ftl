[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

[#if fn.hasAdminPermission()]
    [@ww.url var='viewAgentsUrl' action='viewAgents' namespace='/admin/agent' /]
[#else]
    [@ww.url var='viewAgentsUrl' action='viewAgents' namespace='/agent' /]
[/#if]

<div class="aui-group">
    <div id="currentActivity" class="aui-item">
        <div id="building" class="buildContainer">
            <h2>
                Building
                <a href="${viewAgentsUrl}" id="manageAgents"></a>[#lt]
            </h2>
        </div>
        <div id="queue" class="buildContainer">
            <h2>Queue</h2>
        </div>
        [#include "/fragments/showSystemErrors.ftl"]
    </div>
    <div id="recently-built" class="aui-item">
        <h2>Recently Built</h2>
        [#include "/activityStream.ftl"]
    </div>
</div>

[#-- Current Activity Setup --]
[@ww.url var='getBuildsUrl' namespace='/build/admin/ajax' action='getDashboardSummary' /]
[@ww.url var='viewAgentUrl' namespace='/admin/agent' action='viewAgent' /]
[@ww.url var='reorderBuildUrl' namespace='/build/admin/ajax' action='reorderBuild' /]
[@ww.url var='stopBuildUrl' namespace='/build/admin/ajax' action='stopPlan' /]
[@ww.url var='stopDeploymentUrl' namespace='/deploy' action='stopDeployment' /]
[@ww.url var='manageElasticInstancesUrl' namespace='/admin/elastic' action='manageElasticInstances' /]
[@ww.text var='emptyQueueText' name='queue.empty' /]
[@ww.text var='emptyBuildingText' name='buildResult.completedBuilds.noBuilds' /]
[@ww.text var='cancellingBuildText' name='agent.build.cancelling' /]
[@ww.text var='cancelBuildText' name='agent.build.cancel' /]
[@ww.text var='queueOutOfDateText' name="queue.reorder.outofdate"]
    [@ww.param]${req.contextPath}[/@ww.param]
[/@ww.text]
[@ww.text var='canBuildElasticallyText' name="queue.status.waiting.elastic" /]
[@ww.text var='canBuildElasticallyAdminText' name="queue.status.waiting.elastic.admin" /]
[@ww.text var='fetchingBuildDataText' name="build.currentactivity.fetching" /]
[@ww.text var='cancelDeploymentText' name='agent.deployment.cancel' /]
<script type="text/javascript">
    //<![CDATA[
    var agentSummary;
    AJS.$(function($){
        agentSummary = $("#manageAgents");
        var caOptions = {
            contextPath:                "${req.contextPath}",
            getBuildsUrl:               "${getBuildsUrl}",
            viewAgentUrl:               "${viewAgentUrl}",
            reorderBuildUrl:            "${reorderBuildUrl}",
            stopBuildUrl:               "${stopBuildUrl}",
            stopDeploymentUrl:          "${stopDeploymentUrl}",
            manageElasticInstancesUrl:  "${manageElasticInstancesUrl}",
            emptyQueueText:             "${emptyQueueText?html}",
            emptyBuildingText:          "${emptyBuildingText?html}",
            cancellingBuildText:        "${cancellingBuildText?js_string}",
            cancelBuildText:            "${cancelBuildText?js_string}",
            cancelDeploymentText:       "${cancelDeploymentText?js_string}",
            queueOutOfDateText:         '${queueOutOfDateText?js_string}',
            canBuildElastically:        "${canBuildElasticallyText?js_string}",
            canBuildElasticallyAdmin:   "${canBuildElasticallyAdminText?js_string}",
            fetchingBuildData:          "${fetchingBuildDataText?js_string}",
            hasAdminPermission:         ${fn.hasAdminPermission()?string},
            canManageElasticBamboo:     ${permissionManager.canManageElasticBamboo()?string},
            caParent:                   $("#currentActivity"),
            buildingParent:             $("#building"),
            queueParent:                $("#queue"),
            activityStream:             activityFeed_recentlyBuilt,
            agentSummary:               agentSummary
        };
        CurrentActivity.init(caOptions);
    });

    BAMBOO.reloadDashboard = false;
    //]]>
</script>

[#if fn.hasAdminPermission()]
    [#-- Agent Manager Setup --]
    [@ww.url var='getAgentsUrl' namespace='/agent/admin/ajax' action='getAgents' /]
    [@ww.url var='enableAgentUrl' namespace='/agent/admin/ajax' action='enableAgent' /]
    [@ww.url var='disableAgentUrl' namespace='/agent/admin/ajax' action='disableAgent' /]
    [@ww.url var='enableAllAgentsUrl' namespace='/agent/admin/ajax' action='enableAllAgents' /]
    [@ww.url var='disableAllAgentsUrl' namespace='/agent/admin/ajax' action='disableAllAgents' /]
    [@ww.text var='enableAgentText' name='global.buttons.enable' /]
    [@ww.text var='disableAgentText' name='global.buttons.disable' /]
    [@ww.text var='enableAllAgentsText' name='queue.enableAll' /]
    [@ww.text var='disableAllAgentsText' name='queue.disableAll' /]
    [@ww.text var='onlineAgentsText' name='agents.currentactivity.onlineagents' /]
    [@ww.text var='defaultRemoteAgentSummaryText' name='agents.currentactivity.defaultremoteagentsummary' /]
    [#assign dedicatedLozenge][@ui.agentDedicatedLozenge subtle=true/][/#assign]
    <script type="text/javascript">
        //<![CDATA[
        AJS.$(function(){
            var amOptions = {
                contextPath:                    "${req.contextPath}",
                getAgentsUrl:                   "${getAgentsUrl}",
                enableAgentUrl:                 "${enableAgentUrl}",
                disableAgentUrl:                "${disableAgentUrl}",
                enableAllAgentsUrl:             "${enableAllAgentsUrl}",
                disableAllAgentsUrl:            "${disableAllAgentsUrl}",
                viewAgentUrl:                   "${viewAgentUrl}",
                enableAgentText:                "${enableAgentText?js_string}",
                disableAgentText:               "${disableAgentText?js_string}",
                enableAllAgentsText:            "${enableAllAgentsText?js_string}",
                disableAllAgentsText:           "${disableAllAgentsText?js_string}",
                onlineAgentsText:               "${onlineAgentsText?js_string}",
                defaultRemoteAgentSummaryText:  "${defaultRemoteAgentSummaryText?js_string}",
                onlineOnly:                     true,
                includeRemoteAgentSummary:      true,
                triggerId:                      agentSummary.attr("id"),
                dedicatedLozenge:               "${dedicatedLozenge?js_string}"
            };
            AgentManager.init(amOptions);
        });
        //]]>
    </script>
[/#if]