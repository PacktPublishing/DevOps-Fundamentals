[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayAdminDecorator context="upm"]
[#assign warningTitle = "serverstate.upm.warning.title"]
[#assign warningMessage = "serverstate.upm.warning"]
[#assign hasPermissionToPauseServer = fn.hasGlobalAdminPermission()]
[#include "serverStatusControl.ftl" /]
[/@decorators.displayAdminDecorator]