[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureSpotInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureSpotInstancesAction" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    [@ui.header pageKey="elastic.configure.spot.instances.title" title=true/]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="viewSpotInstancesConfig">
</head>
<body>

[@ui.header pageKey="elastic.configure.spot.instances.title" /]
<p>[@ww.text name="elastic.configure.spot.instances.description" /]</p>

[#if actionErrors?has_content]
    [@ww.actionerror /]
[#else]
    [#if spotInstanceConfig.enabled]
        <div id="spot-instance-configuration-view">
            [@ui.bambooInfoDisplay]
                [@ww.label labelKey="elastic.configure.spot.instances.fallback"]
                    [@ww.param name="value"]
                        [@ww.text name="bamboo.date.format.duration.long.any.minutes"]
                            [@ww.param value=fieldSpotInstancesTimeoutMinutes/]
                        [/@ww.text]
                    [/@ww.param]
                [/@ww.label]
            [/@ui.bambooInfoDisplay]

            [#-- Your current bid levels --]
            [@ui.bambooInfoDisplay id="bidTableInfoDisplay" titleKey="elastic.configure.spot.instances.current.bids"]
                [@ela.displaySpotPrices editMode=false confElasticCloudAction=action/]
            [/@ui.bambooInfoDisplay]
        </div>

        [@ww.form
            action='editSpotInstancesConfig'
            submitLabelKey='global.buttons.edit.configuration'
            showActionErrors='false'
            cssClass='top-label'/]
    [#else]
        <p>[@ww.text name='elastic.configure.spot.instances.disabled'/]</p>

        [@ww.form
            action='editSpotInstancesConfig'
            submitLabelKey='elastic.configure.spot.instances.button.configure'
            showActionErrors='false'
            cssClass='top-label'/]
    [/#if]
[/#if]
</body>
</html>
