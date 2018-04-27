[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]

<html>
<head>
    <title>[@ww.text name='dashboard.selectAgents.title' /]</title>
    <meta name="bodyClass" content="aui-page-focused agents-wizard--focused"/>
    <meta name="decorator" content="agentsWizard"/>
    <meta name="tab" content="-1"/>
</head>
<body>

<h2>[@ww.text name='dashboard.selectAgents.title' /]</h2>
<div class="agents-wizard__content">
    <p>[@ww.text name='dashboard.selectAgents.description' ]
        [@ww.param][@help.href pageKey='cloud.getting.started'/][/@ww.param]
    [/@ww.text]</p>
    <div class="agents-wizard__selection">
        <section class="agents-wizard__section agents-wizard__section--elastic">
            <h3>[@ww.text name='dashboard.selectAgents.elasticAgent.heading' /]</h3>
            [@ww.text name='dashboard.selectAgents.elasticAgent.description' /]
            [#assign elasticButton][@ww.text name='dashboard.selectAgents.elasticAgent.button' /][/#assign]
            ${soy.render("aui.buttons.button", {
                'text': '${elasticButton}',
                'extraClasses': 'agents-wizard__button',
                'href': 'ec2Wizard.action',
                'type': 'primary'
            })}
            <p class="agents-wizard__footnote">[@ww.text name='dashboard.selectAgents.elasticAgent.footnote' ]
                [@ww.param]http://aws.amazon.com[/@ww.param]
            [/@ww.text]</p>
        </section>
        <div class="agents-wizard__divider"><span>[@ww.text name='dashboard.selectAgents.divider' /]</span></div>
        <section class="agents-wizard__section agents-wizard__section--remote">
            <h3>[@ww.text name='dashboard.selectAgents.remoteAgent.heading' /]</h3>
            [@ww.text name='dashboard.selectAgents.remoteAgent.description' /]
            [#assign elasticButton][@ww.text name='dashboard.selectAgents.remoteAgent.button' /][/#assign]
            ${soy.render("aui.buttons.button", {
                'text': '${elasticButton}',
                'href': 'setupRemoteAgent.action',
                'extraClasses': 'agents-wizard__button',
                'type': 'primary'
            })}
        </section>
    </div>
</div>

</body>
</html>