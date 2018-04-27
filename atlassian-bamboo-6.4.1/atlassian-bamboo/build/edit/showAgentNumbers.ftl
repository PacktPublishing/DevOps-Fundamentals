[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]

[#import "/agent/agentAvailability.ftl" as bd]

[#assign viewAgentsUrl="/ajax/viewAgentsMatchingRequirementsForJob.action?planKey=${plan.key}" /]
[#assign viewImagesUrl="/ajax/viewImagesMatchingRequirementsForJob.action?planKey=${plan.key}"  /]
[@s.url var="editRequirementsUrl" action="defaultBuildRequirement" namespace="/build/admin/edit" buildKey=plan.key /]

[@bd.showAgentNumbers executableAgentMatrix=executableAgentMatrix elasticBambooEnabled=elasticBambooEnabled i18nSuffix="job" viewAgentsUrl=viewAgentsUrl viewImagesUrl=viewImagesUrl editRequirementsUrl=editRequirementsUrl/]