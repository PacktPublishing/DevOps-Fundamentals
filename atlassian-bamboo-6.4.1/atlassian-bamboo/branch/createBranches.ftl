[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.CreateChainBranch" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.CreateChainBranch" --]

[@s.form action="createPlanBranch" namespace="/chain/admin"
          cancelUri='/chain/admin/config/configureBranches.action?buildKey=${planKey}'
          submitLabelKey='global.buttons.create' ]

    [#assign canDoAuto=action.branchDetectionCapable/]
    [#if canDoAuto]
        <div class="hidden">
            [@ww.textfield id="creationOption" name="creationOption" value="${creationOption!'AUTO'}"/]      [#--this value gets swapped out in javascript--]
        </div>
        <div id="autoBranchCreation" [#if creationOption?? && creationOption != 'AUTO']class="hidden"[/#if]>
            [@cp.displayLinkButton cssClass="switchToManual floating-toolbar" buttonId='switchToManualOption' buttonLabel='branch.create.manual.switch' /]
            <h2>[@ww.text name="branch.create.auto.heading"/]</h2>
            <div id="createBranchContent"></div>
            [@ww.checkbox labelKey="branch.create.enable.option" checked=true name='tmp.auto.createAsEnabled'/]
            [@ui.messageBox type="info"]
                [@s.text name="branch.create.new.title.description"/]
            [/@ui.messageBox]
        </div>
    [#else]
        [@ww.hidden  id="creationOption" name="creationOption" value="MANUAL"/]
    [/#if]

    <div id="manualBranchCreation" [#if (canDoAuto && !(creationOption?? && creationOption == 'MANUAL'))]class="hidden"[/#if]>
        [#if canDoAuto][@cp.displayLinkButton cssClass="switchToAuto floating-toolbar" buttonId='switchToAutoOption' buttonLabel='branch.create.auto.switch'/][/#if]
        <h2>[@ww.text name="branch.create.manual.heading"/]</h2>
        [@ww.textfield labelKey='branch.name' name='branchName' required=true /]
        [@ww.textfield labelKey='branch.branchDescription' name='branchDescription' required=false/]
        [#if canDoAuto] [#-- refactoring branchConfigurable --]
            [@ww.textfield labelKey="branch.vcsbranchname" name="branchVcsName" required=false/]
        [/#if]
        [@ww.checkbox labelKey="branch.create.enable.option" checked=true name='tmp.createAsEnabled'/]
    </div>

    [@ww.hidden name='planKeyToClone' value='${planKey?html}' /]
    [@ww.hidden name='planKey' value='${planKey?html}' /]
[/@s.form]

<script type="text/javascript">
    require(['jquery', 'feature/branch-create/dialog'], function($, BranchCreation) {
        new BranchCreation({
            el: '#createBranchContent',
            manualSwitch: '#switchToManualOption',
            autoSwitch: '#switchToAutoOption',
            autoBranchTab: '#autoBranchCreation',
            manualBranchTab: '#manualBranchCreation',
            creationTypeInput: '#creationOption',
            errors: $.parseJSON("${action.toJson(fieldErrors)?js_string}"),
            fetchBranchesUrl: "[@s.url value='/rest/api/latest/plan/' + planKey?url + '/vcsBranches?max-result=1000000' /]"
        }).render();});
</script>

<script type="text/x-template" title="branchesList">
    <p>[@ww.text name="branch.create.auto.checkbox.description"/]</p>
    [@ww.checkboxlist name='branchesForCreation' /]
</script>
<script type="text/x-template" title="branchesItem">
    <div class="checkbox">
        <input type="checkbox" class="checkbox" name="branchesForCreation" value="{branch}" id="branchesForCreation-{itemCount}" />
        <label for="branchesForCreation-{itemCount}" title="{branch}">{branch}</label>
    </div>
</script>
<script type="text/x-template" title="branchesNone">
    <p>[#t]
        [@ww.text name="branch.create.auto.none"]
            [@ww.param]<a class="switchToManual">[/@ww.param]
            [@ww.param]</a>[/@ww.param]
        [/@ww.text][#t]
    </p>
</script>
<script type="text/x-template" title="branchesTooMany">
    <div id="showMoreBranches">
        [@ww.text name="branch.create.auto.toomany"/]
    </div>
</script>
<script type="text/x-template" title="branchesTimeout">
      <p>[#t]
      [@ww.text name="branch.create.auto.timeout"]
          [@ww.param]<a class="switchToManual">[/@ww.param]
          [@ww.param]</a>[/@ww.param]
      [/@ww.text][#t]
    </p>
</script>
<script type="text/x-template" title="branchesError">
      <p>[#t]
      [@ww.text name="branch.create.auto.error"]
          [@ww.param]<a class="switchToManual">[/@ww.param]
          [@ww.param]</a>[/@ww.param]
      [/@ww.text][#t]
    </p>
</script>