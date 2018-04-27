${parameters.after!}

[#if parameters.helpDialog?has_content || parameters.helpDialogKey?has_content]
    [#if parameters.helpIconCssClass?has_content]
        [@help.iconDialog id=parameters.id content=parameters.helpDialog contentKey=parameters.helpDialogKey iconCssClass=parameters.helpIconCssClass /]
    [#else]
        [@help.iconDialog id=parameters.id content=parameters.helpDialog contentKey=parameters.helpDialogKey /]
    [/#if]
[#else]
    [#if parameters.helpKey?has_content]
        [@help.icon pageKey=parameters.helpKey cssClass="aui-icon icon-help" /]
    [#elseif parameters.helpUri?has_content]
        <a href="${req.contextPath}/help/${parameters.helpUri}" rel="help" data-use-help-popup="true" class="aui-icon icon-help">help</a>
    [/#if]
[/#if]