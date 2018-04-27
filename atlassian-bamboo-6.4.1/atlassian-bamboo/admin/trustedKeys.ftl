[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.TrustedKeysAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.TrustedKeysAction" --]

<html>
<head>
[@ui.header pageKey='webitems.system.admin.security.trustedKeys' title=true /]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="trustedKeys">
</head>
<body>
    <div class="toolbar">
        <div class="aui-toolbar inline">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    <a id="add-key-button" class="aui-button toolbar-trigger" tabindex="0">[@s.text name='admin.trustedKey.add' /]</a>
                </li>
            </ul>
        </div>
    </div>
    [@ui.header pageKey='webitems.system.admin.security.trustedKeys' descriptionKey='webitems.system.admin.security.trustedKeys.description' /]
    <div id="trusted-keys-container"></div>
    <script type="text/javascript">
        require(['feature/trusted-keys/trusted-keys-app'], function(TrustedKeysApp) {
            new TrustedKeysApp({el:"#trusted-keys-container", addBtn: "#add-key-button"}).start();
        });
    </script></body>

</html>