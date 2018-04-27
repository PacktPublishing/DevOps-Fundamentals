[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]

[#import "/agent/agentAvailability.ftl" as bd]
[@bd.showMatchingImages executableAgentsMatrix=executableAgentsMatrix i18nSuffix="environment"/]
