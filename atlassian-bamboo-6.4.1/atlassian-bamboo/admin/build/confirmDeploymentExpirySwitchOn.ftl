[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
<html>
<head>
    <title>[@ww.text name='buildExpiry.confirmation.title' /]</title>
    <meta name="decorator" content="atl.general"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
    <meta name="adminCrumb" content="buildExpiry">
</head>
<body>

<title>[@ww.text name='buildExpiry.confirmation.title' /]</title>

[@ww.form action="approveEnableDeploymentExpiry" namespace='/admin/ajax'
    method="post" cancelUri='/browse/' submitLabelKey='buildExpiry.confirmation.submit']
    [@s.text name="buildExpiry.confirmation"]
        [@s.param][@help.href pageKey="expiry.global"/][/@s.param]
    [/@s.text]
[/@ww.form]
</body>
</html>