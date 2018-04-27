<#include "/${parameters.templateDir}/simple/text.ftl" />
<br/>
<#if parameters.list??>
<select onChange="this.form.elements['${parameters.name?html}'].value=this.options[this.selectedIndex].value"<#rt/>
    <#if parameters.disabled?? && parameters.disabled>
 disabled="disabled"<#rt/>
    </#if>
>
    <@ww.iterator value="parameters.list">
    <option value="${top?html}"<#rt/>
        <#if parameters.name = top>
 selected="selected"<#rt/>
        </#if>
    ><#t/>
            ${top?html}<#t/>
    </option><#lt/>
    </@ww.iterator>
</select>
</#if>
