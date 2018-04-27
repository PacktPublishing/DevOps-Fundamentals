[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ImportMavenPlanCreatePlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ImportMavenPlanCreatePlanAction" --]

[#import "/lib/notifications.ftl" as notifications]

<html>
<head>
    [@ui.header pageKey='plan.create.maven.title' title=true /]
    <meta name="decorator" content="atl.general"/>
    <meta name="topCrumb" content="create"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
    [@ui.header pageKey="plan.create.maven.title" descriptionKey='importWithMaven.confirm.description' /]
    
    [@ww.form action='importMavenPlanCreatePlan' namespace='/build/admin/create'
              method="post" enctype="multipart/form-data"
              titleKey='importWithMaven.confirm.title'
              submitLabelKey='global.buttons.confirm'
               cancelUri='/start.action'
    ]
        [#-- Plan details --]
        [@ui.bambooSection]
            [#include "/fragments/project/selectCreateProject.ftl"]
            [#include "/fragments/chains/editChainKeyName.ftl"]
            [@s.checkbox fieldLabelKey='chain.access.public.label' labelKey='chain.access.public' name='publicPlanAccess' /]
            [@s.select key='importWithMaven.executable.type' name='tmp.mavenExecutable' 
            list=availableMavenBuilders listKey='key' listValue='value'/]
        [/@ui.bambooSection]

        [#-- Repository information details --]
        [@ui.bambooSection titleKey='repository.title']

            [#assign repositoryList = vcsTypeSelectors /]

            [@s.select labelKey='repository.type' name='selectedRepository' toggle='true' list=repositoryList listKey='key' listValue='name'/]

            [@ui.bambooSection id='repository-id']
                [@s.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" maxlength="${repositoryNameMaxLength}" required=true/]
            [/@ui.bambooSection]

            [#list repositoryList as repository]
                [@ui.bambooSection dependsOn='selectedRepository' showOn='${repository.key}']
                    ${repository.htmlFragments.locationHtml!}
                    ${repository.htmlFragments.branchHtml!}
                [/@ui.bambooSection]
            [/#list]


            [@s.select id="selectedWebRepositoryViewer" labelKey='webRepositoryViewer.type' name='selectedWebRepositoryViewer' toggle='true'
                list='viewerSelectors' listKey='key' listValue='name'/]

            [#list viewerSelectors as viewer]
                [#if viewer.html!?has_content]
                    [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn=viewer.key]
                    ${viewer.html!}
                    [/@ui.bambooSection]
                [/#if]
            [/#list]
        [/@ui.bambooSection]

        [#-- Notification details --]
        [@ui.bambooSection titleKey='notification.title']
            [#if notificationSet.notificationRules?has_content]
                <table id="notificationTable" class="aui">
                    <colgroup>
                        <col width="40%">
                        <col>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>[@ww.text name='bulkAction.notification.eventHeading' /]</th>
                            <th>[@ww.text name='bulkAction.notification.recipientHeading' /]</th>
                        </tr>
                    </thead>
                    <tbody>
                    [#list notificationSet.sortedNotificationRules  as notification]
                        [#-- Setting the newRow group variable --]
                        [#assign thisNotificationType ]
                            [@notifications.notificationType notification /]
                        [/#assign]

                        [#if !lastNotificationType?has_content || lastNotificationType != thisNotificationType]
                            [#assign newRow = true /]
                        [#else]
                            [#assign newRow = false /]
                        [/#if]

                        [#assign lastNotificationType=thisNotificationType /]

                        <tr [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if] >
                            <td>
                                [#if newRow]${thisNotificationType}[/#if]
                            </td>
                            <td [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if]>
                                [@notifications.notificationRecipient notification /]
                            </td>
                        </tr>
                    [/#list]
                    </tbody>
                </table>
            [#else]
                <p>[@ww.text name='notification.empty' /]</p>
            [/#if]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="plan.create.enable.title"]
            [@ww.checkbox labelKey="plan.create.enable.option" name='tmp.createAsEnabled' descriptionKey='plan.create.enable.description'/]
        [/@ui.bambooSection]
        [#--More fields to edit the parsed plan details to go here...?--]
    [/@ww.form]

    <script type="text/javascript">
        if (typeof AJS !== 'undefined') {
            AJS.$(function () {
                var mutateSelectedWebRepo = function () {
                    BAMBOO.DynamicFieldParameters.mutateSelectListContent(
                        AJS.$(this), AJS.$('#selectedWebRepositoryViewer'),
                        AJS.$.parseJSON('${uiConfigBean.webRepositoryJson}')
                    );
                };

                var $selectedRepository = AJS.$('#selectedRepository').change(mutateSelectedWebRepo);
                mutateSelectedWebRepo.call($selectedRepository);
            });
        }
    </script>
</body>
</html>
