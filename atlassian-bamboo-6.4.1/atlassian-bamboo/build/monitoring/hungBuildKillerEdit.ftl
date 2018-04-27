[#--context is set by com.atlassian.bamboo.build.monitoring.HungBuildPlanConfigurationPlugin--]
[#if .vars['custom.com.atlassian.bamboo.plugin.hungbuildkiller.hung.available']!false]
    [@ui.bambooSection titleKey='buildMonitoring.force.stop.title']
        [@ww.checkbox labelKey='buildMonitoring.force.stop.enable'
            name='custom.com.atlassian.bamboo.plugin.hungbuildkiller.hung.enabled' /]
    [/@ui.bambooSection]
[/#if]