[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.plan.DeletePlan" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.plan.DeletePlan" --]

[#if immutablePlan.isActive()]
    [@ww.form action='stopPlan' namespace='/build/admin/ajax' cssClass='top-label']
        [#if fn.isChain(immutablePlan)]
            <div class="field-group">
                [@ww.text name='chain.delete.stop']
                    [@ww.param]'${immutablePlan.getName()}'[/@ww.param]
                    [@ww.param value='${action.getNumberOfExecutions(immutablePlan.planKey)}'/]
                [/@ww.text]
            </div>
        [#elseif fn.isJob(immutablePlan)]
            <div class="field-group">
                [@ww.text name='job.delete.stop']
                    [@ww.param]${immutablePlan.getName()}[/@ww.param]
                    [@ww.param]${immutablePlan.parent.getName()}[/@ww.param]
                    [@ww.param value='${action.getNumberOfExecutions(immutablePlan.getParent().getPlanKey())}'/]
                [/@ww.text]
            </div>
        [/#if]

        [@ww.hidden name="planKey" value="${immutablePlan.key}"/]
    [/@ww.form]
[#else]
    [@ww.form action='deleteChain' namespace='/ajax' cssClass='top-label']
        [#if fn.isChain(immutablePlan) && !fn.isBranch(immutablePlan)]
            <div class="field-group">
                [@ww.text name='chain.delete.description']
                    [@ww.param]${immutablePlan.getName()}[/@ww.param]
                    [@ww.param value='${action.numberOfChainBranches}'/]
                    [@ww.param value='${immutablePlan.stages.size()}'/]
                    [@ww.param value='${immutablePlan.getJobCount()}'/]
                [/@ww.text]
            </div>
        [#elseif fn.isBranch(immutablePlan)]
            <div class="field-group">
                [@ww.text name='branch.delete.description']
                    [@ww.param]${immutablePlan.getName()}[/@ww.param]
                [/@ww.text]
            </div>
        [#elseif fn.isJob(immutablePlan)]
            <div class="field-group">
                [@ww.text name='job.delete.description']
                    [@ww.param]${immutablePlan.getName()}[/@ww.param]
                [/@ww.text]
            </div>
        [/#if]

        [#assign linkedDeploymentProjects=linkedDeploymentProjects]
        [#if linkedDeploymentProjects?has_content]
            <div id="linkedDeployments" class="field-group">
                <h3>[@ww.text name='chain.delete.linkedDeployments.header'/]</h3>
                <p>[@ww.text name='chain.delete.linkedDeployments.description'/]</p>
                <ul>
                    [#list linkedDeploymentProjects as deploymentProject]
                        <li>${deploymentProject.name?html}</li>
                    [/#list]
                </ul>
            </div>
        [/#if]

        [#assign jobsContainingInvalidSubscriptions=jobsContainingInvalidSubscriptions]
        [#if jobsContainingInvalidSubscriptions?has_content ]
            <div class="field-group">
                [#import "/fragments/artifact/artifacts.ftl" as artifacts/]
                [@ww.text name='job.remove.confirm.subscriptions' var='confirmationMsg'/]
                [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg headerWeight='h3'/]
            </div>
        [/#if]

        [@ww.hidden name="buildKey"/]
    [/@ww.form]
[/#if]
