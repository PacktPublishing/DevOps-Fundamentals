[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SelectSetupStepAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SelectSetupStepAction" --]
<html>
<head>
    <title>[@ww.text name='setup.checklist.title' /]</title>
</head>
<body>

<div id="PageContent">

    <table border="0" cellpadding="0" cellspacing="12" width="100%">
        <tr>
			<td valign="top" class="pagebody">
        <h1>[@ww.text name='setup.checklist.heading' /]</h1>
	    <p>[@ww.text name='setup.checklist.welcome' /]</p>

	    <p>[@ww.text name='setup.checklist.description' /]</p>

        <table id="setupChecklistTable" class="grid">
            <tr>
                <th>&nbsp;</th>
                <th>[@ww.text name='setup.checklist.status' /]</th>
            </tr>
			<tr>
                <td>
                    <b>[@ww.text name='setup.checklist.jdk'][@ww.param]${minJdkVersion}[/@ww.param][/@ww.text]</b>
                    <br>
                    <span class="content">
                        [@ww.text name='setup.checklist.jdk.found' /]: ${jdkName}
                    </span>
                </td>
                <td align="center">
                    [#if jdkCorrect]
                        <img src="${req.contextPath}/images/good.gif" width="16" height="16" border="0">
                    [#else]
                        <img src="${req.contextPath}/images/bad.gif" width="16" height="16" border="0">
                    [/#if]
                </td>
            </tr>
			<tr>
                <td>
                    <b>[@ww.text name='setup.checklist.home' /]</b> ${action.applicationHome!'No application home configured'}
                    <br/>
                    <span class="content">
                    [#if applicationHomeOk]
                        [@ww.text name='setup.checklist.home.ok' /]
                    [#else]
                        [@ww.text name='setup.checklist.home.error' /]
                    [/#if]
                    </span>
                </td>
                <td align="center">
                    [#if applicationHomeOk]
                    <img src="${req.contextPath}/images/good.gif" width="16" height="16" border="0">
                    [#else]
                    <img src="${req.contextPath}/images/bad.gif" width="16" height="16" border="0">
                    [/#if]
                </td>
            </tr>
		</table>

        [#if everythingOk]
                <form method="POST" action="checklist-finish.action">
                        [@ww.text name='setup.checklist.next' /]
                </form>
        [#else]
                [@ww.text name='setup.checklist.correct' /]
        [/#if]
        </td>
        </tr>
    </table>
</div>

</body>
</html>