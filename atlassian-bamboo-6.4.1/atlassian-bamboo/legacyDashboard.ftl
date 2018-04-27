[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
</head>
<body>

<h1 id="legacy-dashboard-title"">${instanceName?html}</h1>

[#import "/fragments/plan/displayBuildSummaries.ftl" as planList]
[@planList.displayBuildSummaries builds=plans /]

<!-- Simple queue view -->
<div id="queues">
    <div>
        <div id="buildQueueDiv" class="queue">
            <h3>
            [@ww.text name='queue.heading' /]
            </h3>
            <ol>
            [#if queue?has_content]
                [#list queue as queuedResultKey]
                    [#if fn.hasPlanPermission('READ', queuedResultKey.resultKey.entityKey.key) ]
                        <li class="queueItem">
                        ${queuedResultKey_index+1}. <a id="viewBuild:${queuedResultKey.resultKey.entityKey}:queue" href="${req.contextPath}/browse/${queuedResultKey.resultKey}">${queuedResultKey.resultKey}</a>
                            <div class="clearer"></div>
                        </li>
                    [#else]
                        <li>
                        ${queuedResultKey_index+1}. [@ww.text name='queue.hidden.build.waiting'/]
                            <p class="queueStatus">
                                [@ww.text name='queue.hidden.build.status' /]
                            </p>
                        </li>
                    [/#if]
                [/#list]
            [#else]
                <li>
                    [@ww.text name='queue.empty' /]
                </li>
            [/#if]
            </ol>
        </div>
    </div>
[@ui.clear /]
</div> <!-- END #queues -->

</body>
</html>
