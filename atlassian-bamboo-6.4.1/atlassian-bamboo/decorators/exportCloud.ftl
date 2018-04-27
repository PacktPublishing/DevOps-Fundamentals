[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayAdminDecorator]
    [#assign warningTitle = "admin.export.cloud.serverstate.warning.title"]
    [#assign warningMessage = "admin.export.cloud.serverstate.warning"]
    [#assign hasPermissionToPauseServer = fn.hasRestrictedAdminPermission()]
    [#include "serverStatusControl.ftl" /]
[/@decorators.displayAdminDecorator]