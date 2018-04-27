[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    [@ui.header pageKey="elastic.configure.title" title=true/]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="configureElasticCloud">
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url id="elastic-bamboo-help-link" pageKey="elastic.intro.bamboo"][@ww.text name="elastic.howtouse.title"/][/@help.url]</div>
[@ui.header pageKey="elastic.configure.title"/]
<p>
    [@ww.text name="elastic.configure.blurb" /]
</p>


[#if elasticConfig?? && elasticConfig.enabled]
    [#if showHint]
        [@ui.messageBox type="success" titleKey='elastic.configure.hint.first']
        <p>[@ww.text name='elastic.configure.hint']
            [@ww.param]${req.contextPath}/admin/elastic/manageElasticInstances.action[/@ww.param]
            [@ww.param]${req.contextPath}/admin/elastic/prepareElasticInstances.action[/@ww.param]
            [@ww.param][@help.href pageKey="elastic.intro.bamboo"/][/@ww.param]
        [/@ww.text]</p>
        [/@ui.messageBox]
    [/#if]

    <div id="elastic-bamboo-configuration-view">
        [#-- Elastic agents --]
        [@ui.bambooInfoDisplay titleKey="elastic.configure.agents.title"]
            <p>
                [@ww.text name="elastic.configure.agents.description" /]
            </p>
            [@ww.label labelKey='elastic.configure.agents.maximum.number.of.elastic.agents' value=elasticConfig.maxConcurrentInstances /]
        [/@ui.bambooInfoDisplay]

        [#-- Amazon Web Services configuration --]
        [@ui.bambooInfoDisplay titleKey="elastic.configure.aws.title"]
            [@ww.label labelKey='elastic.configure.aws.field.accessKeyId' value=elasticConfig.awsAccessKeyId /]
            [@ww.label labelKey='elastic.configure.aws.field.region' value=elasticConfig.region.displayName /]

            [#assign uploadingOfAwsAccountDetails]
                [#if elasticConfig.uploadingOfAwsAccountDetailsEnabled]
                    [@s.text name="global.buttons.enabled"/]
                [#else]
                    [@s.text name="global.buttons.disabled"/]
                [/#if]
            [/#assign]
            [@s.label key="elastic.configure.credentials.upload" value=uploadingOfAwsAccountDetails/]

            [@s.label labelKey='elastic.configure.aws.field.vpc' escape=false]
                [@s.param name='value']
                    [#if elasticConfig.publicIpForVpcEnabled ]
                        <p>[@s.text name='elastic.configure.aws.vpc.public.ip.enabled'/]</p>
                    [#else]
                        <p>[@s.text name='elastic.configure.aws.vpc.public.ip.disabled'/]</p>
                    [/#if]
                [/@s.param]
            [/@s.label]
            [@ww.label labelKey='elastic.configure.aws.field.autoShutdown' escape=false ]
                [@ww.param name='value']
                    [#if elasticConfig.autoShutdownEnabled ]
                        [@ww.text name='elastic.configure.aws.autoShutdown']
                            [@ww.param value=elasticConfig.autoShutdownDelay/]
                        [/@ww.text]
                    [#else ]
                        [@ww.text name='elastic.configure.aws.autoShutdown.disabled'/]
                    [/#if]
                [/@ww.param]
            [/@ww.label]
        [/@ui.bambooInfoDisplay]

        [#-- Automatic elastic instance management --]
        [@ui.bambooInfoDisplay titleKey="elastic.configure.automatic.instance.management.title"]
            [#if elasticConfig.automaticInstanceManagementConfig.automaticInstanceManagementEnabled]
                [@ww.text name='elastic.configure.field.automaticInstanceManagement.params']
                    [@ww.param value=fieldInstanceIdleTimeThreshold /]
                    [@ww.param value=fieldMaxElasticInstancesToStartAtOnce /]
                    [@ww.param value=fieldTotalBuildInQueueThreshold /]
                    [@ww.param value=fieldElasticBuildsInQueueThreshold /]
                    [@ww.param value=fieldAverageTimeInQueueThreshold /]
                    [@ww.param value=fieldMaxNonBambooInstances /]
                [/@ww.text]
            [#else]
                <p>[@ww.text name='elastic.configure.view.automaticInstanceManagement.disabled'/]</p>
            [/#if]
        [/@ui.bambooInfoDisplay]

        [@ww.form action='editElasticConfig' submitLabelKey='global.buttons.edit.configuration' showActionErrors=false cssClass='top-label']
            [@ww.param name='buttons']
                [@cp.displayLinkButton buttonId="disableButton" buttonLabel="elastic.configure.button.disable.ec2" buttonUrl="${req.contextPath}/admin/elastic/confirmDisableElasticConfig.action" /]
            [/@ww.param]
        [/@ww.form]
    </div>
[#else]
    [@ww.form
        action='enableElasticConfig'
        submitLabelKey='elastic.configure.button.configure.ec2'
        showActionErrors='false'
        cssClass='top-label']

        [#-- Elastic agents --]
        [@ui.bambooInfoDisplay titleKey="elastic.configure.agents.title"]
            <p>
                [#if elasticConfig??]
                    [@ww.text name='elastic.configure.disabled' /]
                [#else]
                    [@ww.text name='elastic.configure.nonexistent' /]
                [/#if]
            </p>
        [/@ui.bambooInfoDisplay]

    [/@ww.form]
[/#if]

</body>
</html>
