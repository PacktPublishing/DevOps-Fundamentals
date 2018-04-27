[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayAdminDecorator]
[#assign warningTitle = "serverstate.export.warning.title"]
[#assign warningMessage = "serverstate.export.warning"]
[#assign hasPermissionToPauseServer = fn.hasGlobalAdminPermission()]
[#include "serverStatusControl.ftl" /]
[/@decorators.displayAdminDecorator]