[#if repository.perforceExecutableSet]
    <div class="description">
        <p>
            [@s.text name='repository.p4.executableExists']
                    [@s.param]${repository.p4Executable}[/@s.param]
                [/@s.text]
        </p>
    </div>
[#else]
    [@ui.messageBox type="warning"]
        [@s.text name='repository.p4.noExecutable']
            [@s.param]${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action[/@s.param]
        [/@s.text]
    [/@ui.messageBox]
[/#if]

[@s.textfield labelKey='repository.p4.port' name='repository.p4.port' required=true helpKey='perforce.fields' /]
[@s.textfield labelKey='repository.p4.client' name='repository.p4.client' required=true helpKey='perforce.fields' cssClass="long-field" /]
[@s.textfield labelKey='repository.p4.depot' name='repository.p4.depot' required=true helpKey='perforce.fields' cssClass="long-field" /]
[@s.textfield labelKey='repository.p4.username' name='repository.p4.user' helpKey='perforce.fields' /]
[@s.hidden name="temporary.p4.passwordChange" value="true" /]
[@s.password labelKey='repository.p4.password' name='temporary.p4.password' helpKey='perforce.fields' required=false/]
[@s.textfield labelKey='repository.p4.environmentVariables' name='repository.p4.environmentVariables' helpKey='perforce.fields' /]
[@s.checkbox labelKey='repository.p4.manageWorkspace' name='repository.p4.manageWorkspace' helpKey='perforce.fields' /]
