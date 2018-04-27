[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ArtifactUrlRedirectAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ArtifactUrlRedirectAction" --]

<html>
<head>
    <title>[@s.text name="artifact.listing"/]</title>
    <meta name="decorator" content="main" />
</head>

<body>
<h1>[@s.text name="artifact.listing"/]</h1>

<table class="aui">
    <thead>
    <tr>
        <th>[@s.text name="artifact.file.type"/]</th>
        <th>[@s.text name="artifact.file.name"/]</th>
        <th>[@s.text name="artifact.file.size"/]</th>
        <th>[@s.text name="artifact.file.timestamp"/]</th>
    </tr>
    </thead>
[#list artifactFiles.iterator() as url]
    <tr>
        <td>[@getIcon type=url.fileType/]</td>
        <td>[@createUrl url=url.url!]${url.name?html}[/@createUrl]</td>
        <td>${url.size!}</td>
        <td>[@renderStamp timeStamp=url.lastModified()!/]</td>
    </tr>
[/#list]
</table>
</body>
</html>

[#macro createUrl url]
    [#if url?has_content]
    <a href='${url?replace("BASE_URL", req.contextPath)}'>[#nested]</a>
    [#else]
        [#nested]
    [/#if]
[/#macro]

[#macro getIcon type]
[#if type = "REGULAR_FILE"]
<img src="${req.contextPath}/images/icons/icon_file.gif" alt="(file)">
[#else]
<img src="${req.contextPath}/images/icons/icon_folder.gif" alt="(dir)">
[/#if]
[/#macro]

[#macro renderStamp timeStamp]
[#if timeStamp?has_content]
    [@ui.time datetime=timeStamp]${timeStamp?datetime?string}[/@ui.time]
[#else]
&nbsp;
[/#if]
[/#macro]
