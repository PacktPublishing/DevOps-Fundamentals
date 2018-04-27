[#if notificationGroupString?has_content]
    [@s.textfield key='notification.recipients.groups' value='${notificationGroupString?html}' name='notificationGroupString' /]
[#else]
    [@ww.textfield labelKey='notification.recipients.groups' name='notificationGroupString' /]
[/#if]

