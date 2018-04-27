<#if parameters.labelposition!"top" == 'top'>
<div <#rt/>
<#else>
<span <#rt/>
</#if>
<#if parameters.align??>
    align="${parameters.align?html}"<#t/>
</#if>
<#if parameters.id??>
    id="wwctrl_${parameters.id}"<#rt/>
</#if>
><#t/>
<#include "/${parameters.templateDir}/simple/reset.ftl" />
<#if parameters.labelposition!"top" == 'top'>
</div> <#t/>
<#else>
</span> <#t/>
</#if>
