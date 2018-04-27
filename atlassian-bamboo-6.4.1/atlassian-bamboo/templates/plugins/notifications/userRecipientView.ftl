[#if notificationUserFullNameString?has_content]
     <a href="${req.getContextPath()}/browse/user/${notificationUserString?url}">${notificationUserFullNameString?html}</a><span class="notificationRecipientType"> (user)</span>
[#else]
    ${notificationUserString?html} <span class="notificationRecipientType"> (user)</span>
[/#if]

