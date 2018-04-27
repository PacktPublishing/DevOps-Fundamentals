[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureQuickFilterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureQuickFilterAction" --]
<html>
    <head>
        <title>[@s.text name='quick.filters.admin.rules.configure.title'/]</title>
        <meta name="decorator" content="adminpage">
        <meta name="adminCrumb" content="quickFilters">
    </head>
    <body>
        <h1>
            <a id="quick-filters-back-link" href="${req.contextPath}/admin/configureQuickFilters.action">[@s.text name="quick.filters.admin.title"/]</a>
            › <span id="quick-filter-name">[#if action.hasActionErrors()][@s.text name='quick.filters.admin.rules.configure.title'/][#else]${quickFilter.name}[/#if]
        </h1>
        <h2>[@s.text name="quick.filters.admin.rules.configure.heading"/]</h2>
        <p class="description">[@s.text name="quick.filters.admin.rules.configure.description"/]</p>

        [#if action.hasActionErrors()]
            [#list formattedActionErrors as error]
                [@ui.messageBox type="error"]${error}[/@ui.messageBox]
            [/#list]
        [#else]
            [@quickFilterRulesMainPanel rules=quickFilter.rules /]
        [/#if]
    </body>
</html>

[#macro ruleListItem id name editUrl confirmDeleteUrl]
    <li class="item" data-item-id="${id}" id="item-${id}">
        <a class="edit" href="${editUrl}&amp;ruleId=${id}">
            <h3 class="item-title">${name?html}</h3>
        </a>
        <a href="${confirmDeleteUrl}&amp;ruleId=${id}" class="delete"><span class="assistive">[@s.text name="global.buttons.delete" /]</span></a>
    </li>
[/#macro]

[#macro quickFilterRulesMainPanel rules]
    [@s.url var="addUrl" action="addQuickFilterRule" namespace="/admin" returnUrl=currentUrl quickFilterId=quickFilter.id/]
    [@s.url var="editUrl" action="editQuickFilterRule" namespace="/admin" returnUrl=currentUrl quickFilterId=quickFilter.id/]
    [@s.url var="confirmDeleteUrl" action="confirmDeleteQuickFilterRule" namespace="/admin" returnUrl=currentUrl quickFilterId=quickFilter.id/]

    <div id="panel-editor-setup" class="quick-filter-config [#if !rules?has_content]no-items[/#if]">
        <p id="no-items-message">[@s.text name="quick.filters.admin.rules.empty" /]</p>

        <div id="panel-editor-list">
            <h2 class="assistive">[@s.text name="quick.filters.admin.title" /]</h2>
            <ul>
                [#list rules as rule]
                    [@ruleListItem id=rule.id name=rule.name editUrl=editUrl confirmDeleteUrl=confirmDeleteUrl/]
                [/#list]
            </ul>
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a href="${addUrl}" id="addRule" class="toolbar-trigger">[@s.text name="quick.filters.admin.rules.add" /]</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="panel-editor-config"></div>
    </div>

    <script type="text/x-template" title="ruleListItem-template">
        [@ruleListItem id="{id}" name="{name}" editUrl=editUrl confirmDeleteUrl=confirmDeleteUrl /]
    </script>
    <script type="text/x-template" title="icon-template">
        [@ui.icon type="{type}" /]
    </script>

    <script type="text/javascript">
        require(['feature/quick-filters-admin/quick-filters-configure-rules-app'], function(QuickFiltersConfigureRulesApp) {
            new QuickFiltersConfigureRulesApp({
                el: "#panel-editor-setup",
                configContainer: "#panel-editor-config",
                rulesList: "#panel-editor-list > ul",
                addButton: "#addRule",
                templates: {
                    ruleListItem: "ruleListItem-template",
                    iconTemplate: 'icon-template'
                }
            }).start();
        });
    </script>
[/#macro]
