[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.TestOgnlEscaping" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.TestOgnlEscaping" --]

<html>
<head>
    <meta name="decorator" content="adminpage">
</head>
<body>


[#assign variable1 = '#root']

<div class="sploits">
    ExploitStringText[@s.text name=variable1 /]/ExploitStringText
    ExploitStringFromParams [@s.textfield name="name" value='${req.getParameter(\"param\")}' /]
    ExploitStringFromParams [@s.textfield name="name" value=req.getParameter("param") /]
    ExploitStringValue [@s.textfield name='name' value=exploitString/]
    ExploitObjectValue [@s.textfield name='name' value=exploitObject/]
    ExploitStringName [@s.textfield name=exploitString/]
    ExploitObjectName [@s.textfield name=exploitObject/]

    ExploitStringValue [@s.textfield name='name' value=ognlStaticCall/]
    ExploitObjectValue [@s.textfield name='name' value=ognlStaticCallObject/]
    ExploitStringName [@s.textfield name=ognlStaticCall/]
    ExploitObjectName [@s.textfield name=ognlStaticCallObject/]

    <br/>

    ExploitStringQuotedValue [@s.textfield name='name' value='exploitString'/]
    ExploitObjectQuotedValue [@s.textfield name='name' value='exploitObject'/]
    ExploitStringQuotedValue [@s.textfield name='name' value='ognlStaticCall'/]
    ExploitObjectQuotedValue [@s.textfield name='name' value='ognlStaticCallObject'/]


    ExploitStringQuotedName [@s.textfield name='exploitString'/]
    ExploitObjectQuotedName [@s.textfield name='exploitObject'/]
    ExploitStringQuotedName [@s.textfield name='ognlStaticCall'/]
    ExploitObjectQuotedName [@s.textfield name='ognlStaticCallObject'/]

    <br/>



    ExploitStringValue [@s.select name='name' value=exploitString list=exploits/]
    ExploitObjectValue [@s.select name='name' value=exploitObject list=exploits/]
    ExploitStringName [@s.select name=exploitString list=exploits/]
    ExploitObjectName [@s.select name=exploitObject list=exploits/]

    ExploitStringValue [@s.select name='name' value=ognlStaticCall list=exploits/]
    ExploitObjectValue [@s.select name='name' value=ognlStaticCallObject list=exploits/]
    ExploitStringName [@s.select name=ognlStaticCall list=exploits/]
    ExploitObjectName [@s.select name=ognlStaticCallObject list=exploits/]

    <br/>

    ExploitStringQuotedValue [@s.select name='name' value='exploitString' list=exploits/]
    ExploitObjectQuotedValue [@s.select name='name' value='exploitObject' list=exploits/]
    ExploitStringQuotedValue [@s.select name='name' value='ognlStaticCall' list=exploits/]
    ExploitObjectQuotedValue [@s.select name='name' value='ognlStaticCallObject' list=exploits/]


    ExploitStringQuotedName [@s.select name='exploitString' list=exploits/]
    ExploitObjectQuotedName [@s.select name='exploitObject' list=exploits/]
    ExploitStringQuotedName [@s.select name='ognlStaticCall' list=exploits/]
    ExploitObjectQuotedName [@s.select name='ognlStaticCallObject' list=exploits/]
</div>
</body>
</html>
