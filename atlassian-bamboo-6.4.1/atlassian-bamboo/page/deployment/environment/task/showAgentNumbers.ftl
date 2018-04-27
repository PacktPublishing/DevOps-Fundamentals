[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]
[#import "/agent/agentAvailability.ftl" as bd]

[#assign viewAgentsUrl="/deploy/config/showMatchingAgents.action?environmentId=${environmentId}"  /]
[#assign viewImagesUrl="/deploy/config/showMatchingImages.action?environmentId=${environmentId}"  /]
[@s.url var="editRequirementsUrl" action="configureEnvironmentAgents" namespace="/deploy/config" environmentId=environmentId /]
[#assign i18nSuffix][#if shortened]environment.short[#else]environment[/#if][/#assign]
[@bd.showAgentNumbers executableAgentMatrix=executableAgentsMatrix elasticBambooEnabled=elasticBambooEnabled i18nSuffix=i18nSuffix viewAgentsUrl=viewAgentsUrl viewImagesUrl=viewImagesUrl editRequirementsUrl=editRequirementsUrl/]
