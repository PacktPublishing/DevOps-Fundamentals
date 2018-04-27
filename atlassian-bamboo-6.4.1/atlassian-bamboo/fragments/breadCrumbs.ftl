[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedObject" type="com.atlassian.bamboo.ww2.beans.DecoratedPlan" --]

[#macro showCrumbContainer rootTextKey='breadCrumbs.home' rootUrl='${req.contextPath}/start.action']
    <ol id="breadcrumb" class="aui-nav aui-nav-breadcrumbs">[#t]
        [@showCrumb link=rootUrl textKey=rootTextKey /][#t]
        [#nested][#t]
    </ol>[#t]
[/#macro]

[#macro showCrumb link id='' current=false text='' textKey='' cssClass='' extraAttributes={} tagName='li' disabled=false]
    [#local bcClass = cssClass /]
    [#if current && tagName != 'h1'][#local bcClass = cssClass + " aui-nav-selected" /][/#if]
    <${tagName}[#if bcClass?trim?has_content] class="${bcClass?trim}"[/#if]${fn.renderExtraAttributes(extraAttributes)}>[#t]
        [#nested][#t]
        <a href="${link}"[#if id?has_content] id="breadcrumb:${id}"[/#if]>[@ui.resolvedName text?html textKey /]</a>[#t]
    </${tagName}>[#t]
    [#if disabled]
        <span id="plan-disabled-lozenge">[#t]
            [@ui.lozenge textKey="global.buttons.disabled" /][#t]
        </span>[#t]
    [/#if]
[/#macro]

[#macro showBranchSelector decoratedObject]
    [#local branchMasterText][@ww.text name='branch.master.title' /][/#local]
    [#if fn.isBranch(decoratedObject)]
        [#local planKey = decoratedObject.master.key /]
        [#local text = decoratedObject.displayName /]
        [#local masterBranchName = (decoratedObject.master.branchName)!branchMasterText /]
        [#local masterBranchDescription = (decoratedObject.master.description)! /]
    [#elseif decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)]
        [#local planKey = decoratedObject.parent.master.key /]
        [#local text = decoratedObject.parent.displayName /]
        [#local masterBranchName = (decoratedObject.parent.master.branchName)!branchMasterText /]
        [#local masterBranchDescription = (decoratedObject.parent.master.description)! /]
    [#elseif decoratedObject.parent?has_content]
        [#local planKey = decoratedObject.result?string(decoratedObject.parent.planKey, decoratedObject.parent.key) /]
        [#local text = (decoratedObject.parent.branchName)!branchMasterText /]
        [#local masterBranchName = (decoratedObject.parent.branchName)!branchMasterText /]
        [#local masterBranchDescription = (decoratedObject.parent.description)! /]
    [#else]
        [#local planKey = decoratedObject.result?string(decoratedObject.planKey, decoratedObject.key) /]
        [#local text = (decoratedObject.branchName)!branchMasterText /]
        [#local masterBranchName = (decoratedObject.branchName)!branchMasterText /]
        [#local masterBranchDescription = (decoratedObject.description)! /]
    [/#if]
    [#local hasBranchSelected = (fn.isBranch(decoratedObject) || decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)) /]
    [#local urlPattern = decoratedObject.result?string('${req.contextPath}/browse/{key}/latest', '${req.contextPath}/browse/{key}') /]
    <button id="branch-selector" aria-owns="branch-selector-dropdown" aria-haspopup="true" class="aui-button aui-button-subtle aui-dropdown2-trigger[#if !hasBranchSelected] no-branch-selected[/#if]" data-plan-key="${planKey}">[#rt/]
        [@ui.icon type="devtools-branch" useIconFont=true /]
        <span class="plan-branch-name">${text?html}</span>
        <div id="branch-selector-dropdown"  class="aui-dropdown2"></div>
    </button>[#lt/]
    <script type="text/javascript">
        require(['widget/plan-branch-selector'], function(PlanBranchSelector) {
            new PlanBranchSelector({
                trigger: '#branch-selector',
                includeMaster: true,
                masterBranchName: "${masterBranchName?js_string}",
                masterBranchDescription: "${masterBranchDescription?js_string}",
                inlineDialogClass: 'breadcrumbs',
                templates: {
                    branchItem: 'branchItem-template'
                }
            });
        });
    </script>
    <script type="text/x-template" title="branchItem-template">[#rt/]
        <li><span class="branch {latestResult.suspendedClass}">{icon} <a href="${urlPattern}" title="{description}">{shortName}</a></span></li>[#t/]
    </script>[#lt/]
[/#macro]

[#macro showBreadcrumbsIcon decoratedObject]
    [#local iconType = (decoratedObject.project?? || decoratedObject.projectKey??)?then('build', 'project') /]
    [#local entityType = (decoratedObject.result?? && decoratedObject.result)?then('bamboo.plan', 'bamboo.project') /]
    [#local projectKey = (project??)?then(project.key, '') /]
    [#local projectName = (project??)?then(project.name, '') /]
    <div class="aui-avatar aui-avatar-large aui-avatar-project">
        <div class="aui-avatar-inner[#if ctx.featureManager.rotpProjectShortcutsEnabled ] project-shortcut-dialog-trigger[/#if]" data-key="${projectKey}" data-name="${projectName?html}" data-entity-type="${entityType}">
            [#switch iconType]
                [#case 'project']
                    <img src="${req.contextPath}/images/project-avatar.svg" alt=""/>
                    [#break]
                [#case 'build']
                [#default]
                    <img src="${req.contextPath}/images/plan-avatar.png" alt=""/>
            [/#switch]
        </div>
    </div>
[/#macro]

[#macro showBreadcrumbs decoratedObject isConfig=false isReadonly=false]
    [#local disabled = ((decoratedObject.parent)!decoratedObject).suspendedFromBuilding /]
    [#if decoratedObject.result]
        [#assign hasBranchSelector = (fn.isBranch(decoratedObject) || (decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)) || ((decoratedObject.parent)!decoratedObject).branches?has_content) /]
        [@showCrumbContainer]
            [@ww.url var='projectUrl' value='/browse/${decoratedObject.projectKey}' /]
            [@showCrumb link=projectUrl id=decoratedObject.projectKey text=decoratedObject.projectName /]
            [@ww.url var='resultUrl' value='/browse/${((decoratedObject.parent)!decoratedObject).planResultKey}' /]

            [#if fn.isBranch(decoratedObject)]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.planKey}' /]
                [@showCrumb link=planUrl id=decoratedObject.planKey text=decoratedObject.master.buildName disabled=disabled /]
            [#elseif decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.parent.planKey}' /]
                [@showCrumb link=planUrl id=decoratedObject.parent.planKey text=decoratedObject.parent.master.buildName disabled=disabled /]
            [#elseif decoratedObject.parent?has_content]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.parent.planKey}' /]
                [@showCrumb link=planUrl id=decoratedObject.parent.planKey text=decoratedObject.parent.displayName disabled=disabled /]
            [#else]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.planKey}' /]
                [@showCrumb link=planUrl id=decoratedObject.planKey text=decoratedObject.displayName disabled=disabled /]
            [/#if]
        [/@showCrumbContainer]
        [@ww.text var='resultText' name='navigator.result.name']
            [@ww.param value=((decoratedObject.parent)!decoratedObject).buildNumber /]
        [/@ww.text]
        [@showCrumb link=resultUrl current=true id=((decoratedObject.parent)!decoratedObject).planResultKey text=resultText tagName='h1' cssClass=hasBranchSelector?string('has-branch-selector', '') /]
    [#else]
        [#assign hasBranchSelector = (!isConfig && (fn.isBranch(decoratedObject) || (decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)) || ((decoratedObject.parent)!decoratedObject).branches?has_content)) /]
        [#assign planCrumbClass = hasBranchSelector?string('has-branch-selector', '') /]
        [#assign planCrumb]
            [#if fn.isBranch(decoratedObject)]
                [@ww.url var='planUrl' value='/browse/${isConfig?string(decoratedObject.master.key, decoratedObject.key)}' /]
                [@showCrumb link=planUrl current=!isConfig id=isConfig?string(decoratedObject.master.key, decoratedObject.key) text=decoratedObject.master.buildName tagName=isConfig?string('li', 'h1') cssClass=planCrumbClass disabled=disabled /]
            [#elseif decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.parent.key}' /]
                [@showCrumb link=planUrl current=!isConfig id=decoratedObject.parent.key text=decoratedObject.parent.buildName tagName=isConfig?string('li', 'h1') cssClass=planCrumbClass disabled=disabled /]
            [#elseif decoratedObject.parent?has_content]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.parent.key}' /]
                [@showCrumb link=planUrl current=!isConfig id=decoratedObject.parent.key text=decoratedObject.parent.displayName tagName=isConfig?string('li', 'h1') cssClass=planCrumbClass disabled=disabled /]
            [#else]
                [@ww.url var='planUrl' value='/browse/${decoratedObject.key}' /]
                [@showCrumb link=planUrl current=!isConfig id=decoratedObject.key text=decoratedObject.displayName tagName=isConfig?string('li', 'h1') cssClass=planCrumbClass disabled=disabled /]
            [/#if]
        [/#assign]
        [@showCrumbContainer]
            [@ww.url var='projectUrl' value='/browse/${decoratedObject.project.key}' /]
            [@showCrumb link=projectUrl id=decoratedObject.project.key text=decoratedObject.project.name /]
            [#if isConfig]${planCrumb}[/#if]
        [/@showCrumbContainer]

        [#if isConfig]
            [@ww.url var="configUrl" namespace="/chain/admin/config" action="editChainConfiguration" planKey=((navigationContext.navObject.master)!navigationContext.navObject).key /]
            [#assign configHeaderText]
                [@ww.text name=isReadonly?string('build.configuration.view.title', 'build.configuration.title')]
                    [@ww.param]
                        [#if fn.isBranch(decoratedObject)]
                            ${decoratedObject.master.buildName}
                        [#elseif decoratedObject.parent?has_content && fn.isBranch(decoratedObject.parent)]
                            ${decoratedObject.parent.buildName}
                        [#elseif decoratedObject.parent?has_content]
                            ${decoratedObject.parent.displayName}
                        [#else]
                            ${decoratedObject.displayName}
                        [/#if]
                    [/@ww.param]
                [/@ww.text]
            [/#assign]
            [@showCrumb link=configUrl current=true text=configHeaderText tagName='h1' /]
        [#else]
            ${planCrumb}
        [/#if]
    [/#if]
    [#if hasBranchSelector]
        [@showBranchSelector decoratedObject /]
    [/#if]
[/#macro]
