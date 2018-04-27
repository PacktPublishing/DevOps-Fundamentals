<div
    <#if parameters.id??>               id="${parameters.id?html}"         </#if>
    <#if parameters.name??>             name="${parameters.name?html}"         </#if>
    <#if parameters.cssClass??>         class="${parameters.cssClass?html}"    </#if>
    <#if parameters.cssStyle??>         style="${parameters.cssStyle?html}"    </#if>
    <#if parameters.title??>            title="${parameters.title?html}"<#rt/>
        </#if>
<#include "/${parameters.templateDir}/simple/scripting-events.ftl" />
>
