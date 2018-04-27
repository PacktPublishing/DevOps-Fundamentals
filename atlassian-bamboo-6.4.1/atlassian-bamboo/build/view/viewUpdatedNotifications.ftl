[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]

[#import "/lib/notifications.ftl" as notifications]

[#assign newNotification = bulkAction.getNewNotification(params)/]
[#if newNotification?has_content]
    [#assign notificationCondition ]
        [@notifications.notificationType newNotification /]
    [/#assign]
    [#assign notificationRecipient ]
        [@notifications.notificationRecipient newNotification /]
    [/#assign]

    [@s.label key='notification.condition' value='${notificationCondition}' /]
    [@s.label key='bulkAction.notification.recipientHeading' value='${notificationRecipient}' escapeHtml=false /]
[#else]
    [@s.label key='notification.condition' value='Error: could not find notification type.' /]
[/#if]






