[#-- @ftlvariable name="error" type="com.atlassian.bamboo.logger.DecoratedErrorDetailsImpl" --]

<div class="system-error-message">
[#if fn.hasAdminPermission()]
    [#if error.throwableDetails.metadata['host']??]
        [@s.text name='chain.execution.error.host.key.verification.content.admin' /]
        [@ui.bambooPanel cssClass="host-verification-error-details"]
            <div class="command-output"><pre>${error.throwableDetails.metadata['host']} ${error.throwableDetails.metadata['key']}</pre></div>
        [/@ui.bambooPanel]
        <p>
            <script type="text/javascript">
                require(['feature/trusted-keys/trusted-keys-inline-add'], function(TrustedKeysInlineAdd) {
                    new TrustedKeysInlineAdd({
                        linkId: "addHost_${error.errorNumber}",
                        anchor: "#viewPlanError_${error.errorNumber}",
                        host: "${error.throwableDetails.metadata['host']?js_string}",
                        key: "${error.throwableDetails.metadata['key']?js_string}"
                    });
                });
            </script>
        </p>
    [#else]
        [@s.text name='chain.execution.error.host.key.verification.content.unknown.key' /]
    [/#if]
[#else]
    [@s.text name='chain.execution.error.host.key.verification.content.nonadmin' /]
[/#if]
</div>