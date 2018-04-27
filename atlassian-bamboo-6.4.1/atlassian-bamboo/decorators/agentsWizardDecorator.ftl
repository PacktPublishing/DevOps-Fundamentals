[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.agents.wizard", "bamboo.configuration"] bodyClass="agents-wizard aui-page-focused" activeNavKey='create' /]
[#include "/fragments/showAdminErrors.ftl"]
[#assign step = page.properties["meta.tab"]!/]
[#assign prefix = page.properties["meta.prefix"]!"plan"/]
[#assign headerMainContent]
<h1>[@ww.text name="dashboard.selectAgents.heading" /]</h1>
[/#assign]

${soy.render("bamboo.layout.focused", {
    "headerMainContent": headerMainContent,
    "progressTrackerSteps": [
        {
            "text": action.getText("dashboard.selectAgents.tracker.select"),
            "isCurrent": (step == "-1")
        },
        {
            "text": action.getText("dashboard.selectAgents.tracker.configure"),
            "isCurrent": (step == "0")
        },
        {
            "text": action.getText("dashboard.selectAgents.tracker.plan"),
            "isCurrent": (step == "1")
        },
        {
            "text": action.getText("dashboard.selectAgents.tracker.tasks"),
            "isCurrent": (step == "2")
        }
    ],
    "content": body
})}
<script type="application/javascript">
    [#assign configureTypeKey][#if req.getRequestURI()?contains('setupRemoteAgent')]CONFIGURE_AGENT[#else]CONFIGURE_AWS[/#if][/#assign]
    var steps = ['${configureTypeKey}', 'CONFIGURE_PLAN', 'CONFIGURE_TASKS'];
    [#if step == "-1"]steps[-1] = 'SELECT_AGENT_TYPE';[/#if]
    AJS.trigger('analyticsEvent', {
        name: 'bamboo.config.elastic.wizard.load',
        data: {
            wizardStep: steps[${step}]
        }
    });
</script>
[#include "/fragments/decorator/footer.ftl"]