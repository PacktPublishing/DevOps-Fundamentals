[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.repository.ConfigureChainBranchRepositories" --]

<html>
<head>
    [@ui.header pageKey='branch.configuration.edit.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="branch.repository"/>
</head>
<body>

[#import "/lib/menus.ftl" as menu]
[#import "/build/common/repositoryCommon.ftl" as rc]

[@ui.header pageKey="chain.config.repository" descriptionKey="branch.config.repository.description" headerElement='h2' /]

[#macro repositoryListItem id name isDefault=false]
<li class="item[#if isDefault] item-default[/#if]" data-item-id="${id}" id="item-${id}">
    <a href="[@ww.url action="editChainBranchRepository" namespace="/branch/admin/config" planKey=planKey /]&amp;repositoryId=${id}">
        <h3 class="item-title">${name}</h3>
    </a>
    <!--<a href="[@ww.url action="confirmDeleteRepository" namespace="/chain/admin/config" planKey=planKey /]&amp;repositoryId=${id}" class="delete" title="[@ww.text name='repository.delete' /]"><span class="assistive">[@ww.text name="global.buttons.delete" /]</span></a>-->
</li>
[/#macro]

[#assign pageContent]

    [#include "/build/common/repositoryCommon.ftl"]

    [#assign filterForm]
    <form id="filter-repository-type"><input type="search" placeholder="[@ww.text name='global.buttons.search' /]"/>
    </form>[/#assign]

<div id="panel-editor-setup" class="repository-config[#if !repositoryDefinitions?has_content] no-items[/#if]">
    <p id="no-items-message">[@ww.text name="repository.config.noRepositoryDefined" /]</p>
    <div id="panel-editor-list">
        <h2 class="assistive">[@ww.text name="repositories.title" /]</h2>
        <ul>
            [#list repositoryDefinitions as repoDef]
                [@repositoryListItem id=repoDef.id name=repoDef.name!?html isDefault=(repoDef_index == 0)/]
            [/#list]
        </ul>
    </div>
    <div id="panel-editor-config"></div>
</div>

    [@dj.simpleDialogForm
    triggerSelector=".repositoryTools"
    width=600
    height=300
    headerKey="repository.shared.convert"
    submitCallback="reloadThePage"/]

<script type="text/x-template" title="repositoryListItem-template">
[@repositoryListItem id="{id}" name="{name}" /]
</script>

<script type="text/x-template" title="repositoryListItemDefaultMarker-template">
    <span class="item-default-marker grey">[@ww.text name='repository.default'/]</span>
</script>

<script type="text/x-template" title="icon-template">
[@ui.icon type="{type}" /]
</script>

<script type="text/javascript">
    BAMBOO.REPOSITORY.repositoryConfig.init({
                                                addRepositoryTrigger: "#addRepository",
                                                repositorySetupContainer: "#panel-editor-setup",
                                                repositoryConfigContainer: "#panel-editor-config",
                                                repositoryList: "#panel-editor-list > ul",
                                                displayCategories: true,
                                                templates: {
                                                    repositoryListItem: "repositoryListItem-template",
                                                    repositoryListItemDefaultMarker: "repositoryListItemDefaultMarker-template",
                                                    iconTemplate: "icon-template"
                                                },
                                                repositoryTypesDialog : {
                                                    filterForm : "${filterForm?js_string}",
                                                isNewAllowed: false
                                                },
                                                moveRepositoryUrl: null,
                                                preselectItemId: ${repositoryId!null}
                                            });
</script>
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.repository" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]

</body>
</html>