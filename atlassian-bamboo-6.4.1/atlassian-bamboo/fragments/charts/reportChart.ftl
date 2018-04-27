[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.charts.ViewAuthorChart" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.charts.ViewAuthorChart" --]
[#if chart??]
    ${chart.imageMap}
    <img id="chart" src="${req.contextPath}/chart?filename=${chart.location}" border="0" height="${chart.height}" width="${chart.width}" usemap="${chart.imageMapName}"/>
[#else]
    [@ui.messageBox type='error']
        [@s.text name="report.chart.missing"/]
    [/@ui.messageBox]
[/#if]