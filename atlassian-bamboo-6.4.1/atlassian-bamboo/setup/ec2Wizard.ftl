[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]

<html>
<head>
    <title>[@ww.text name='dashboard.ec2wizard.title' /]</title>
    <meta name="bodyClass" content="aui-page-focused agents-wizard--focused"/>
    <meta name="decorator" content="agentsWizard"/>
    <meta name="tab" content="0"/>
</head>
<body>

<h2>[@ww.text name='dashboard.ec2wizard.title' /]</h2>
<div class="ec2-wizard__content">
    <p>
        [@ww.text name='dashboard.ec2wizard.description']
            [@ww.param][@help.href pageKey="elastic.intro.bamboo"/][/@ww.param]
        [/@ww.text]
    </p>
    <p>
        [@ww.text name='dashboard.ec2wizard.learnMore']
            [@ww.param][@ww.text name="help.aws.best.practices.keys"/][/@ww.param]
        [/@ww.text]
    </p>
    [@ww.form method="post" enctype="multipart/form-data" id='saveElasticConfigForm' action='saveEc2Wizard.action' submitLabelKey='dashboard.ec2wizard.buttons.configure']
        [@ww.textfield id='fieldAwsAccessKeyId' required=true name='fieldAwsAccessKeyId' labelKey='dashboard.ec2wizard.field.accessKey' longField=true/]
        [@ww.hidden name='awsSecretAccessKeyChange' value='true' /]
        [@ww.password labelKey='dashboard.ec2wizard.field.secretKey' name='fieldAwsSecretAccessKey' showPassword='true' required=true cssClass='long-field' helpIconCssClass='aui-iconfont-info' helpDialogKey='dashboard.ec2wizard.info.accessKey'/]
        [@ww.select labelKey='dashboard.ec2wizard.field.region' name='region' list=availableRegions listKey='name()' listValue='displayName' helpIconCssClass='aui-iconfont-info' helpDialogKey='dashboard.ec2wizard.info.region' /]
        [@ww.hidden name='elasticConfigureKeysMethod' value='BAMBOO_SERVER_LOCATION' /]
        [@ww.hidden name='automaticInstanceManagementPreset' value='Default' /]
        [@ww.hidden name='fieldMaxConcurrentInstances' value='1' /]
        [@ww.hidden name='fieldElasticWizard' value='true' /]
        [@ww.hidden name='fieldAutoShutdownEnabled' value='true' /]
        [@ww.hidden name='fieldAutoShutdownDelay' value='300' /]
    [/@ww.form]
</div>
<script type="application/javascript">
    require(['jquery', 'feature/ec2-wizard'], function($, Ec2Wizard){
        return new Ec2Wizard({
            formId: 'saveElasticConfigForm'
        });
    });
</script>
</body>
</html>