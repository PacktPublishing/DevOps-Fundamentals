[#macro displayHtmlHeader requireResourcesForContext=[] requireResources=[] bodyClass="" withHeader=true activeNavKey=(page.properties["meta.topCrumb"])!'']
[#local additionalBodyClass = (page.properties["meta.bodyClass"])!'' /]
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>[#if title?has_content]${title} - [/#if][#if ctx?? && ctx.instanceName?has_content]${ctx.instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />

    <meta name="application-name" content="Bamboo" />
    [#if ctx?? && ctx.getUser(request)??]
        <meta name="ajs-remote-user" content="${ctx.getUser(request).name}"/>
    [/#if]

    <link rel="shortcut icon" href="[@cp.getStaticResourcePrefix /]/images/icons/favicon.ico" type="image/x-icon"/>

    <script type="text/javascript">
        (function (window) {
            window.BAMBOO = (window.BAMBOO || {});
            BAMBOO.contextPath = '${req.contextPath}';
            BAMBOO.staticResourcePrefix = '${staticResourcePrefix!}';
        })(window);
    </script>

    ${webResourceManager.requireResourcesForContext("aui")}

    [#list requireResourcesForContext as resourceContext]
        ${webResourceManager.requireResourcesForContext(resourceContext)}
    [/#list]

    [#list requireResources as resource]
        ${webResourceManager.requireResource(resource)}
    [/#list]

    ${webResourceManager.getRequiredResources(UrlMode.AUTO)}

    [@ui.renderWebPanels location="atl.header.after.scripts"/]

${head!}
</head>
<body class="aui-layout aui-theme-default[#if decorator??] dec_${((decorator.name)!'')?replace(".", "_")}[/#if][#if bodyClass?has_content] ${bodyClass}[/#if][#if additionalBodyClass?has_content] ${additionalBodyClass}[/#if]">
    [#if withHeader]
        <ul id="assistive-skip-links" class="assistive">
            <li><a href="#main-nav">Skip to navigation</a></li>
            <li><a href="#content">Skip to content</a></li>
        </ul>
        <div id="page">
        [#include "/fragments/decorator/header.ftl"]
    [/#if]
[/#macro]


[#macro displayAdminDecorator context="atl.admin"]
[@displayHtmlHeader requireResourcesForContext=[context] bodyClass="administration" activeNavKey="admin.menu" /]
[#local pageNav][#include "/fragments/adminMenu.ftl"][/#local]
[#local content][#nested/][/#local]
[#local header][@ui.header pageKey="admin.title" /][/#local]

[#include "/fragments/showAdminErrors.ftl"]
${soy.render("bamboo.layout.base", {
    "headerMainContent": header,
    "content": content,
    "pageNavContent": pageNav
})}
[#include "/fragments/decorator/footer.ftl"]
[/#macro]
