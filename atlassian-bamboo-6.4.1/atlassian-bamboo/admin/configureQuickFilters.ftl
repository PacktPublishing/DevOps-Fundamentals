[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureQuickFiltersAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureQuickFiltersAction" --]
<html>
    <head>
        <title>[@s.text name='quick.filters.admin.title'/]</title>
        <meta name="decorator" content="adminpage">
        <meta name="adminCrumb" content="quickFilters">
    </head>
    <body>
        <div class="toolbar">
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <div id="quick-filters-loading-icon">[@ui.icon type="loading" /]</div>
                    </li>
                    <li class="toolbar-item">
                        <a class="aui-button" id="add-quick-filter-button" tabindex="0">[@s.text name='quick.filters.admin.add' /]</a>
                    </li>
                </ul>
            </div>
        </div>

        [@ui.header pageKey="quick.filters.admin.title" descriptionKey="quick.filters.admin.description"/]

        <div id="quick-filters-container"></div>

        <script type="text/javascript">
            require(['feature/quick-filters-admin/quick-filters-manage-app'], function(QuickFiltersManageApp) {
                new QuickFiltersManageApp({
                    el: "#quick-filters-container",
                    addButton: "#add-quick-filter-button",
                    loadingIcon: "#quick-filters-loading-icon"
                }).start();
            });
        </script>
    </body>
</html>
