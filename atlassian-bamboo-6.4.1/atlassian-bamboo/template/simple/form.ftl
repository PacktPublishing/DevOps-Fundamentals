<#-- Allows the theme to be accessed in other contexts -->
${(action.setCurrentFormTheme(parameters.theme))!}

<#if (parameters.validate!false == false)><#rt/>
	<#if parameters.onsubmit??><#rt/>
		${tag.addParameter('onsubmit', "${parameters.onsubmit}; return true;") }
	</#if>
</#if>

<form<#rt/>
<#if parameters.namespace?? && parameters.validate??>
 namespace="${parameters.namespace?html}"<#rt/>
</#if>
<#if parameters.id??>
 id="${parameters.id?html}"<#rt/>
</#if>
<#if parameters.name??>
 name="${parameters.name?html}"<#rt/>
</#if>
<#if parameters.onsubmit??>
 onsubmit="${parameters.onsubmit?html}"<#rt/>
</#if>
<#if parameters.action??>
 action="${parameters.action?html}"<#rt/>
</#if>
<#if parameters.target??>
 target="${parameters.target?html}"<#rt/>
</#if>
<#if parameters.method??>
 method="${parameters.method?html}"<#rt/>
<#else>
 method="post"
</#if>
<#if parameters.enctype??>
 enctype="${parameters.enctype?html}"<#rt/>
</#if>
<#if parameters.cssClass??>
 class="${parameters.cssClass?html}"<#rt/>
</#if>
<#if parameters.cssStyle??>
 style="${parameters.cssStyle?html}"<#rt/>
</#if>
<#if parameters.title??>
 title="${parameters.title?html}"<#rt/>
</#if>
>
