<#include "/${parameters.templateDir}/simple/dynamic-field-parameters.ftl" />
<input type="hidden"<#rt/>
 name="${parameters.name!""?html}"<#rt/>
<#if parameters.nameValue??>
 value="<@ww.property value="parameters.nameValue"/>"<#rt/>
</#if>
<#if parameters.id??>
 id="${parameters.id?html}"<#rt/>
</#if>
<#if parameters.cssClass??>
 class="${parameters.cssClass?html}"<#rt/>
</#if>
<#if parameters.cssStyle??>
 style="${parameters.cssStyle?html}"<#rt/>
</#if>
/>

<#if (parameters.showValidationErrors?? && parameters.showValidationErrors)>
    <#if (fieldErrors[parameters.name])?has_content>
        <#list fieldErrors[parameters.name] as error>
        <div class="error control-form-error" <#if (parameters.name)?has_content> data-field-name="${parameters.name?html}"</#if>>${error?html}</div>
        </#list>
    </#if>
</#if>