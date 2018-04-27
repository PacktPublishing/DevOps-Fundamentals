[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.reports.ViewReport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.reports.ViewReport" --]
<html>
<head>
    [@ui.header pageKey='report.title' title=true /]
    <meta name="topCrumb" content="reports" />
</head>

<body>
    [@ui.header pageKey='report.view.header' descriptionKey='report.view.header.description' title=false /]
    <div class="reportParam">
    [@s.form action='generateReport' submitLabelKey='global.buttons.submit' titleKey='report.input.title' method='get']

        [@s.select labelKey='report.name' name='reportKey' list=availableReports listKey='completeKey' listValue='name'
                    optionDescription='description' toggle=true
                    headerKey='' headerValue='Select...'/]

        [@ui.bambooSection dependsOn='reportKey' showOn=labelAwareReportKeys?join(" ")]
            [@s.textfield labelKey='report.label' name='labelTarget' /]
        [/@ui.bambooSection]

        [@s.select labelKey='report.builds'
                    name='buildIds'
                    list=availablePlans
                    listKey='id'
                    listValue='buildName'
                    groupBy='project.name'
                    multiple=true ]
            [#if !numberOfProjects?? || (availablePlans.size() + numberOfProjects gt 20) ]
                [@s.param name='size' value='20'/]
            [#else]
                [@s.param name='size' value='${availablePlans.size() + numberOfProjects}' /]
            [/#if]
        [/@s.select]

        [@s.select labelKey='report.group.by'
                    name='groupByPeriod'
                    list=availableGroupBy
                    listKey='key'
                    listValue='value']
                    [#if groupByPeriod == 'AUTO' && resolvedAutoPeriod??]
                        [@ww.param name='description']Report is grouped by ${availableGroupBy.get(resolvedAutoPeriod)}.[/@ww.param]
                    [/#if]
        [/@s.select]

        [@s.select labelKey='report.date.filter' name='dateFilter'
            headerKey='None' headerValue='All'
            footerKey='RANGE' footerValue='Select Range...'
            list=availableDateFilter
            listKey='key' listValue='value'
            toggle=true /]

        [@ui.bambooSection dependsOn='dateFilter' showOn='RANGE']
            [@s.textfield labelKey='report.from' name='dateFrom' /]
            [@s.textfield labelKey='report.to' name='dateTo' /]
        [/@ui.bambooSection]

        [/@s.form]
    </div>


    [#if dataset?has_content]
        <div class="reportDisplay">

        [#if selectedReport??]
            <h2>${selectedReport.name}</h2>
            [#if selectedReport.description?has_content]
                <p>${selectedReport.description}</p>
            [/#if]
        [/#if]
        [@dj.tabContainer headingKeys=['report.tab.chart.title', 'report.tab.data.title', 'report.tab.builds.title'] selectedTab='${selectedTab!}']
            [@dj.contentPane labelKey='report.tab.chart.title']
                [@s.action name="viewReportChart" namespace="/charts" executeResult=true /]
            [/@dj.contentPane]
            [@dj.contentPane labelKey='report.tab.data.title' ]
                <table class="aui">
                    <thead>
                        <tr>
                            <th>[@ww.text name="report.timeperiod.title"/]</th>
                            [#assign numSeries=dataset.seriesCount - 1/]
                            [#list 0..numSeries as seriesIndex]
                                [#assign seriesKey=dataset.seriesKey(seriesIndex) /]
                                <th>${action.getBuildNameFromKey(seriesKey)}</th>
                            [/#list]
                        </tr>
                    </thead>
                    <tbody>
                        [#assign numItems=dataset.getItemCount() - 1/]
                        [#list 0..numItems as itemIndex]
                            <tr>
                                <td>${dataset.timePeriod(itemIndex)}</td>
                                [#list 0..numSeries as seriesIndex]
                                    [#assign value=action.getYValue(seriesIndex, itemIndex)!/]
                                    <td>[#if value?has_content]${value?string('#.##')}[#else]-[/#if]</td>
                                [/#list]
                            </tr>
                        [/#list]
                    </tbody>
                </table>
            [/@dj.contentPane]
            [@dj.contentPane labelKey='report.tab.builds.title']
                [@s.action name="viewBuildResultsTable" namespace="/build" sort=true executeResult=true /]
            [/@dj.contentPane]
        [/@dj.tabContainer]
        </div>
    [/#if]
</body>
</html>

[#--[#if agentAwareReport][/#if]--]
[#--<script type="text/javascript">--]
[#--<!----]
    [#--function setDescription${parameters.id?default('')?html}()--]
    [#--{--]
        [#--var selectE = document.getElementById('${parameters.id?default('')?html}');--]
        [#--var selectDescription = document.getElementById('${parameters.id?default('')?html}Desc');--]
        [#--selectDescription.innerHTML = selectE.options[selectE.selectedIndex].title;--]
    [#--}--]

    [#--AJS.$(function()--]
    [#--{--]
        [#--setDescription${parameters.id?default('')?html}();--]
        [#--AJS.$("#${parameters.id?default('')?html}").change(setDescription${parameters.id?default('')?html})--]
    [#--});--]
[#--//-->--]
[#--</script>--]
