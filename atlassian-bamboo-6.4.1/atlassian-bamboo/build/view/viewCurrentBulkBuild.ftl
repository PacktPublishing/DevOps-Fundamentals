[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.GotoBuildResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.GotoBuildResult" --]
[#assign buildNumber = immutablePlan.lastBuildNumber /]

[#if immutablePlan.getLatestResultsSummary()??]
    [#assign currentPlanPrefix]
        <a id="buildResult_${immutablePlan.key}-${resultsSummary.buildNumber}"
           href="${req.contextPath}/browse/${immutablePlan.key}-${resultsSummary.buildNumber}">${resultsSummary.planResultKey}</a>
    [/#assign]
    [#if resultsSummary.successful]
        <div class="Successful">
            [#if fn.isSpecsSuccess(resultsSummary)]
                ${soy.render("widget.icons.statusIcon", {
                    "status": "specs-success",
                "text": "Specs execution was successful"
                })}
            [#else]
                ${soy.render("widget.icons.statusIcon", {
                    "status": "approve",
                    "text": "Build was successful"
                })}
            [/#if]
            [#if (resultsSummary.testResultsSummary.fixedTestCaseCount)?? && resultsSummary.testResultsSummary.fixedTestCaseCount gt 0]
                ${currentPlanPrefix} fixed ${resultsSummary.testResultsSummary.fixedTestCaseCount} tests.
            [#else]
                ${currentPlanPrefix} was successful.
            [/#if]
        </div>
    [#elseif resultsSummary.failed]
        <div class="Failed">
            [#if fn.isSpecsFailure(resultsSummary)]
                ${soy.render("widget.icons.statusIcon", {
                    "status": "specs-failure",
                    "text": "Specs execution failed"
                })}
            [#else]
                ${soy.render("widget.icons.statusIcon", {
                    "status": "error",
                    "text": "Build failed"
                })}
            [/#if]
            [#if resultsSummary.testResultsSummary.failedTestCaseCount?? && resultsSummary.testResultsSummary.failedTestCaseCount gt 0]
                ${currentPlanPrefix} failed with <strong>${resultsSummary.testResultsSummary.failedTestCaseCount}</strong> failing tests.
            [#else]
                ${currentPlanPrefix} failed.
            [/#if]
        </div>
    [/#if]

[#else]
        [@ww.text name="bulkAction.manualBuild.noHistory" /]
[/#if]
