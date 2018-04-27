<div class="aui-message warning" id="deploymentExpiryWarning">
    <p class="title">
        <span class="aui-icon icon-warning"></span>
        <strong>[@s.text name="buildExpiry.enable.deployment.warning.title"/]</strong>
    </p>
    <p>[@s.text name="buildExpiry.enable.deployment.warning.content"/]</p>
    <button class="aui-button" id="enableDeploymentExpiry"
        href="[@s.url action='confirmDeploymentExpiry' namespace='/admin'/]"
    >[@s.text name="buildExpiry.enable.deployment"/]</button>
    <a href="[@help.href pageKey="expiry.global"/]">[@s.text name="buildExpiry.enable.deployment.warning.help"/]</a>
</div>

[@dj.simpleDialogForm
    triggerSelector="#enableDeploymentExpiry"
    headerKey="buildExpiry.confirmation.title"
    submitCallback="redirectAfterReturningFromDialog"
    submitMode="ajax"
    width=670 height=370
/]