[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

[#if elasticConfig??]
    [#assign editMode = true /]
[#else]
    [#assign editMode = false /]
[/#if]
<html>
<head>
    [@ui.header pageKey="elastic.configure.title" title=true/]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="configureElasticCloud">
</head>
<body>
    <div class="elastic-bamboo__configuration">

    <div class="toolbar aui-toolbar inline">[@help.url pageKey="elastic.intro.bamboo"][@ww.text name="elastic.howtouse.title"/][/@help.url]</div>

    [@ui.header pageKey="elastic.configure.title"/]
    <p>
        [@ww.text name="elastic.configure.blurb" /]
    </p>

    [@ww.text name="elastic.configure.edit.description" var="elasticConfigureEditDescription"]
        [@ww.param][@help.href pageKey="elastic.configure"/][/@ww.param]
    [/@ww.text]

    [@ww.form
        method="post" enctype="multipart/form-data"
        id='saveElasticConfigForm'
        action='saveElasticConfig'
        submitLabelKey='global.buttons.save.changes'
        cancelUri='/admin/elastic/viewElasticConfig.action'
        cancelSubmitKey="global.buttons.discard.changes"
    ]

    [#-- Amazon Web Services configuration --]
    [@ui.bambooSection titleKey="elastic.configure.aws.title"]
        [#-- access key id and secret --]
        [@ww.textfield labelKey='elastic.configure.aws.field.accessKeyId' name='fieldAwsAccessKeyId' required=true  /]
        [#if editMode && elasticConfig.awsAccessKeyId?has_content]
            [@ww.checkbox labelKey='elastic.configure.aws.field.secretAccessKey.change' toggle='true' id='awsSecretAccessKeyChange' name='awsSecretAccessKeyChange' /]
            [@ui.bambooSection dependsOn='awsSecretAccessKeyChange' showOn='true']
                [@ww.password labelKey='elastic.configure.aws.field.secretAccessKey' name="fieldAwsSecretAccessKey" showPassword="true" required=true cssClass="long-field"/]
            [/@ui.bambooSection]
        [#else]
            [@ww.hidden name='awsSecretAccessKeyChange' value='true' /]
            [@ww.password labelKey='elastic.configure.aws.field.secretAccessKey' name="fieldAwsSecretAccessKey" showPassword="true" required=true cssClass="long-field"/]
        [/#if]

        [#-- region --]
        [@ww.select labelKey='elastic.configure.aws.field.region' name='region' list=availableRegions listKey='name()' listValue='displayName' toggle='true' /]
        [@ui.messageBox type="warning" ]
            [@ww.text name="elastic.configure.aws.field.region.warning"/]
        [/@ui.messageBox]

    [/@ui.bambooSection]

    [#-- keys --]
    [@ui.bambooSection titleKey="elastic.configure.credentials.config.title"]
    <p>[@ww.text name="elastic.configure.aws.description" /]</p>
        [@ww.select labelKey='elastic.configure.key.provide.method' name='elasticConfigureKeysMethod' list=keyProvideMethods listKey='key' listValue='displayName' toggle='true' /]
        [@ui.bambooSection dependsOn='elasticConfigureKeysMethod' showOn='BAMBOO_SERVER_LOCATION']
            [@ww.textfield name='fieldAwsPrivateKeyFile' labelKey='elastic.configure.aws.field.privateKeyFile' cssClass="long-field" /]
            [@ww.textfield name='fieldAwsCertFile' labelKey='elastic.configure.aws.field.certFile' cssClass="long-field" /]
        [/@ui.bambooSection]
        [@ui.bambooSection dependsOn='elasticConfigureKeysMethod' showOn='UPLOAD']
            [@ww.file labelKey='elastic.configure.field.awsPrivateKeyFile.upload' name='fieldAwsPrivateKeyFileUpload' /]
            [@ww.file labelKey='elastic.configure.field.awsCertFile.upload' name='fieldAwsCertFileUpload' /]
        [/@ui.bambooSection]
        [@ww.checkbox name='fieldUploadingOfAwsAccountDetailsEnabled' labelKey='elastic.configure.field.uploadingOfAwsAccountDetailsEnabled'/]
    [/@ui.bambooSection]

    [#-- Elastic agents --]
    [@ui.bambooSection titleKey="elastic.configure.agents.title"]
        <p>
            [@ww.text name="elastic.configure.agents.description" /]
        </p>
        [@ww.textfield labelKey='elastic.configure.agents.maximum.number.of.elastic.agents' name='fieldMaxConcurrentInstances' required=true cssClass="short-field" /]
    [/@ui.bambooSection]

    [#-- Automatic elastic instance management --]
    [@ui.bambooSection titleKey="elastic.configure.automatic.instance.management.title"]
        [@ww.select labelKey='elastic.configure.field.automaticInstanceManagement.config'
        name='automaticInstanceManagementPreset'
        id='automaticInstanceManagementPreset'
        list=automaticInstanceManagementPresets
        listKey='key'
        groupBy='value.group'
        listValue='value.name'
        value="automaticInstanceManagementPreset"]
        [/@ww.select]
        [@ui.bambooSection id='autoConfigManagementValues']
            [@ww.textfield name='fieldInstanceIdleTimeThreshold' id='fieldInstanceIdleTimeThreshold'
            labelKey='elastic.configure.field.automaticInstanceManagement.instance.idle.time.threshold' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldMaxNonBambooInstances' id='fieldMaxNonBambooInstances'
            labelKey='elastic.configure.field.automaticInstanceManagement.max.non.bamboo.instances' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldMaxElasticInstancesToStartAtOnce' id='fieldMaxElasticInstancesToStartAtOnce'
            labelKey='elastic.configure.field.automaticInstanceManagement.max.instances.to.start.at.once' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldTotalBuildInQueueThreshold' id='fieldTotalBuildInQueueThreshold'
            labelKey='elastic.configure.field.automaticInstanceManagement.total.builds.in.queue.threshold' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldElasticBuildsInQueueThreshold' id='fieldElasticBuildsInQueueThreshold'
            labelKey='elastic.configure.field.automaticInstanceManagement.elastic.builds.in.queue.threshold' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldAverageTimeInQueueThreshold' id='fieldAverageTimeInQueueThreshold'
            labelKey='elastic.configure.field.automaticInstanceManagement.average.time.in.queue.threshold' required=true cssClass="short-field" /]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey="miscellaneous.title"]
        [#if !featureManager.publicIpRequiredForVpc]
        [#-- Virtual Private Cloud --]
            [@s.label labelKey="elastic.configure.aws.field.vpc" cssClass="field-value-checkbox" escape=false]
                [@s.param name="value"]
                    [@s.checkbox name="elasticIpManagementEnabled" key="elastic.configure.aws.vpc.public.ip.allocate"/]
                [/@s.param]
            [/@s.label]
        [/#if]
        [#-- Automatic shutdown --]
        [@ww.label labelKey="elastic.configure.aws.field.autoShutdown" cssClass="field-value-checkbox" escape=false]
            [@ww.param name="value"]
                [@ww.checkbox name="fieldAutoShutdownEnabled" labelKey="elastic.configure.aws.autoShutdown.management" toggle=true/]
            [/@ww.param]
        [/@ww.label]
        [@ui.bambooSection dependsOn='fieldAutoShutdownEnabled' showOn=true]
            [@ww.textfield name='fieldAutoShutdownDelay' labelKey="elastic.configure.aws.autoShutdown.delay" required=true cssClass="short-field" /]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [/@ww.form]
   
    <script type="text/javascript">
        AJS.$(function(){
            var $select = AJS.$("#automaticInstanceManagementPreset"),
                $values = AJS.$("#autoConfigManagementValues"),
                $fieldInstanceIdleTimeThreshold = AJS.$("#fieldInstanceIdleTimeThreshold"),
                $fieldMaxElasticInstancesToStartAtOnce = AJS.$("#fieldMaxElasticInstancesToStartAtOnce"),
                $fieldTotalBuildInQueueThreshold = AJS.$("#fieldTotalBuildInQueueThreshold"),
                $fieldElasticBuildsInQueueThreshold = AJS.$("#fieldElasticBuildsInQueueThreshold"),
                $fieldAverageTimeInQueueThreshold = AJS.$("#fieldAverageTimeInQueueThreshold"),
                $description = AJS.$("#automaticInstanceManagementPresetDesc"),
                $inputs = $values.find("input:text");
            [#list automaticInstanceManagementPresetList as preset]
                 $select.find("option[value='${preset.name}']").data("description", "${preset.explanation}").data("values", ${preset.jsArrayValues});
            [/#list]
            $select.change(function(){
                var $selectedOption = $select.find("option:selected");
                $description.text($selectedOption.data("description"));
                if ($select.val() != "Disabled") {
                    if ($select.val() == "Custom") {
                        $inputs.removeAttr("disabled");
                    } else {
                        var params = $selectedOption.data("values");
                        $fieldInstanceIdleTimeThreshold.val(params[0]);
                        $fieldMaxElasticInstancesToStartAtOnce.val(params[1]);
                        $fieldTotalBuildInQueueThreshold.val(params[2]);
                        $fieldElasticBuildsInQueueThreshold.val(params[3]);
                        $fieldAverageTimeInQueueThreshold.val(params[4]);
                        $inputs.attr("disabled", "disabled");
                    }
                    $values.show();
                } else {
                    $values.hide();
                }
            });
            $select.change();
        });
    </script>
    </div>
</body>
</html>