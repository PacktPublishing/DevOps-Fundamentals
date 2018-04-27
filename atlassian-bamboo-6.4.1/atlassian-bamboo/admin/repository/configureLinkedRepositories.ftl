[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.ConfigureLinkedRepositories" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.ConfigureLinkedRepositories" --]
[#include "/build/common/repositoryCommon.ftl"]

<html>
<head>
    [@ui.header pageKey="sharedRepositories.title" title=true/]
    [#if fn.hasAdminPermission()]
        <meta name="decorator" content="adminpage">
        <meta name="adminCrumb" content="globalRepositoriesConfig">
    [#else]
        <meta name="decorator" content="focusTask">
    [/#if]
</head>

<body>
[@ui.header pageKey="sharedRepositories.heading" descriptionKey="sharedRepositories.description"/]

[#assign filterForm]
<form id="filter-repository-type" class="aui"><input class="text" type="search" placeholder="[@ww.text name='global.buttons.search' /]"/>
</form>[/#assign]

<div id="panel-editor-setup" class="repository-config[#if !repositoryDefinitions?has_content] no-items[/#if]">
    <p id="no-items-message">[@ww.text name="repository.config.noRepositoryDefined" /]</p>

    <div id="panel-editor-list">
        <h2 class="assistive">[@ww.text name="repositories.title" /]</h2>
        <ul>
        [#list repositoryDefinitions as repoDef]
            [@repositoryListItem id=repoDef.id name=repoDef.name!?html /]
        [/#list]
        </ul>
        [#if fn.hasGlobalPermission("CREATEREPOSITORY")]
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a href="[@ww.url action="viewLinkedRepositoryTypes" namespace="/admin" returnUrl=currentUrl /]" id="addRepository" class="aui-button toolbar-trigger">[@ww.text name="repository.add" /]</a>
                    </li>
                </ul>
            </div>
        [/#if]
    </div>
    <div id="panel-editor-config"></div>
</div>

<script type="text/x-template" title="repositoryListItem-template">
[@repositoryListItem id="{id}" name="{name}" /]
</script>

<script type="text/x-template" title="repositoryListItemDefaultMarker-template">
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
        displayCategories: false,
        templates: {
            repositoryListItem: "repositoryListItem-template",
            repositoryListItemDefaultMarker: "repositoryListItemDefaultMarker-template",
            iconTemplate: "icon-template"
        },
        repositoryTypesDialog : {
            filterForm : "${filterForm?js_string}"
        },
        moveRepositoryUrl: null,
        markDefault: false,
        preselectItemId: ${repositoryId!"null"}
    });
</script>


</body>
</html>

[#macro repositoryListItem id name]
<li class="item" data-item-id="${id}" id="item-${id}">
    <a href="[@ww.url action="editLinkedRepository" namespace="/admin" /]?repositoryId=${id}" class="repository-item-link">
        <h3 class="item-title">${name}</h3>
    </a>
    <a href="[@ww.url action="confirmDeleteLinkedRepository" namespace="/admin"/]?repositoryId=${id}" class="delete" title="[@ww.text name='repository.delete' /]"><span class="assistive">[@ww.text name="global.buttons.delete" /]</span></a>
</li>
[/#macro]
