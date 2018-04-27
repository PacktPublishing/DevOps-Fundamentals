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


[@ww.form
    method="post" enctype="multipart/form-data"
    id='saveSpotInstancesConfigForm'
    action='saveSpotInstancesConfig'
    cancelUri='/admin/elastic/viewSpotInstancesConfig.action'
    submitLabelKey='global.buttons.save.changes'
]
    [@ui.bambooSection]
        [@ww.label labelKey="elastic.configure.spot.instances.support" cssClass="field-value-checkbox" escape=false]
            [@ww.param name="value"]
                [@ww.checkbox name="fieldSpotInstancesEnabled" labelKey="elastic.configure.spot.instances.enable" toggle=true/]
            [/@ww.param]
        [/@ww.label]
        [@ui.bambooSection dependsOn='fieldSpotInstancesEnabled' showOn=true]
            [#-- Fallback to regular instance --]
            [@ww.textfield
                name="fieldSpotInstancesTimeoutMinutes"
                labelKey="elastic.configure.spot.instances.fallback"
                cssClass="short-field"]
                    [@ww.param name="after"][@ww.text name="core.dateutils.minutes" /][/@ww.param]
            [/@ww.textfield]

            [#-- Your current bid levels --]
            [@ui.bambooSection id="bidTableSection" titleKey="elastic.configure.spot.instances.current.bids"]
                [@ela.displaySpotPrices editMode=true confElasticCloudAction=action/]
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

[/@ww.form]

</body>
</html>
