[#macro triggerListItem id name description enabled editTriggerUrl confirmDeleteTriggerUrl]
<li class="item" data-item-id="${id}" id="item-${id}">
    <a href="${editTriggerUrl}&amp;triggerId=${id}">
        <h3 class="item-title">${name}</h3>
        [#if description?has_content]
            <div class="item-description">${description}</div>
        [/#if]
    </a>
    [#if enabled?string == "false"][@ui.lozenge colour="default-subtle" textKey="tasks.disabled"/][/#if]
    <a href="${confirmDeleteTriggerUrl}&amp;triggerId=${id}" class="delete" title="[@ww.text name='chain.trigger.delete' /]"><span class="assistive">[@ww.text name="global.buttons.delete" /]</span></a>
</li>
[/#macro]

[#macro triggersMainPanel triggers triggerSelectorUrl addTriggerUrl editTriggerUrl confirmDeleteTriggerUrl]
    <div id="panel-editor-setup" class="trigger-config[#if !triggers?has_content] no-items[/#if]">
        <p id="no-items-message">[@ww.text name="chain.triggers.noTriggersDefined" /]</p>

        <div id="panel-editor-list">
            <h2 class="assistive">[@ww.text name="chain.triggers" /]</h2>
            <ul>
                [#list triggers as trigger]
                    [@triggerListItem id=trigger.id name=trigger.name description=trigger.userDescription!?html enabled=trigger.enabled editTriggerUrl=editTriggerUrl confirmDeleteTriggerUrl=confirmDeleteTriggerUrl/]
                [/#list]
            </ul>
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a href="${triggerSelectorUrl}" id="addTrigger" class="aui-button toolbar-trigger">[@ww.text name="chain.trigger.add" /]</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="panel-editor-config"></div>
    </div>

    <script type="text/x-template" title="triggerListItem-template">
        [@triggerListItem id="{id}" name="{name}" description="{description}" enabled="{enabled}" editTriggerUrl=editTriggerUrl confirmDeleteTriggerUrl=confirmDeleteTriggerUrl /]
    </script>

    <script type="text/x-template" title="triggerListItemDefaultMarker-template">
    </script>
    <script type="text/x-template" title="lozengeDisabled-template">
        [@ui.lozenge colour="default-subtle" textKey="triggers.disabled"/]
    </script>
    <script type="text/x-template" title="icon-template">
        [@ui.icon type="{type}" /]
    </script>

    <script type="text/javascript">
        BAMBOO.TRIGGER.chainTriggerConfig.init({
                                                   addTriggerTrigger: "#addTrigger",
                                                   triggerSetupContainer: "#panel-editor-setup",
                                                   triggerConfigContainer: "#panel-editor-config",
                                                   triggerList: "#panel-editor-list > ul",
                                                   templates: {
                                                       triggerListItem: "triggerListItem-template",
                                                       triggerListItemDefaultMarker: "triggerListItemDefaultMarker-template",
                                                       lozengeDisabled: "lozengeDisabled-template",
                                                       iconTemplate: "icon-template"
                                                   },
                                                   preselectItemId: ${triggerId!null}
                                               });

    </script>
[/#macro]

[#macro triggerSelector availableTriggers selectionUrl]
    [#if availableTriggers?has_content]
    <ul class="trigger-type-list">
        [#list availableTriggers.iterator() as triggerType]
            <li>
                <span class="task-type-icon-holder" [#if triggerType.getIconUrl()??] style="background-image: url(${triggerType.getIconUrl()})" [/#if]></span>

                <h3 class="trigger-type-title">
                    <a href="${selectionUrl}&amp;createTriggerKey=${triggerType.completeKey}">${triggerType.name?html}</a>
                </h3>
                [#if triggerType.description??]
                    <div class="trigger-type-description">${triggerType.description?html}</div>
                [/#if]
            </li>
        [/#list]
    </ul>
    [/#if]
[/#macro]

[#macro invalidTriggerPlugin showDeleteButton deleteUrl]
<div class="invalidPlugin">
    <h2>[@ww.text name="triggers.edit.error.missingPlugin.title"/]</h2>
    [#if showDeleteButton]
        <div class="aui-toolbar inline delete">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    <a href="${deleteUrl}" class="toolbar-trigger" title="[@ww.text name='triggers.delete' /]">[@ww.text name='global.buttons.delete' /]</a>
                </li>
            </ul>
        </div>
    [/#if]
    [@ui.messageBox type="error" titleKey="triggers.edit.error.missingPlugin.message.title"]
        [#if triggerDefinition?has_content]
            [@ww.text name="triggers.edit.error.missingPlugin.message"]
                [@ww.param]<a class="delete" href="${deleteUrl}" title="[@ww.text name='chain.trigger.delete' /]">[/@ww.param]
                [@ww.param]</a>[/@ww.param]
                [@ww.param]${triggerDefinition.pluginKey}[/@ww.param]
            [/@ww.text]
        [#else]
            [@ww.text name="triggers.edit.error.missingPlugin.message"]
                [@ww.param]<a class="delete" href="${deleteUrl}" title="[@ww.text name='chain.trigger.delete' /]">[/@ww.param]
                [@ww.param]</a>[/@ww.param]
                [@ww.param]${(createTriggerKey!"")?html}[/@ww.param]
            [/@ww.text]
        [/#if]
    [/@ui.messageBox]
</div>

[/#macro]