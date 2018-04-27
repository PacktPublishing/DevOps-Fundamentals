[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]

[#import "/lib/build.ftl" as bd]
[#import "/lib/menus.ftl" as menu]
[#import "editBuildConfigurationCommon.ftl" as ebcc/]

[#assign artifactDefinitionTools]
    [@s.url var='createArtifactDefinitionUrl' value='/ajax/addArtifactDefinition.action' planKey=planKey returnUrl=currentUrl/]
    [@cp.displayLinkButton buttonId='createArtifactDefinitionButton' buttonLabel='artifact.definition.create' buttonUrl=createArtifactDefinitionUrl /]
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    <h2>${navigationContext.currentObject.displayName}</h2>
    [@menu.displayJobsTabs
        currentPlan=navigationContext.currentObject
        selectedTab="artifacts"
    /]
[/#if]

<script type="text/javascript">
    BAMBOO.createArtifactDefinitionCallback = function(result) {
        window.location.reload(true);
    }

    BAMBOO.createArtifactSubscriptionCallback = function(result) {
        window.location.reload(true);
    }
</script>

[@ebcc.editConfigurationPage descriptionKey='artifact.definition.description' plan=immutablePlan selectedTab='artifacts' titleKey='artifact.definition.title' tools=artifactDefinitionTools]

    [@dj.simpleDialogForm
        triggerSelector="#createArtifactDefinitionButton"
        width=700 height=460
        submitCallback="BAMBOO.createArtifactDefinitionCallback"
    /]

    [@ui.bambooPanel titleKey='' auiToolbar=artifactDefinitionTools content=true ]
        [@bd.displayArtifactDefinitions artifactDefinitions=artifactDefinitions showOperations=true planIsUsedInDeployments=planUsedInDeployments/]
    [/@ui.bambooPanel]

    [@ui.renderWebPanels 'job.configuration.artifact.definitions'/]

    [#if artifactSubscriptionPossible]
        [#assign artifactSubscriptionTools]
            [@s.url var='createArtifactSubscriptionUrl' value='/ajax/addArtifactSubscription.action' planKey=planKey returnUrl=currentUrl/]
            [@cp.displayLinkButton buttonId='createArtifactSubscriptionButton' buttonLabel='artifact.subscription.create' buttonUrl=createArtifactSubscriptionUrl /]
        [/#assign]

        [@dj.simpleDialogForm
            triggerSelector="#createArtifactSubscriptionButton"
            width=700 height=300
            submitCallback="BAMBOO.createArtifactSubscriptionCallback"
        /]

        [@ui.bambooPanel titleKey='artifact.consumed.title' descriptionKey='artifact.consumed.description' auiToolbar=artifactSubscriptionTools content=true ]
            [@bd.displayArtifactSubscriptions artifactSubscriptions=artifactSubscriptions showOperations=true/]
        [/@ui.bambooPanel]
    [/#if]

    [#if featureManager.getBuildArtifactSizeLimit().isPresent()]
        [@ui.bambooPanel titleKey='artifact.size.quota.title']
            [@ui.messageBox type='warning']
                [@ww.text name='artifact.size.quota.exceeded.info']
                    [@ww.param ]${action.getNiceSizeMessage(featureManager.getBuildArtifactSizeLimit().get())}[/@ww.param]
                [/@ww.text]
            [/@ui.messageBox]
        [/@ui.bambooPanel]
    [/#if]

    [@ui.renderWebPanels 'job.configuration.artifact.subscriptions'/]
[/@ebcc.editConfigurationPage]