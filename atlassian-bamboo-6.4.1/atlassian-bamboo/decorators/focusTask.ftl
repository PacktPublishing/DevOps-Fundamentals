[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.configuration"] bodyClass="aui-page-focused aui-page-focused-xlarge" activeNavKey='create' /]
[#include "/fragments/showAdminErrors.ftl"]
${soy.render("bamboo.layout.focused", {
    "content": body
})}
[#include "/fragments/decorator/footer.ftl"]