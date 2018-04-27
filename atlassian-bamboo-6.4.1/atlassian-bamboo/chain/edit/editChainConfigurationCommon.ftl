[#macro editChainConfigurationPage plan selectedTab titleKey='' descriptionKey='' description='' tools='' toolsContainer='div']
<html>
<head>
    [#if fn.isConfigurationReadOnly(plan)]
        [@ui.header pageKey="chain.configuration.view.title.long" object=plan.name title=true /]
    [#else]
        [@ui.header pageKey="chain.configuration.edit.title.long" object=plan.name title=true /]
    [/#if]
    <meta name="tab" content="${selectedTab}" />
</head>
<body>
    [#if tools?has_content]
        <${toolsContainer} class="floating-toolbar">
            ${tools}
        </${toolsContainer}>
    [/#if]

    [#if titleKey?has_content]
        [@ui.header
            pageKey=titleKey headerElement="h2"
            descriptionKey=descriptionKey description=description
        /]
    [/#if]

    [#nested /]
</body>
</html>
[/#macro]