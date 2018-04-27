[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

[@ui.bambooPanel titleKey='elastic.instance.details' descriptionKey='elastic.instance.details.description']
    [@ww.label labelKey='elastic.instance.agent.status' escape=false]
        [@ww.param name="value"]
            <img src="${req.contextPath?html}${action.getStateImagePath()?html}" alt="${action.getStateDescription()?html}" />
            ${action.getStateDescription()?html}
        [/@ww.param]
    [/@ww.label]

    [#if instance.instanceStatus.hostname??]
        [#if instance.instanceStatus.hostname==instance.instanceStatus.address] [#-- no DNS name, normal for VPC --]
            [@ww.label labelKey='elastic.instance.address' escape=false value=instance.instanceStatus.address/]
        [#else]
            [@ww.label labelKey='elastic.instance.address' escape=false value=instance.instanceStatus.hostname description="${action.getText('elastic.instance.ip')}: ${instance.instanceStatus.address}" /]
        [/#if]
    [/#if]

    [#if instance.instanceStatus.launchTime??]
        [@ww.label labelKey='elastic.instance.agent.start' value="${instance.instanceStatus.launchTime?datetime?string.short} (${durationUtils.getRelativeDate(instance.instanceStatus.launchTime.time)} ${action.getText('global.dateFormat.ago')})" /]
    [/#if]

    [#if buildAgent?? && agentDefinition??]
        [@ww.url var='agentUrl' namespace='/admin/agent' action='viewAgent' agentId=agentDefinition.id /]
        [@ww.label labelKey='elastic.instance.agent' showDescription=true escape=false]
            [@ww.param name="value"]
                <a href="${agentUrl}">${buildAgent.name?html}</a> (${buildAgent.agentStatus.label})
            [/@ww.param]
        [/@ww.label]
    [#elseif agent.agentLoading]
        [@ww.label labelKey='elastic.instance.agent' escape=false]
            [@ww.param name="value"]
                [@ui.icon type="building" /]
                Pending
            [/@ww.param]
        [/@ww.label]
    [/#if]

    [#assign availabilityZoneText]
        ${instance.instanceStatus.availabilityZone!}[#if instance.instanceStatus.subnet?has_content], VPC subnets: ${fn.join(instance.instanceStatus.subnet)?replace('-', ' ')} [/#if]

        [#if image?has_content && !image.availabilityZones?has_content]
            [@ww.text name='elastic.image.configuration.availabilityZone.default.suffix'/]
        [/#if]
    [/#assign]

    [@ww.label labelKey='elastic.image.configuration.availabilityZone.current' value='${availabilityZoneText}' /]

    [@ui.displayText]
        [#assign instanceVolumes = action.getVolumes(agent.instance.instanceStatus.instanceId)/]
        [#if instanceVolumes?has_content]
            <table id="attachedVolumes" class="aui">
                <thead>
                    <tr><th>[@ww.text name='elastic.instance.volumes' /]</th></tr>
                </thead>
                <tbody>
                [#list instanceVolumes as volume]
                    <tr><td>${volume.deviceName}</td><td>${volume.ebs.volumeId}</td><td>[@ui.time datetime=volume.ebs.attachTime format='full'/]</td><td>${volume.ebs.status}</td></tr>
                [/#list]
                </tbody>
            </table>
        [/#if]
    [/@ui.displayText]

    [@ui.bambooSection titleKey='elastic.configuration']
        [@ela.elasticImageConfigurationViewProperties configuration=image displayConfigurationUrl=true short=true /]
    [/@ui.bambooSection]

    [#if action.allowShutdown()]
        [@ui.displayButtonContainer]
            [@ww.url var="shutdownInstanceUrl" action='shutdownElasticInstance' namespace='/admin/elastic' instanceId=instanceId returnUrl='/admin/elastic/viewElasticInstance.action?instanceId=${instanceId}' /]
            <a href="${shutdownInstanceUrl}" class="aui-button">[@ww.text name='elastic.manage.shutdown' /]</a>
        [/@ui.displayButtonContainer]
    [/#if]
[/@ui.bambooPanel]

[#if instance.instanceStatus.address??]
    [#if errorOrPrivateKeyLocation.isRight()]
        [#assign hasValidPrivateKey=true /]
        [@s.url var='pkFileUrl' namespace='/admin/elastic' action='getPkFile'/]
        [#assign privateKeyDownloadLink='<a href="${pkFileUrl}">here</a>' /]
        [#assign pkHttpLinkAndLocalLocation='<a href="${pkFileUrl}">${unvalidatedPkLocation}</a>' /]
    [#else]
        [#assign hasValidPrivateKey=false /]
        [#assign pkHttpLinkAndLocalLocation='elasticbamboo.pk' /]
    [/#if]

    <h2>[@s.text name='elastic.instance.access' /]</h2>

    [@ui.bambooPanel cssClass='hideHeadingSection' ]

        [#if (rdcEnabled || sshEnabled)  && !hasValidPrivateKey]
            [@ui.messageBox type='warning']
                <p>[@getPrivateKeyValidationErrorMessage errorOrPrivateKeyLocation.left().get() unvalidatedPkLocation keyPairName/]</p>

                [@s.text name='elastic.instance.keypair.problem.more.information']
                    [@s.param][@help.url pageKey="elastic.configure.keys"]online documentation[/@help.url][/@s.param]
                [/@s.text]
            [/@ui.messageBox]
        [/#if]

        [#if rdcEnabled]
            [@ui.bambooSection titleKey='elastic.instance.rdc']
                [#if !hasValidPrivateKey]
                    [@s.text name='elastic.instance.rdc.keypair.problem'/]
                [#elseif password??]
                    [@s.text name='elastic.instance.rdc.description']
                        [@ww.param]${password}[/@ww.param]
                    [/@s.text]
                [#else]
                    [@s.text name='elastic.instance.rdc.unavailable'/]
                [/#if]
            [/@ui.bambooSection]
        [/#if]

        [@ela.sshAccess sshEnabled pkHttpLinkAndLocalLocation instance.instanceStatus.hostname/]

        [@ui.bambooSection titleKey='elastic.instance.amazon.console']
            [@ww.text name='elastic.instance.amazon.console.description' ]
                [@ww.param]${instanceId}[/@ww.param]
            [/@ww.text]
            [#assign instanceLogs = action.getInstanceLog() /]
            [#if instanceLogs?has_content]
                <div id="ec2InstanceLog">${instanceLogs?html}</div>
            [#else]
                <p>${action.getText('elastic.instance.no.logs.available')}</p>
            [/#if]
        [/@ui.bambooSection]
    [/@ui.bambooPanel]
[/#if]

[#macro getPrivateKeyValidationErrorMessage validationStatus keyPairOnServer keyPairOnEc2Account]
    [@ww.text name='elastic.instance.keypair.problem.' + validationStatus]
        [@ww.param]${keyPairOnServer}[/@ww.param]
        [@ww.param]${keyPairOnEc2Account}[/@ww.param]
    [/@ww.text]
[/#macro]