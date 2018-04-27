[#--context is set by com.atlassian.bamboo.build.monitoring.HungBuildPlanConfigurationPlugin--]
[#if .vars['custom.com.atlassian.bamboo.plugin.hungbuildkiller.hung.available']!false]
    [@ww.label labelKey='buildMonitoring.force.stop.enable'
        value='${.vars["custom.com.atlassian.bamboo.plugin.hungbuildkiller.hung.enabled"]?string}' /]
[/#if]