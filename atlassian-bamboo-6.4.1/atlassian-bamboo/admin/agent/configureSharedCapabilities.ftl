[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureSharedRemoteCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureSharedRemoteCapability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#if action.local]
    [#assign type = 'local' /]
    [#assign Type = 'Local' /]
[#else]
    [#assign type = 'remote' /]
    [#assign Type = 'Remote' /]
[/#if]
[#assign cancelUri='/admin/agent/configureShared${Type}Capabilities!doDefault.action'/]

<html>
<head>
    <title>[@ww.text name='agent.capability.shared.${type}.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="serverCapabilities">
</head>

<body>
[#if action.local]
    <div class="toolbar">
        [@ww.url var='updateDefaultsCapabilitiesUrl' action='updateDefaults${Type}Capability' namespace='/admin/agent'/]
        [@cp.displayLinkButton buttonId='updateDefaultsCapabilities' buttonUrl=updateDefaultsCapabilitiesUrl
            buttonLabel='agent.capability.shared.autodetect' altTextKey='agent.capability.shared.autodetect.description' mutative=true/]
    </div>
[/#if]

<h1>[@ww.text name='agent.capability.shared.${type}.title' /]</h1>

<p>[@ww.text name='agent.capability.shared.${type}.description' /]</p>

[@ui.bambooPanel cssClass='shared-capabilities-form']
    [#if (capabilitySet.capabilities)?has_content]
        [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator showDelete=true returnAfterOpUrl=cancelUri/]
    [#else]
        [@ui.displayText key='agent.capability.shared.${type}.empty' /]
    [/#if]
[/@ui.bambooPanel]

[@ww.form id='addCapability' action='addShared${Type}Capability' namespace='/admin/agent' titleKey='agent.capability.add'
          submitLabelKey='global.buttons.add'
          cancelUri=cancelUri]

    [@ww.hidden name="returnUrl" /]

    [#include '/admin/agent/addCapabilityFragment.ftl' /]
[/@ww.form]
</body>
</html>
