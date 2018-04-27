[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.ConfigureBranches" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.ConfigureBranches" --]
[#import "../chain/edit/editChainConfigurationCommon.ftl" as eccc/]
[#import "/lib/chains.ftl" as cn]
[#import "branchesCommon.ftl" as bc/]

[#assign buttonsToolbar]
    [#if fn.hasPlanPermission('ADMINISTRATION', immutablePlan)]
        [@s.url var="createBranchUrl" action="newPlanBranch" namespace="/chain/admin" planKey=planKey returnUrl=currentUrl /]
        [@cp.displayLinkButton
            buttonId="createBranch"
            buttonLabel="branch.create.new.title"
            buttonUrl=createBranchUrl
            cssClass="doNotDisableInPlanConfigReadOnlyMode"
            extraAttributes={"data-bamboo-analytics-event":"bamboo.create.plan.branch.branches.link"}
        /]

        <script type="text/javascript">
            BAMBOO.redirectToBranchRepositoryConfig = function (data) {
                window.location = AJS.contextPath() + data.redirectUrl;
            }
        </script>
        [@dj.simpleDialogForm triggerSelector="#createBranch" width=710 height=500 headerKey="branch.create.new.title" submitCallback="BAMBOO.redirectToBranchRepositoryConfig" /]
    [/#if]
[/#assign]

[@eccc.editChainConfigurationPage plan=immutablePlan selectedTab="chain.branch" titleKey="chain.config.branches" descriptionKey="chain.config.branches.description" tools=buttonsToolbar ]
    [#if !fn.hasPlanPermission('ADMINISTRATION', immutablePlan)]
        [@ui.messageBox type="warning" titleKey="chain.config.branches.permission.error" /]
    [#else]
        [@s.form action="updateBranches"
            namespace="/chain/admin/config"
            showActionErrors="false"
            id="chain.branch"
            cancelUri="/browse/${immutablePlan.key}/config"
            submitLabelKey="global.buttons.update"]

            [@s.hidden name="planKey" /]

            [#if action.branchDetectionCapable]

                [#-- Create plan branch --]
                [@ui.bambooSection titleKey="chain.config.branches.creation"]
                    [@s.radio id="planBranchCreation"
                        name="planBranchCreation"
                        toggle=true
                        list=branchCreationTypes
                        i18nPrefixForValue="chain.config.branches.creation.radio"
                        listValue="key"
                        listKey="key"/]

                    [@ui.bambooSection dependsOn="planBranchCreation" showOn="matching_vcs_branch" cssClass="planBranchCreationRegularExpressionGroup"]
                        [@s.textfield id="planBranchCreationRegularExpression"
                            name="planBranchCreationRegularExpression"
                            description=i18n.getText("chain.config.branches.creation.radio.matching_vcs_branch.description")
                            longField=true/]
                    [/@ui.bambooSection]
                [/@ui.bambooSection]

                [#-- Delete plan branch --]
                [@ui.bambooSection titleKey="chain.config.branches.deletion"]
                    [#assign cleanupPeriodUnits]
                        <span class="aui-form">[@s.text name="chain.config.branches.cleanup.period.unit"/]</span>
                    [/#assign]

                    [#-- When removed --]
                    [@s.checkbox id="deletePlanBranchWhenBranchRemovedFromVcs"
                        labelKey="chain.config.branches.deletion.branch.deleted"
                        name="deletePlanBranchWhenBranchRemovedFromVcs"
                        toggle="true"/]

                    [@ui.bambooSection dependsOn="deletePlanBranchWhenBranchRemovedFromVcs"]
                        [@s.textfield id="removedBranchCleanUpPeriodInDays"
                            name="removedBranchCleanUpPeriodInDays"
                            cssClass="short-field"
                            after=cleanupPeriodUnits /]
                    [/@ui.bambooSection]

                    [#-- When inactive --]
                    [@s.checkbox id="deletePlanBranchWhenBranchIsInactiveInVcs"
                        labelKey="chain.config.branches.deletion.branch.inactive"
                        name="deletePlanBranchWhenBranchIsInactiveInVcs"
                        toggle="true"/]

                    [@ui.bambooSection dependsOn="deletePlanBranchWhenBranchIsInactiveInVcs"]
                        [@s.textfield id="inactiveBranchCleanUpPeriodInDays"
                            name="inactiveBranchCleanUpPeriodInDays"
                            cssClass="short-field"
                            after=cleanupPeriodUnits /]
                    [/@ui.bambooSection]
                [/@ui.bambooSection]

                [#-- Repository-specific configuration section --]
                [#if repositoryEditHtml??]
                    [@ui.bambooSection id="branchDetectionOptionsSection" titleKey="repository.specific.branch.detection.option"]
                    ${repositoryEditHtml.branchDetectionOptionsHtml!}
                    [/@ui.bambooSection]
                [/#if]

                [#if mergeCapable]
                    [@bc.showIntegrationStrategyConfiguration chain=immutableChain branchesForAutoIntegration=branchesForAutoIntegration configuringDefaults=true titleKey="chain.config.branches.merging.edit"/]
                [#elseif defaultRepositoryDefinition??]
                    [@bc.mergingNotAvailableMessage action.isGitRepository() defaultRepositoryDefinition defaultRepositoryType/]
                [/#if]

            [#else]
                [@ui.bambooPanel titleKey="chain.config.branches.automatic.management.title" description=automaticallyCreateBranches headerWeight="h3"]
                    [@ui.messageBox titleKey="chain.config.branches.detection.error"]
                    <p>[@s.text name="chain.config.branches.detection.error.message" /]</p>
                    [/@ui.messageBox]
                [/@ui.bambooPanel]
            [/#if]


            [#if jiraApplicationLinkDefined]
                [@ui.bambooSection titleKey="chain.config.branches.issueLinking" descriptionKey="chain.config.branches.issueLinking.description"]
                    [@s.checkbox labelKey="chain.config.branches.issueLinkingEnabled" name="remoteJiraBranchLinkingEnabled" helpKey="branch.featureBranches"/]
                [/@ui.bambooSection]
            [/#if]

            [@ui.bambooSection titleKey="chain.config.branches.notifications" descriptionKey="chain.config.branches.notifications.description" headerWeight="h3"]
                [@s.radio name="defaultNotificationStrategy"
                listKey="key"
                listValue="key"
                i18nPrefixForValue="chain.config.branches.notifications"
                showDescription=true
                list=notificationStrategies /]
            [/@ui.bambooSection]

            [@ui.bambooSection titleKey="chain.config.branches.triggering" descriptionKey="chain.config.branches.triggering.description" headerWeight="h3"]
                [@s.select
                    key="chain.config.branches.triggering.title"
                    name="branchTriggering"
                    list=branchTriggeringOptions
                    i18nPrefixForValue="chain.config.branches.triggering.select"
                    listValue="key"
                    listKey="key"
                    longField=true/]
            [/@ui.bambooSection]
        [/@s.form]
    [/#if]

    [#if !hideBranchesSplashScreen]
        [@s.text name="branch.splash.description" var="branchSplashDescription" /]
        [#assign dialogContent][#rt/]
            <p>${branchSplashDescription?replace('\n', '<br>')?replace('<br><br>', '</p><p>')}</p>[#t/]
            <p>[@help.url pageKey="branch.using.plan.branches"][@s.text name="branch.splash.learnmore" /][/@help.url]</p>[#t/]
        [/#assign][#lt/]
        <script type="text/x-template" title="dontShowCheckbox-template">
            [@s.checkbox name="dontshow" labelKey="branch.splash.dontshowagain" /]
        </script>
        <script type="text/javascript">
            BAMBOO.BRANCHES.BranchesSplashScreen.init({ content: '${dialogContent?js_string}', templates: { dontShowCheckbox: 'dontShowCheckbox-template' } });
        </script>
    [/#if]
[/@eccc.editChainConfigurationPage]