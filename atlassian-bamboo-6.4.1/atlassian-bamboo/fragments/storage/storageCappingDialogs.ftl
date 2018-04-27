[#-- dialogs to be displayed when the space taken by artifacts exceeds preconfigured limits --]
[#if ctx.featureManager.artifactStorageSpaceLimited]
    [#assign userLoggedIn = ctx.getUser(req)?? /]

    [#-- soft limit warning --]
    [#if (userLoggedIn && ctx.hasAdminPermission()) && ctx.storageCappingService.softLimitExceeded && !ctx.storageCappingService.hardLimitExceeded]
        <script type="text/javascript">
            require(['feature/dialog-storage-soft-limit-warning'], function(DialogStorageSoftLimitWarning) {
                new DialogStorageSoftLimitWarning({
                    username: '${ctx.getUser(req).name}',
                    id: 'storage-soft-limit-warning-dialog'
                });
            });
        </script>
    [#-- hard limit warning --]
    [#elseif (!userLoggedIn || ctx.hasAdminPermission()) && ctx.storageCappingService.hardLimitExceeded]
        <script type="text/javascript">
            require(['feature/dialog-storage-hard-limit-warning'], function(DialogStorageHardLimitWarning) {
                new DialogStorageHardLimitWarning({
                    userLoggedIn: ${userLoggedIn?string},
                    id: 'storage-hard-limit-warning-dialog'
                });
            });
        </script>
    [/#if]
[/#if]
