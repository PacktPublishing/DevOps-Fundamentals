[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]

[#macro viewCapabilityKey parentUrl mode="tabs" analyticsEvent='']

    [#import "/agent/commonAgentFunctions.ftl" as agt]
    [#if  mode != "tabs"]
        [#assign capabilityTabUrl = "${parentUrl}"/]
    [#else]
        [#assign capabilityTabUrl = "${parentUrl}#${capabilityTabId}"/]
    [/#if]
    <div class="toolbar">
        [#if capabilityType.allowRename && fn.hasGlobalAdminPermission()]
            [#if mode != "tabs"]
                [@ww.url var='renameCapabilityUrl' action='renameCapability' namespace='/admin/agent' capabilityKey=capability.key  /]
            [#else]
                [@ww.url var='renameCapabilityUrl' action='renameCapability' namespace='/admin/agent' capabilityKey=capability.key returnUrl=parentUrl  /]
            [/#if]
            [@cp.displayLinkButton buttonId="rename:${capability.key?html}" buttonLabel="agent.capability.rename" buttonUrl=renameCapabilityUrl /]
        [/#if]
    </div>
    [@ui.header page=capability.label?html descriptionKey='agent.capability.view.description' /]
    [@ui.bambooPanel]
        [#if hasCapabilityConfiguratorPluginForViewPerspective]
            [@ui.bambooSection titleKey="agent.capability.configuration"]
                [#list capabilityConfiguratorPluginViewHtmlList as capabilityConfiguratorHtml]
                ${capabilityConfiguratorHtml}
                [/#list]
            [/@ui.bambooSection]
        [/#if]

    <p>
        [#if hasCapabilityConfiguratorPluginForEditPerspective]
        [@ww.url action='editCapabilityKey' namespace='/admin/agent' capabilityKey=capability.key returnUrl='${capabilityTabUrl}' var='editCapabilityKeyUrl'/]
        [@cp.displayLinkButton buttonId="configure_${capability.key?html}" buttonLabel="agent.capability.configuration.edit" buttonUrl=editCapabilityKeyUrl /]
    [/#if]
    </p>
    [/@ui.bambooPanel]
    [#assign contentId = .now?string.mm_ss_SSSS]
    [#if elasticSupportPossible]
        [#assign headingKeys = ['agent.capability.capabilityAgent', 'agent.capability.capabilityElasticImage', 'agent.capability.jobRequirement', 'agent.capability.deploymentEnvironmentRequirement']]
        [#assign tabIds = ['agents_' + contentId, 'images_' + contentId, 'jobs_' + contentId, 'environments_' + contentId]]
    [#else]
        [#assign headingKeys = ['agent.capability.capabilityAgent', 'agent.capability.jobRequirement', 'agent.capability.deploymentEnvironmentRequirement']]
        [#assign tabIds = ['agents_' + contentId, 'jobs_' + contentId, 'environments_' + contentId]]
    [/#if]
        [@dj.tabContainer headingKeys=headingKeys selectedTab=action.selectedTab! tabViewId='relies_'+contentId tabIds=tabIds analyticsEvent=analyticsEvent]
            [@dj.contentPane labelKey='agent.capability.capabilityAgent' id='agents_' + contentId]
                [#if capabilityAgentMappingsSorted?has_content]
                    <p>[@ww.text name='agent.capability.capabilityAgent.description' /]</p>
                    <table class="aui">
                        <thead>
                        <tr>
                            <th class="agentCell labelPrefixCell">[@ww.text name='agent.table.heading.name' /]</th>
                            <th class="valueCell">[@ww.text name='agent.capability.type.${capabilityType}.value' /]</th>
                            <th class="operations">[@ww.text name='global.heading.operations' /]</th>
                        </tr>
                        </thead>
                        [#list capabilityAgentMappingsSorted as capabilityAgentMapping]
                            [#if capability.label??][#assign capabilityLabel = capability.label /][/#if]
                            [#assign capability =  capabilityAgentMapping.key/]
                            [#if !capabilityLabel??][#assign capabilityLabel = capability.label /][/#if]
                            [#assign agent = capabilityAgentMapping.value!("") /]
                            [#if featureManager.localAgentsSupported]
                                <tr>
                                    <td class="agentCell labelPrefixCell">
                                        [#assign sharedCapabilitySetType = (capability.capabilitySet.sharedCapabilitySetType)!("") /]
                                        [#if sharedCapabilitySetType?has_content]
                                            <a href="[@ww.url action='configureShared${sharedCapabilitySetType}Capabilities' namespace='/admin/agent' /]">[@ww.text name='agent.capability.agents.all.${sharedCapabilitySetType}' /]</a>
                                        [#else]
                                            [#if agent?has_content]
                                                <a href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId=agent.id /]">${agent.name?html}</a>
                                            [/#if]
                                        [/#if]
                                    </td>
                                    <td class="valueCell">
                                    ${capability.value!?html}
                                    </td>
                                    <td class="operations">
                                        [@agt.showCapabilityOperations capability=capability agent=agent showEdit=true showDelete=true returnAfterOpUrl="${capabilityTabUrl}" capabilityName=capabilityLabel /]
                                    </td>
                                </tr>
                            [/#if]
                        [/#list]
                    </table>
                [#else]
                    <p>[@ww.text name='agent.capability.capabilityAgent.none' /]</p>
                [/#if]
            [/@dj.contentPane]

            [#if elasticSupportPossible]
                [@dj.contentPane labelKey="agent.capability.capabilityElasticImage" id='images_' + contentId]
                    [#if capabilityElasticImageMappings?has_content]
                        [#if !elasticBambooEnabled]
                        <p>[@ww.text name='agent.capability.capabilityElasticImage.description.elasticDisabled']
                        [@ww.param][@ww.url action='viewElasticConfig' namespace='/admin/elastic' /][/@ww.param]
                    [/@ww.text]</p>
                        [#else]
                        <p>[@ww.text name='agent.capability.capabilityElasticImage.description']
                        [@ww.param name="value" value="${capabilityElasticImageMappings.size()}"/]
                    [/@ww.text]</p>[#rt]

                        <table id="capabilityElasticImageMappings" class="aui">
                            <thead>
                            <tr>
                                <th class="agentCell labelPrefixCell">
                                    [@ww.text name='elastic.image.configuration.heading' /]
                                </th>
                                <th class="valueCell">
                                    [@ww.text name='agent.capability.type.${capabilityType}.value' /]
                                </th>
                            </tr>
                            </thead>
                            [#list capabilityElasticImageMappings as capabilityElasticImageMapping]
                                [#assign capability =  capabilityElasticImageMapping.capability/]
                                [#assign elasticImageConfiguration = (capabilityElasticImageMapping.elasticImageConfiguration)!("") /]
                                <tr>
                                    <td class="agentCell labelPrefixCell">
                                        <a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId=elasticImageConfiguration.id /]">${elasticImageConfiguration.configurationName?html}</a>
                                    </td>
                                    <td class="valueCell">
                                    ${(capability.value!"")?html}
                                    </td>
                                </tr>
                            [/#list]
                        </table>
                        [/#if]
                    [#else]
                    <p>[@ww.text name='agent.capability.capabilityElasticImage.none' /]</p>
                    [/#if]
                [/@dj.contentPane]
            [/#if]

            [@dj.contentPane labelKey="agent.capability.jobRequirement" id='jobs_' + contentId]
                [#assign decoratedRequirements = jobRequirementSetDecorator.decoratedObjects /]
                [#if decoratedRequirements?has_content]
                <p>[@ww.text name='agent.capability.jobRequirement.description'][@ww.param name="value" value="${decoratedRequirements.size()}"/][/@ww.text]</p>
                <table class="aui">
                    <thead>
                    <tr>
                        <th class="planCell labelPrefixCell">
                            [@ww.text name='plan.title' /]
                        </th>
                        <th class="valueCell">
                            [@ww.text name='agent.capability.type.${capabilityType}.value' /]
                        </th>
                        <th class="operations">
                            [@ww.text name='global.heading.operations' /]
                        </th>
                    </tr>
                    </thead>
                    [#list decoratedRequirements as requirement]
                        [#assign build = requirement.requirementAware.wrappedObject /]
                        <tr>
                            <td class="planCell labelPrefixCell">
                                [#if build.type=="JOB"]
                                    <a title="${build.parent.key}" href="[@ww.url value='/browse/${build.parent.key}'/]">${build.parent.project.name} &rsaquo; ${build.parent.buildName} </a> &rsaquo;
                                    <a title="${build.key}" href="[@ww.url action='defaultBuildRequirement' namespace='/build/admin/edit' buildKey=build.key/]">${build.buildName}</a>
                                [#else]
                                    <a title="${build.key}" href="[@ww.url action='defaultBuildRequirement' namespace='/build/admin/edit' buildKey=build.key/]">${build.name}</a>
                                [/#if]
                            </td>

                            [@agt.shoRequirementCell requirement=requirement /]

                            <td class="operations">
                                [#if !requirement.readonly]
                                    [@ui.asyncLink
                                        id='deleteBuildRequirement-${build.key}-${requirement.id}'
                                        url='${req.contextPath}/rest/api/latest/config/job/${build.key}/requirement/${requirement.id}'
                                        type='DELETE'
                                        label='${action.getText("global.buttons.delete")}'
                                        confirmationMessage='${action.getText("agent.requirement.delete.description", [requirement.label])}'
                                        returnUrl='${req.contextPath}${capabilityTabUrl}'
                                    /]
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                </table>
                [#else]
                <p>[@ww.text name='agent.capability.jobRequirement.none' /]</p>
                [/#if]
            [/@dj.contentPane]
            [@dj.contentPane labelKey="agent.capability.deploymentEnvironmentRequirement" id='environments_' + contentId]
                [#assign decoratedRequirements = deploymentEnvironmentRequirementSetDecorator.decoratedObjects /]
                [#if decoratedRequirements?has_content]
                <p>[@ww.text name='agent.capability.deploymentEnvironmentRequirement.description'][@ww.param name="value" value="${decoratedRequirements.size()}"/][/@ww.text]</p>
                <table class="aui">
                    <thead>
                    <tr>
                        <th class="environmentCell labelPrefixCell">
                            [@ww.text name='agent.capability.deploymentEnvironment.title' /]
                        </th>
                        <th class="valueCell">
                            [@ww.text name='agent.capability.type.${capabilityType}.value' /]
                        </th>
                        <th class="operations">
                            [@ww.text name='global.heading.operations' /]
                        </th>
                    </tr>
                    </thead>
                    [#list decoratedRequirements as requirement]
                        [#assign environment = requirement.requirementAware.wrappedObject /]
                        <tr>
                            <td class="environmentCell labelPrefixCell">
                                <a title="${environment.deploymentProjectDisplayName}" href="[@ww.url action='viewDeploymentProjectEnvironments' namespace='/deploy' ][@ww.param name='id' value=environment.deploymentProjectId /][/@ww.url]" >${environment.deploymentProjectDisplayName}</a> &rsaquo; <a title="${environment.name}" href="[@ww.url action='configureEnvironmentAgents' namespace='/deploy/config' ][@ww.param name='environmentId' value=environment.id /][/@ww.url]">${environment.name}</a>
                            </td>

                            [@agt.shoRequirementCell requirement=requirement /]

                            <td class="operations">
                                [#if !requirement.readonly]
                                    [@ui.asyncLink
                                        id='deleteEnvRequirement-${environment.id}-${requirement.id}'
                                        url='${req.contextPath}/rest/api/latest/deploy/environment/${environment.id}/requirement/${requirement.id}'
                                        type='DELETE'
                                        label='${action.getText("global.buttons.delete")}'
                                        confirmationMessage='${action.getText("agent.requirement.delete.description", [requirement.label])}'
                                        returnUrl='${req.contextPath}${capabilityTabUrl}'
                                    /]
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                </table>
                [#else]
                <p>[@ww.text name='agent.capability.deploymentEnvironmentRequirement.none' /]</p>
                [/#if]
            [/@dj.contentPane]
        [/@dj.tabContainer]

[/#macro]
