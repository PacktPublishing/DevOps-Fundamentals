[#-- ===================================================================================================== @help.url --]
[#--Example Usage: [@help.url pageKey="help.home"]Help[/@help.url] --]
[#macro url pageKey title="" cssClass="" id=""]
<a href="${ctx.helpLink.getUrl(pageKey)}" [#t]
    [#if id?has_content]
        id="${id}" [#t]
    [/#if]
    [#if title?has_content]
        title="${title}" [#t]
    [#else]
        title="${ctx.helpLink.getTitle(pageKey)}" [#t]
    [/#if]
    [#if cssClass?has_content]
        class="${cssClass}" [#t]
    [/#if]
rel="help">[#nested]</a> [#t]
[/#macro]

[#-- =============================================================================================== @help.staticUrl --]
[#--Example Usage: [@help.staticUrl pageKey="help.home"]Help[/@help.url] --]
[#macro staticUrl pageKey title="" cssClass=""]
    [#assign path][@ww.text name="${pageKey}"/][/#assign]

<a href="${path}" [#t]
    [#if title?has_content]
            title="${title}" [#t]
    [#elseif action.doesHelpLinkHaveMatchingTitle(pageKey)]
            title="[@ww.text name='${pageKey}.title'/]" [#t]
    [/#if]
    [#if cssClass?has_content]
            class="${cssClass}" [#t]
    [/#if]
        rel="help">[#nested]</a>[#t]
[/#macro]

[#-- ==================================================================================================== @help.href --]
[#--Example Usage: <a href="[@help.href pageKey="help.home"/]"> --]
[#macro href pageKey]
${ctx.helpLink.getUrl(pageKey)}[#t]
[/#macro]

[#-- ===================================================================================================== @help.btf --]
[#--Example Usage: <a href="[@help.btf pageKey="help.home"/]"> --]
[#--This should be used in locations like setup where the DocumentationLinkProvider bean is not available --]
[#macro btf pageKey]
[#assign docRoot][@ww.text name="help.prefix"/][/#assign]
[#assign path][@ww.text name="${pageKey}"/][/#assign]
${docRoot}${path}[#t]
[/#macro]

[#-- ==================================================================================================== @help.icon --]
[#--Example Usage: [@help.icon pageKey="help.home" title="Bamboo Documentation" altText="Bamboo Documentation"/]  --]
[#macro icon pageKey title="" altText="" cssClass=""]
   [@url pageKey="${pageKey}" title="${title}" cssClass=cssClass]
   <span class="aui-icon aui-icon-help[#if cssClass?has_content] ${cssClass}[/#if]"
       [#if altText?has_content]
            title="${altText}" [#t]
       [#else]
            title="${ctx.helpLink.getTitle(pageKey)}" [#t]
       [/#if]
   ></span>[#t]
   [/@url]
[/#macro]

[#macro iconDialog id content="" contentKey="" cssClass="" iconCssClass="aui-iconfont-help"]
    [#assign helpDialogId]helpDialog-${id}[/#assign]
    [#assign helpDialogContentId]helpDialog-${id}_content[/#assign]

    <a href="#" id="${helpDialogId}" class="icon-help-dialog[#if cssClass?has_content] ${cssClass}[/#if]" rel="help">
        <span class="aui-icon aui-icon-small ${iconCssClass}" data-unicode="UTF+E003" original-title=""></span>
    </a>
    <div id="${helpDialogContentId}" style="display: none;">${fn.resolveName(content, contentKey)}[#t]</div>
    <script type="text/javascript">
        require(['jquery', 'widget/help-dialog'], function($, HelpDialog){
            return new HelpDialog({
                el: $('#${fn.jqid(helpDialogId)}'),
                content: $('#${fn.jqid(helpDialogContentId)}')
            });
        });
    </script>
[/#macro]