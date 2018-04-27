[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.DeleteStageAction" --]

[#if immutablePlan.isActive()]
    [@ww.form action='stopPlan' namespace='/build/admin/ajax' cssClass='top-label']
        <div class="field-group">
            [@ww.text name='stage.delete.running']
                [@ww.param]${stageName}[/@ww.param]
                [@ww.param]${immutablePlan.getName()}[/@ww.param]
            [/@ww.text]
        </div>
        [@ww.hidden name="planKey" value="${immutablePlan.key}"/]
    [/@ww.form]
[#else]
    [@ww.form action='deleteStage' namespace='/ajax' cssClass='top-label']
        <div class="field-group">
            [@ww.text name='stage.delete.description']
                [@ww.param]${stageName}[/@ww.param]
                [@ww.param value='${immutableChainStage.getJobs().size()}'/]
            [/@ww.text]
        </div>

        [#if jobsContainingInvalidSubscriptions?has_content ]
            <div class="field-group">
                [#import "/fragments/artifact/artifacts.ftl" as artifacts/]
                [@ww.text name='job.remove.confirm.subscriptions' var='confirmationMsg'/]
                [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg headerWeight='h3'/]
            </div>
        [/#if]

        [@ww.hidden name="buildKey"/]
        [@ww.hidden name='stageId'/]
    [/@ww.form]
[/#if]
