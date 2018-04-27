[@ww.form   action="saveFilter"
            submitLabelKey="global.buttons.saveAndApply"
            cancelUri='/start.action' ]

    [@ui.bambooSection cssClass='personal-filter-description']
        [@ww.text name="dashboard.filter.description"/]
    [/@ui.bambooSection]

    [@ui.bambooSection]
        [@ww.textfield name='addProjectTextField' labelKey='dashboard.filter.projects' id="addProjectTextField" cssClass="long-field" /]
    [/@ui.bambooSection]

    [@ui.bambooSection]
        [#if allPlanLabels?has_content]
            [@ww.checkboxlist name='selectedLabelNames' listKey="name" listValue="name" labelKey="dashboard.filter.label.dialog.checkbox" list=allPlanLabels /]
        [#else]
            [@ww.label labelKey='dashboard.filter.label.dialog.checkbox' value=action.getText('dashboard.filter.label.dialog.description.nolabels') /]
        [/#if]
    [/@ui.bambooSection]

    <script>
        require('widget/projects-picker').create('#addProjectTextField', ${existingProjectsJson.toString()});
    </script>
[/@ww.form]
