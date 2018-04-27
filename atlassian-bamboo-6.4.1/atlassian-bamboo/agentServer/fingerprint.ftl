[#-- @ftlvariable name="action" type="com.atlassian.bamboo.agent.classserver.GetFingerprintAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.agent.classserver.GetFingerprintAction" --]
[@print
'bootstrapVersion=1'
'fingerprint=${formEncodedServerFingerprint}'
'instanceFingerprint=${formEncodedInstanceFingerprint}'
'agentClassName=${formEncodedAgentClassName}'
'${formEncodedUserProperties}'
/]

[#macro print args...]
    [#list args as arg]${arg}[#if arg_has_next]&[/#if][/#list][#t]
[/#macro]