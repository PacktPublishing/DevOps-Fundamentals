[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.EditRepository" --]
[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigSupportImpl" --]
[#-- snippet displayed in repository config right panel --]
[#import "/build/common/repositoryCommon.ftl" as rc]
[@ww.form action=submitAction
    method='POST'
    enctype='multipart/form-data'
    namespace="/chain/admin/config"
    submitLabelKey="repository.update.button"
    cancelUri="/chain/admin/config/editChainRepository.action?planKey=${planKey}"
    cssClass="top-label"
]

    [@ww.hidden name="planKey" value=planKey /]
    [@ww.hidden name="repositoryId" value=repositoryId /]

    [#if repositoryId > 0 && !derivedFromLinkedRepository && fn.hasGlobalPermission('CREATEREPOSITORY')]
        <div class="aui-toolbar inline share-repository-toolbar">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    [@ww.url var="convertActionUrl" action='convertLocalToGlobalRepository' namespace='/admin' repositoryId=repositoryId planKey=planKey/]
                    <a id="convertActionTrigger_${repositoryId}" href="${convertActionUrl}" class="aui-button repositoryTools toolbar-trigger convertRepositoryToLinked">[@ww.text name="repository.shared.convert"/]</a>
                </li>
            </ul>
        </div>
    [/#if]

    [#assign repo=currentVcsTypeSelector/]
    [@s.hidden name="selectedRepository" id="selectedRepository" value=repo.key/]

    [@s.label labelKey="repository.type" value=repo.name /]

    [#if repo.group?has_content]
        [#assign idForLink = repo.key/]
        [#if repositoryDefinition.inheritedData??]
            [#assign idForLink = repositoryDefinition.inheritedData.id/]
        [/#if]
        [#-- shared repository --]
        [@ui.bambooSection cssClass="global-repository-details"]
            [@ui.messageBox type="info" titleKey="repository.configuration"]
                [@ww.text name="repository.shared.edit"/]
                [#if fn.hasAdminPermission() || (fn.hasGlobalPermission("CREATE") && repo.hasReadPermission())]
                    [#if repositoryDashboardOn]
                        [@ww.url var="editSharedRepositoryUrl" namespace='/admin/repository' action="editLinkedRepository"  repositoryId=idForLink/]
                    [#else]
                        [@ww.url var="editSharedRepositoryUrl" namespace='/admin' action="configureLinkedRepositories"  repositoryId=idForLink/]
                    [/#if]
                    [#t]&nbsp;[@ww.text name="repository.shared.edit.admin"]
                        [@ww.param ]<a href="${editSharedRepositoryUrl}">[@ww.text name="repository.shared.edit.link"/]</a>[/@ww.param]
                    [/@ww.text]
                [/#if]
            [/@ui.messageBox]
            [@rc.displayLinkedRepository repo plan/]
        [/@ui.bambooSection]
    [#else]
        [#if repo.optionDescription??]
            <div class="description">${repo.optionDescription}</div>
        [/#if]

        [@ui.bambooSection id='repository-id']
            [@ww.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" maxlength="${repositoryNameMaxLength}" required=true/]
        [/@ui.bambooSection]

        [@ui.bambooSection id='repository-configuration']
            ${repo.htmlFragments.locationHtml!}
            [@rc.branchEdit vcsTypeSelector=repo/]
            [#if repo.supportsConnectionTesting]
                [@rc.testRepositoryConnectionButton id="test-connection-" + repo.key?replace('[^a-zA-Z0-9]', '-', 'r') /]
            [/#if]
            [@rc.branchDetectionOptionsEdit vcsTypeSelector=repo/]
            [@rc.advancedRepositoryEdit vcsTypeSelector=repo /]
            [@rc.changeDetectionOptionsEdit vcsTypeSelector=repo /]
            [@rc.webRepositoryViewerEdit vcsTypeSelector=repo /]
        [/@ui.bambooSection]
    [/#if]
[/@ww.form]