[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.RenameAgentCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.RenameAgentCapability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@s.text name='agent.capability.rename' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="agentsConfig">
</head>

<body>
    [@s.form
              action='updateRenamedCapability'
              namespace='/admin/agent'
              titleKey='agent.capability.rename'
              descriptionKey='agent.capability.rename.description'
              submitLabelKey='agent.capability.rename'
              cancelUri='/admin/agent/viewCapabilityKey.action?capabilityKey=${capabilityKey}' ]

        [@s.hidden name='capabilityKey' /]
        [@s.hidden name='newCapabilityLabel' /]
        [@s.hidden name='returnUrl' /]

        [#assign typeText = action.getText('agent.capability.type.${capabilityType}.title') /]
        [@s.label labelKey='agent.capability.type' value="${typeText}" /]

        [@s.label labelKey='agent.capability.type.${capabilityType}.key.old' name='capability.label' /]
        [@s.label labelKey='agent.capability.type.${capabilityType}.key.new' name='newCapabilityLabel' /]

        [@s.radio labelKey='agent.capability.rename.override'
               name='overrideValue'
               listKey='name' listValue='label'
               list=overrideOptions ]
        [/@s.radio]

        [#if capabilityDeltaMap?has_content]

        [@ui.bambooSection titleKey='agent.capability.rename.conflict.agent']
            <table class="aui capabilities">
                <thead>
                    <tr>
                        <th class="agentCell labelPrefixCell">
                            [@s.text name='agent.table.heading.name' /]
                        </th>
                        <th class="valueCell">
                            [@s.text name='agent.capability.type.${capabilityType}.value.old' ]
                                [@s.param]${capability.label?html}[/@s.param]
                            [/@s.text]
                        </th>
                        <th class="valueCell">
                            [@s.text name='agent.capability.type.${capabilityType}.value.new' ]
                                [@s.param]${newCapabilityLabel?html}[/@s.param]
                            [/@s.text]
                        </th>
                    </tr>
                </thead>
            [#list capabilityDeltaMap.entrySet() as entry]
                [#assign pipelineDefinition = entry.key /]
                [#assign oldCapability =  entry.value.oldCapability /]
                [#assign newCapability =  entry.value.newCapability /]

                <tr>
                    <td class="agentCell labelPrefixCell">
                        [#assign sharedCapabilitySetType = (oldCapability.capabilitySet.sharedCapabilitySetType)!("") /]
                        [#if sharedCapabilitySetType?has_content]
                            <a href="[@s.url action='configureShared${sharedCapabilitySetType}Capabilities' namespace='/admin/agent' /]">[@s.text name='agent.capability.agents.all.${sharedCapabilitySetType}' /]</a>
                        [#else]
                            [#if pipelineDefinition?has_content]
                                <a href="[@s.url action='viewAgent' namespace='/admin/agent' agentId=pipelineDefinition.id /]">${pipelineDefinition.name?html}</a>
                            [/#if]
                        [/#if]
                    </td>
                    <td class="valueCell">
                        ${oldCapability.value!?html}
                    </td>
                    <td class="valueCell">
                        ${newCapability.value!?html}
                    </td>
                </tr>
            [/#list]
            </table>
        [/@ui.bambooSection]

        [/#if]

        [#if requirementPlanDeltaMap?has_content]
        [@ui.bambooSection titleKey='agent.capability.rename.conflict.plans']
            <table class="aui requirements">
                <thead>
                    <tr>
                        <th class="planCell labelPrefixCell">
                            [@s.text name='plan.title' /]
                        </th>
                        <th class="valueCell">
                            [@s.text name='agent.capability.type.${capabilityType}.value.old' ]
                                [@s.param]${capability.label?html}[/@s.param]
                            [/@s.text]
                        </th>
                        <th class="valueCell">
                            [@s.text name='agent.capability.type.${capabilityType}.value.new' ]
                                [@s.param]${newCapabilityLabel?html}[/@s.param]
                            [/@s.text]
                        </th>
                    </tr>
                </thead>
            [#list requirementPlanDeltaMap.entrySet() as entry]
                [#assign build = entry.key /]
                [#assign oldRequirement =  entry.value.oldRequirement /]
                [#assign newRequirement =  entry.value.newRequirement /]

                <tr>
                    <td class="planCell labelPrefixCell">
                        <a title="${build.key}" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${build.key}">${build.name?html}</a>
                    </td>
                    [@agt.shoRequirementCell requirement=oldRequirement /]
                    [@agt.shoRequirementCell requirement=newRequirement /]

                </tr>
            [/#list]
            </table>
        [/@ui.bambooSection]

        [/#if]
        [#if requirementEnvironmentDeltaMap?has_content]
            [@ui.bambooSection titleKey='agent.capability.rename.conflict.environments']
            <table class="aui requirements">
                <thead>
                <tr>
                    <th class="planCell labelPrefixCell">
                        [@s.text name='deployment.environment.name' /]
                    </th>
                    <th class="valueCell">
                        [@s.text name='agent.capability.type.${capabilityType}.value.old' ]
                                [@s.param]${capability.label?html}[/@s.param]
                            [/@s.text]
                    </th>
                    <th class="valueCell">
                        [@s.text name='agent.capability.type.${capabilityType}.value.new' ]
                                [@s.param]${newCapabilityLabel?html}[/@s.param]
                            [/@s.text]
                    </th>
                </tr>
                </thead>
                [#list requirementEnvironmentDeltaMap.entrySet() as entry]
                    [#assign environment = entry.key /]
                    [#assign oldRequirement =  entry.value.oldRequirement /]
                    [#assign newRequirement =  entry.value.newRequirement /]

                    <tr>
                        <td class="planCell labelPrefixCell">
                            <a title="${environment.name?html}" href="${req.contextPath}/deploy/config/configureEnvironmentAgents.action?environmentId=${environment.id}">${environment.name?html}</a>
                        </td>
                        [@agt.shoRequirementCell requirement=oldRequirement /]
                        [@agt.shoRequirementCell requirement=newRequirement /]

                    </tr>
                [/#list]
            </table>
            [/@ui.bambooSection]
        [/#if]
    [/@s.form]
</body>
</html>