[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[@ww.text var="tasksConfigFormTitle" name="tasks.config.form.title"]
    [@ww.param]${taskName!?html}[/@ww.param]
[/@ww.text]

[@ww.form   action=submitAction
            namespace="/build/admin/edit"
            submitLabelKey="global.buttons.update"
            cancelUri="/build/admin/edit/editBuildTasks.action?planKey=${planKey}"
            cssClass="top-label"]


    <div class="task-heading">
        <h2>${tasksConfigFormTitle}</h2>
    </div>

    [#if taskHelpLink??]
    <div class="task-help">
        [#if taskHelpLink.usingPrefix == true]
            [@help.url pageKey="${taskHelpLink.key}"][@ww.text name="${taskHelpLink.key}.title"/][/@help.url]
        [#else]
            <a id='taskHelpLink' href='[@ww.text name="${taskHelpLink.linkKey}"/]'>[@ww.text name="${taskHelpLink.titleKey}"/]</a>
        [/#if]
    </div>
    [/#if]

    [@ww.textfield name="userDescription" labelKey="tasks.userDescription" descriptionClass="assistive" cssClass="long-field"/]
    [@ww.checkbox name="taskDisabled" labelKey="tasks.disable" fieldClass="disable-checkbox" /]

    [#if repositoriesForWorkingDirSelection?has_content]
        [@ww.select labelKey='tasks.workingDirectory'
                    name='workingDirSelector'
                    list='workingDirSelectorOptions'
                    toggle='true'
        /]
        [@ui.bambooSection dependsOn='workingDirSelector' showOn='REPOSITORY']
            [@ww.select labelKey='job.workingDirectory.definingRepository'
                name='repositoryDefiningWorkingDirectory'
                list='repositoriesForWorkingDirSelection'
            /]
        [/@ui.bambooSection]
    [/#if]

    ${editHtml!}

    [@ww.hidden name="createTaskKey"/]
    [@ww.hidden name="taskId"/]
    [@ww.hidden name="planKey"/]
[/@ww.form]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
<meta name="tab" content="structure" />
<script type="text/javascript">
    (function(root){
        root.require([
            'jquery',
            'page/plan-config/plan-config-app'
        ], function(
            $,
            planConfigApp
        ){
            var $content = $('.planconfig-content .jsLoadContent');
            root.BAMBOO.asyncForm({
                $delegator: $content,
                target: 'form',
                resetOnSuccess: true,
                success: function(data) {
                    if (root.location.pathname.indexOf('addTask.action') !== -1) {
                        var url = AJS.contextPath() + '/build/admin/edit/editTask.action?planKey=' +
                            $('input[name="planKey"]').val() + '&taskId=' + data.taskResult.task.id;
                        var callback = function(){
                            planConfigApp.layout.collection.off('change:job', callback);
                            $('.jsUnsaved').closest('li').remove();
                            planConfigApp.router.navigate(url);
                        };
                        planConfigApp.layout.collection.on('change:job', callback);
                    }

                    var job = planConfigApp.layout.collection.findByJob({
                        jobKey: $('input[name="planKey"]').val()
                    }, true);
                    if (job) {
                        planConfigApp.layout.collection.trigger('loading', '${planKey}');
                        job.fetch();
                    }

                    $('.planconfig-content .container')[0].scrollTop = 0;
                    $content.find('.aui-message-success').remove();
                    $('.task-heading').before(AJS.messages.success({
                        body: '[@ww.text name="planConfiguration.subMenu.confirmsave"/]',
                        closeable: false
                    }).delay(3000).fadeOut(function () {
                        $(this).remove();
                    }));

                    $content
                        .find(".buttons").find('.icon-loading').remove().end()
                        .find('input:submit').prop('disabled', false).end()
                        .find('.cancel').removeClass('disabled');
                },
                cancel: function() {
                    var structure = planConfigApp.layout.structure.currentView;
                    var jobLink = AJS.contextPath() + '/build/admin/edit/editBuildDetails.action?buildKey=' + $('input[name="planKey"]').val();
                    return structure.hasUnsavedTask() ?
                           structure.shouldAbandonUnsavedTask().then(planConfigApp.router.navigate.bind(planConfigApp.router, jobLink)) :
                            planConfigApp.router.navigate(jobLink);
                },
                formReplaced: function() {
                    root.BAMBOO.DynamicFieldParameters.syncFieldShowHide();
                }
            });
        });
    }(window.parent !== window ? window.parent : window));
</script>
[/#if]