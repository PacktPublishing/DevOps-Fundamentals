<#if !stack.findValue("#optiontransferselect_js_included")??><#t/>
	<script language="javascript" src="<@ww.url value="/webwork/optiontransferselect/optiontransferselect.js" encode='false' />"></script>
	<#assign temporaryVariable = stack.setValue("#optiontransferselect_js_included", "true") /><#t/>
</#if><#t/>
<table>
<tr><td>
<#include "/${templateDir}/simple/select.ftl" /><#t/>
</td></tr>
<tr><td>
<#if parameters.allowMoveUp!true><#t/>
	<#assign defMoveUpLabel="${parameters.moveUpLabel!'^'}" /><#t/>
	<#if parameters.headerKey??><#t/>
		&nbsp;<input type="button" value="${defMoveUpLabel}" onclick="moveOptionUp(document.getElementById('${parameters.id}'), '${parameters.headerKey}');" />&nbsp;
	<#else><#t/>
		&nbsp;<input type="button" value="${defMoveUpLabel}" onclick="moveOptionUp(document.getElementById('${parameters.id}'));" />&nbsp;
	</#if><#t/>
</#if><#t/>
<#if parameters.allowMoveDown!true><#t/>
	<#assign defMoveDownLabel="${parameters.moveDownLabel!'v'}" /><#t/>
	<#if parameters.headerKey??><#t/>
		&nbsp;<input type="button" value="${defMoveDownLabel}" onclick="moveOptionDown(document.getElementById('${parameters.id}'), '${parameters.headerKey}');" />&nbsp;
	<#else><#t/>
		&nbsp;<input type="button" value="${defMoveDownLabel}" onclick="moveOptionDown(document.getElementById('${parameters.id}'));" />&nbsp;
	</#if><#t/>
</#if><#t/>
<#if parameters.allowSelectAll!true><#t/>
	<#assign defSelectAllLabel="${parameters.selectAllLabel!'*'}" /><#t/>
	<#if parameters.headerKey??><#t/>
		&nbsp;<input type="button" value="${defSelectAllLabel}" onclick="selectAllOptionsExceptSome(document.getElementById('${parameters.id}'), 'key', '${parameters.headerKey}');" />&nbsp;
	<#else><#t/>
		&nbsp;<input type="button" value="${defSelectAllLabel}" onclick="selectAllOptions(document.getElementById('${parameters.id}'));" />&nbsp;
	</#if><#t/>
</#if><#t/>
</td></tr>
</table>
