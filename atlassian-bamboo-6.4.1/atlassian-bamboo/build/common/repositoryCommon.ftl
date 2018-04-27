[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.EditRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.EditRepository" --]
[#-- @ftlvariable name="vcsTypeSelector" type="com.atlassian.bamboo.configuration.repository.VcsUIConfigBean.VcsTypeSelector" --]

[#macro repositoryTypePicker vcsTypeSelectors selectionUrl planKey=""]
    [#if vcsTypeSelectors?has_content]
    <ul class="trigger-type-list">
        [#list vcsTypeSelectors as vcsTypeSelector]
            [#assign repositoryTypeClass][#rt]
                [#if vcsTypeSelector.group?has_content]repository-type-category-linked[#else]repository-type-category-new[/#if]
            [/#assign][#lt]

            <li[#if repositoryTypeClass?has_content] class="${repositoryTypeClass}"[/#if]>
                <span class="task-type-icon-holder" [#if vcsTypeSelector.icon??] style="background-image: url(${vcsTypeSelector.icon})" [/#if]></span>

                <h3 class="trigger-type-title">
                    <a id="create-${vcsTypeSelector.key}" href="${selectionUrl}[#if planKey?has_content]&amp;[#else]?[/#if]selectedRepository=${vcsTypeSelector.key}">${vcsTypeSelector.name?html}</a>
                </h3>
                [#if vcsTypeSelector.description??]
                    <div class="trigger-type-description">${vcsTypeSelector.description?html}</div>
                [/#if]
            </li>
        [/#list]
    </ul>
    [/#if]
[/#macro]

[#macro changeDetectionOptionsEdit vcsTypeSelector]
    [#assign changeDetectionOptionsHtml = vcsTypeSelector.htmlFragments.changeDetectionOptionsHtml!]
    [#if changeDetectionOptionsHtml?has_content]
        [@ui.bambooSection id="changeDetectionOptionsSection" titleKey='repository.change.detection.option' collapsible=true isCollapsed=true]
            ${changeDetectionOptionsHtml!}
        [/@ui.bambooSection]
    [/#if]
[/#macro]

[#macro branchDetectionOptionsEdit vcsTypeSelector]
    [#assign branchDetectionOptionsHtml = vcsTypeSelector.htmlFragments.branchDetectionOptionsHtml!]
    [#if branchDetectionOptionsHtml?has_content]
        [@ui.bambooSection id="branchDetectionOptionsSection" titleKey='repository.branch.detection.option' collapsible=true isCollapsed=false]
            ${branchDetectionOptionsHtml!}
        [/@ui.bambooSection]
    [/#if]
[/#macro]

[#macro branchEdit vcsTypeSelector]
    ${vcsTypeSelector.htmlFragments.branchHtml!}
[/#macro]

[#macro webRepositoryViewerEdit vcsTypeSelector]
    [@ui.bambooSection id='webRepositoryViewerEditSection' titleKey='webRepositoryViewer.type' collapsible=true isCollapsed=true]
        [@ui.bambooSection]
            [@ww.select id="selectedWebRepositoryViewer" labelKey='webRepositoryViewer.type' name='selectedWebRepositoryViewer' toggle='true'
                list='viewerSelectors' listKey='key' listValue='name']
            [/@ww.select]
        [/@ui.bambooSection]

        [#list viewerSelectors as viewer]
            [#if viewer.html!?has_content]
                [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn=viewer.key]
                    ${viewer.html!}
                [/@ui.bambooSection]
            [/#if]
        [/#list]
    [/@ui.bambooSection]
[/#macro]

[#macro advancedRepositoryEdit vcsTypeSelector]
    [#if vcsTypeSelector.htmlFragments.advancedServerOptionsHtml?has_content]
        [@ui.bambooSection id='advancedRepositoryEditSection' titleKey='repository.advanced.option' collapsible=true isCollapsed=true]
            ${vcsTypeSelector.htmlFragments.advancedServerOptionsHtml!}
        [/@ui.bambooSection]
    [/#if]
[/#macro]

[#macro displayLinkedRepository vcsTypeSelector plan]
    [#if vcsTypeSelector??]
        <div id="repository-shared-${vcsTypeSelector.key}" class="repository" data-key="${vcsTypeSelector.key}">
            [@ww.label labelKey='repository.type' value=vcsTypeSelector.type /]

            ${vcsTypeSelector.htmlFragments.locationHtml!}
            ${vcsTypeSelector.htmlFragments.branchHtml!}
            ${vcsTypeSelector.htmlFragments.advancedServerOptionsHtml!}
            ${vcsTypeSelector.htmlFragments.changeDetectionOptionsHtml!}

            [#if plan?has_content && vcsTypeSelector.webRepositoryViewer?has_content]
                ${vcsTypeSelector.webRepositoryViewer.getViewHtml(plan)!}
            [/#if]
        </div>
    [/#if]
[/#macro]

[#macro viewGlobalRepositoryUsages planUsingRepository hiddenPlansUsingRepositoryCount environmentUsingRepository hiddenEnvironmentsUsingRepositoryCount]
[#-- @ftlvariable name="environmentUsingRepository" type="java.util.List<com.atlassian.bamboo.deployments.environments.DecoratedEnvironment>" --]
    <h3>[@s.text name="repository.shared.usages.header"/]</h3>
    [#if planUsingRepository?has_content || hiddenPlansUsingRepositoryCount > 0]
        <p>[@s.text name="repository.shared.usages.description"/]</p>
        <ul>
            [#list planUsingRepository as planIdentifier]
                <li>[@ui.renderPlanNameLink plan=planIdentifier /]</li>
            [/#list]
            [#if hiddenPlansUsingRepositoryCount > 0]
                <li>[@s.text name="repository.shared.usages.plan.hidden" ][@s.param value=hiddenPlansUsingRepositoryCount /][/@s.text]</li>
            [/#if]
        </ul>
    [#else]
        <p>[@s.text name="repository.shared.noUses"/]</p>
    [/#if]

    <h3>[@s.text name="environment.repository.shared.usages.header"/]</h3>
    [#if environmentUsingRepository?has_content || hiddenEnvironmentsUsingRepositoryCount > 0 ]
        <p>[@s.text name="environment.repository.shared.usages.description"/]</p>
        <ul>
            [#list environmentUsingRepository as environment]
                <li>[@ui.renderEnvironmentNameLink environment=environment /]</li>
            [/#list]
            [#if hiddenEnvironmentsUsingRepositoryCount > 0]
                <li>[@s.text name="repository.shared.usages.env.hidden" ][@s.param value=hiddenEnvironmentsUsingRepositoryCount /][/@s.text]</li>
            [/#if]
        </ul>
    [#else]
        <p>[@s.text name="environment.repository.shared.noUses"/]</p>
    [/#if]
[/#macro]

[#macro repositoryNewSelector vcsTypeSelectors selectedRepository]
    <div id="repository-selector-new">
        <a id="repository-other" href="#repository-other-dropdown" aria-owns="repository-other-dropdown" aria-haspopup="true" class="aui-button aui-dropdown2-trigger aui-style-default">
            [@ww.text name="repository.type.select" /]
        </a>
        <div id="repository-other-dropdown" class="aui-dropdown2 aui-style-default">
            <div class="aui-dropdown2-section">
                <ul class="aui-list-truncate">
                    [#list vcsTypeSelectors as vcsTypeSelector]
                        <li class="option" data-key="${vcsTypeSelector.key}">
                            <a href="#${vcsTypeSelector.key}">${vcsTypeSelector.name?html}</a>
                        </li>
                    [/#list]
                </ul>
            </div>
        </div>
    </div>
    <div id="repository-display-name" class="hidden">
        [@ww.textfield name="repositoryName" labelKey="plan.create.repository.name" required=true placeholderKey="plan.create.repository.placeholder" /]
    </div>
    <div id="repository-forms">
        [#list vcsTypeSelectors as vcsTypeSelector]
            <div id="repository-${vcsTypeSelector.key}" class="repository hidden">
                <h4>${vcsTypeSelector.name} [@ww.text name="repository.details" /]</h4>
                ${vcsTypeSelector.htmlFragments.locationHtml!}
                ${vcsTypeSelector.htmlFragments.branchHtml!}
                [#if vcsTypeSelector.supportsConnectionTesting]
                    [@testRepositoryConnectionButton id="test-connection-" + vcsTypeSelector.key?replace('[^a-zA-Z0-9]', '-', 'r') /]
                [/#if]
            </div>
        [/#list]
    </div>
    [#if fn.hasAdminPermission() || fn.hasGlobalPermission('CREATEREPOSITORY')]
        <div id="repository-access-option" class="hidden">
            [@s.radio
                labelKey = 'repository.shared.access'
                name = 'linkedRepositoryAccessOption'
                list = uiConfigBean.linkedRepositoryAccessOptions
                i18nPrefixForValue="repository.shared.access"
                skipGroupCssClass = true
            /]
        </div>
    [/#if]
    <script type="text/javascript">
        require(['jquery', 'widget/repository-selector-new'], function($, RepositorySelectorNew){
            return new RepositorySelectorNew({
                el: $('#repository-selector-new')
            });
        });
    </script>
[/#macro]

[#macro repositoryLinkedSelector linkedRepositories selectedRepository createPlan=false]
    <div id="repository-selector-linked">
        <select id="sharedRepoSelect">
            [#list linkedRepositories as vcsTypeSelector]
                <option value="${vcsTypeSelector.key}" data-repo-name="${vcsTypeSelector.name?html}" [#if selectedRepository?has_content && selectedRepository == vcsTypeSelector.key]selected[/#if]>${vcsTypeSelector.name?html}</option>
            [/#list]
        </select>
        [#if !createPlan]
            <div class="repository-options">
                [#list linkedRepositories as vcsTypeSelector]
                    [@displayLinkedRepository vcsTypeSelector ""/]
                [/#list]
            </div>
        [/#if]
    </div>
    <script type="text/javascript">
        require(['jquery', 'widget/repository-selector-linked'], function($, RepositorySelectorLinked){
            return new RepositorySelectorLinked({
                el: $('#repository-selector-linked'),
                params: {
                    placeholder: '[@ww.text name='repository.linked.label' /]'
                }
            });
        });
    </script>
[/#macro]

[#macro repositorySelector vcsTypeSelectors linkedRepositories repositoryTypeOption selectedRepository="" hasCreateRepoPermission=true]
    <div id="repository-selector">
        <div class="group">
            [@s.label key="repository.type" escapeHtml=false required=true]
                [@ww.param name="value"]
                    [@ww.hidden id="selectedRepository" name="selectedRepository"
                        value=selectedRepository cssClass="handleOnSelectShowHide handleDynamicDescription"
                    /]
                    <div class="aui-group">
                        <div class="aui-item">
                            [#if linkedRepositories?has_content]
                                <div class="radio">
                                    <input
                                        id="repositoryTypeLinkedOption" name="repositoryTypeOption"
                                        class="radio handleOnSelectShowHide" type="radio" value="LINKED" autocomplete="off"
                                        [#if repositoryTypeOption == "LINKED"]checked="checked"[/#if]
                                    >
                                    <label for="repositoryTypeLinkedOption">[@ww.text name="repository.type.linked.label" /]</label>
                                    [@ui.bambooSection dependsOn='repositoryTypeOption' showOn='LINKED']
                                        [@repositoryLinkedSelector linkedRepositories selectedRepository true /]
                                    [/@ui.bambooSection]
                                </div>
                            [/#if]
                            [#if hasCreateRepoPermission]
                                <div class="radio">
                                    <input
                                        id="repositoryTypeCreateOption" name="repositoryTypeOption"
                                        class="radio handleOnSelectShowHide" type="radio" value="NEW" autocomplete="off"
                                        [#if repositoryTypeOption == "NEW"]checked="checked"[/#if]
                                    >
                                    <label for="repositoryTypeCreateOption">[@ww.text name="repository.type.create.label" /]</label>
                                    [@ui.bambooSection dependsOn='repositoryTypeOption' showOn='NEW' cssClass="repository-section"]
                                        [@repositoryNewSelector vcsTypeSelectors selectedRepository/]
                                    [/@ui.bambooSection]
                                    [#if (fieldErrors["selectedRepository"])?has_content]
                                        [#list fieldErrors["selectedRepository"] as error]
                                            <div class="error control-form-error">${error?html}</div>
                                        [/#list]
                                    [/#if]
                                </div>
                            [/#if]
                            <div class="radio [#if !hasCreateRepoPermission?has_content && !linkedRepositories?has_content]single[/#if]">
                                <input id="repositoryTypeNoneOption" name="repositoryTypeOption"
                                       class="radio handleOnSelectShowHide" type="radio" value="NONE" autocomplete="off"
                                       [#if repositoryTypeOption == "NONE"]checked="checked"[/#if]>
                                <label for="repositoryTypeNoneOption">[@ww.text name="repository.type.none.label" /]</label>
                            </div>
                        </div>
                    </div>
                [/@ww.param]
            [/@s.label]
        </div>
    </div>
    <script type="text/javascript">
        require(['jquery', 'widget/repository-selector'], function($, RepositorySelector){
            return new RepositorySelector({
                el: AJS.$('#repository-selector')
            });
        });
    </script>
[/#macro]

[#macro testRepositoryConnectionButton id]
    <div class="field-group">
        <div class="test-repository-connection-container">
            <button class="aui-button test-repository-connection" id="${id}">
                [@s.text name="repository.test.connection" /]
            </button>
            <script type="text/javascript">
                require(['jquery', 'feature/repository-connect'], function($, RepositoryConnect) {
                    new RepositoryConnect({ el: $('#' + '${id}') });
                });
            </script>
        </div>
    </div>
[/#macro]
