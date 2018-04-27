[#macro showIntegrationStrategyConfiguration chain branchesForAutoIntegration configuringDefaults=false titleKey="branch.integration.edit"]
[#-- @ftlvariable name="chain" type="com.atlassian.bamboo.plan.cache.ImmutableChain" --]
[#-- @ftlvariable name="branchesForAutoIntegration" type="java.util.Map<PlanIdentifier, String>" --]
    [#assign branchName=chain.buildName?html/]
    [#assign prefix='branchIntegration'/]
    [#if configuringDefaults]
        [#assign branchName][@ww.text name='chain.config.branches.merging.currentBranch'/][/#assign]
        [#assign prefix='branches.defaultBranchIntegration'/]
    [/#if]
    [#assign pullRequestTargetBranch]
        [#if chain.buildDefinition.branchIntegrationConfiguration.integrationPoint.integrationVcsReference??]
            ${chain.buildDefinition.branchIntegrationConfiguration.integrationPoint.integrationVcsReference?html}
        [#else]
            [@ww.text name='chain.config.branches.merging.pullRequestTargetBranch'/]
        [/#if]
    [/#assign]
    [#assign checkoutLozenge][@ui.branchLozenge planBranchName=branchName cssClass="checkout-lozenge"/][/#assign]
    [#assign pushLozenge][@ui.branchLozenge planBranchName=branchName cssClass="push-lozenge"/][/#assign]

    [@ww.text name='repository.global.mergeResult' var='mergeResultText' /]

    [@ui.bambooSection titleKey=titleKey descriptionKey=titleKey+".description"]
        [@ww.checkbox labelKey='branch.integration.enabled' name=prefix+'.enabled' toggle=true helpKey='branch.mergeStrategy'/]
        [@ui.bambooSection id="integration-strategies" sectionContainer='div' dependsOn=prefix+'.enabled']
        ${branchIntegrationEditHtml!}
        <div class="aui-group">
            <div class="aui-item">
                [@ui.bambooSection id="branch-updater" cssClass="integration-strategy"]
                        [@ww.radio name=prefix+'.strategy'
                            template='radio.ftl'
                            fieldValue='BRANCH_UPDATER'
                            labelKey='branch.integration.strategy.branchUpdater'
                            helpKey='branch.autointegration.branchUpdater'/]

                        [@ww.label nameValue=checkoutLozenge
                            labelKey='repository.global.checkout'
                            escape=false /]

                        [#--visible when pullRequests branch workflow is chosen--]
                        [@s.label id="pullRequestsBranchUpdaterMergeFrom"
                                    labelKey='repository.global.mergeFrom'
                                    escape=false ]
                            [@s.param name='nameValue']
                                [@ui.branchLozenge planBranchName=pullRequestTargetBranch cssClass='checkout-lozenge'/]
                            [/@s.param]
                        [/@s.label]

                        [#--visible when branches branch workflow is chosen--]
                        [@ww.select id="branchesBranchUpdaterMergeFrom" name=prefix+'.branchUpdater.mergeFromBranch'
                            listKey='key.planKey.toString()'
                            listValue='key.buildName'
                            list=branchesForAutoIntegration
                            labelKey='repository.global.mergeFrom'
                            fullWidthField=true
                            groupBy='value' /]

                        [@ww.label labelKey='global.verbs.build' nameValue=mergeResultText /]

                        [@pushGroup]
                            [@ww.checkbox name=prefix+".branchUpdater.pushEnabled" label=pushLozenge /]
                        [/@pushGroup]
                    [/@ui.bambooSection]
            </div>
            <div class="aui-item">
                [@ui.bambooSection id="gate-keeper" cssClass="integration-strategy"]
                        [@ww.radio name=prefix+'.strategy'
                            template='radio.ftl'
                            fieldValue='GATE_KEEPER'
                            labelKey='branch.integration.strategy.gateKeeper'
                            helpKey='branch.autointegration.gateKeeper'/]

                        [@ww.select name=prefix+'.gateKeeper.checkoutBranch'
                            listKey='key.planKey.toString()'
                            listValue='key.buildName'
                            list=branchesForAutoIntegration
                            labelKey='repository.global.checkout'
                            fullWidthField=true
                            groupBy='value' /]

                        [@ww.label nameValue=checkoutLozenge
                            labelKey='repository.global.mergeFrom'
                            escape=false /]

                        [@ww.label labelKey='global.verbs.build' nameValue=mergeResultText /]

                        [@pushGroup]
                            [@ww.checkbox name=prefix+".gateKeeper.pushEnabled" label=pushLozenge /]
                        [/@pushGroup]
                    [/@ui.bambooSection]
            </div>
        </div>
        [#assign integrationEnabledName=prefix+".enabled"/]
        [#assign integrationStrategyName=prefix+".strategy"/]
        [#assign gateKeeperCheckoutBranchName=prefix+".gateKeeper.checkoutBranch"/]
        [#assign gateKeeperPushBranchId="#label_saveChainBranchDetails_branchIntegration_gateKeeper_pushEnabled"/]
        [#if configuringDefaults][#assign gateKeeperPushBranchId="#label_chain_branch_branches_defaultBranchIntegration_gateKeeper_pushEnabled"/][/#if]
        [#assign planBranchCreationInputName="planBranchCreation"/]
        [#assign removedBranchCleanUpInputName="deletePlanBranchWhenBranchRemovedFromVcs"/]
        [#assign inactiveBranchCleanUpInputName="deletePlanBranchWhenBranchIsInactiveInVcs"/]

        <script>
            BAMBOO.BRANCHES.EditChainBranchDetails({
               controls: {
                   form: [#if configuringDefaults]'#chain_branch'[#else]'#saveChainBranchDetails'[/#if],
                   integrationEnabled: 'input[name="${integrationEnabledName}"]',
                   integrationStrategy: 'input[name="${integrationStrategyName}"]',
                   gateKeeperCheckoutBranch: 'select[name="${gateKeeperCheckoutBranchName}"]',
                   gateKeeperPushBranch: '${gateKeeperPushBranchId} .name',
                   planBranchCreation: 'input[name="${planBranchCreationInputName}"]',
                   removedBranchCleanUp: 'input[name="${removedBranchCleanUpInputName}"]',
                   inactiveBranchCleanUp: 'input[name="${inactiveBranchCleanUpInputName}"]',
                   pullRequestsBranchUpdaterMergeFrom: 'span[id="pullRequestsBranchUpdaterMergeFrom"]',
                   branchesBranchUpdaterMergeFrom: 'select[id="branchesBranchUpdaterMergeFrom"]'
               }
            }).init();
        </script>
        [/@ui.bambooSection]
    [/@ui.bambooSection]
[/#macro]

[#macro pushGroup]
    [@ww.text name='repository.global.push' var='pushOnSuccess'][@ww.param]<span class="assistive xxx">[/@ww.param][@ww.param]</span>[/@ww.param][/@ww.text]
<fieldset class="group">
    <legend><span>${pushOnSuccess}[@ui.icon type='successful' /]</span></legend>
    [#nested/]
</fieldset>
[/#macro]

[#macro mergingNotAvailableMessage gitRepository defaultRepositoryDefinition defaultRepositoryType]
    [#if gitRepository]
        [#assign unsupportedWarning]
            [#if fn.hasGlobalAdminPermission()]
                [@ww.text name='branch.integration.unsupported.git.add']
                    [@ww.param][@ww.url action='configureSharedLocalCapabilities' namespace='/admin/agent'/][/@ww.param]
                [/@ww.text]
            [#else]
                [@ww.text name='branch.integration.unsupported.git.contact.admin' /]
            [/#if]
            <a href="[@help.href pageKey="branch.gitCapabilityHelp"/]" rel="help">[@ui.icon type="help"/]</a>
        [/#assign]
    [#else]
        [#assign unsupportedWarning]
            [@ww.text name='branch.integration.unsupported']
                [@ww.param]${defaultRepositoryDefinition.name}[/@ww.param]
                [@ww.param]${defaultRepositoryType}[/@ww.param]
            [/@ww.text]
        [/#assign]
    [/#if]
    [@ui.bambooPanel titleKey='branch.integration.edit' headerWeight='h3']
        [@ui.messageBox type="warning" content=unsupportedWarning /]
    [/@ui.bambooPanel]
[/#macro]