[#assign editorElementId=parameters.id?html]
[#assign name=parameters.name?html]

[#-- if true user cannot change editor's content  --]
[#assign isReadonly=parameters.isReadonly!false]

[#-- higlight mode (language) --]
[#assign mode=parameters.mode!"ace/mode/sh"]

[#-- wraps editor in div so user can manually resize it--]
[#assign resizable=parameters.resizable!true]

[#-- if true it will scale editor vertically to take as much screen as possible --]
[#assign growVertical=parameters.growVertical!false]


[#assign editorValueId=editorElementId + "_value"/]
[#if resizable]
    [#assign resizableId=editorElementId + "_resizable"]
[/#if]
[#assign editorRef=editorElementId + "_ref"]

[#if name?eval??]
    [#if name?eval.getClass().array]
        [#assign editorValue=name?eval[0]]
    [#else]
        [#assign editorValue=name?eval]
    [/#if]
[/#if]

<textarea id="${editorValueId}" name="${name}" class="hidden aceDataModel" data-editor-ref="${editorRef}">${(editorValue!"")?html}</textarea>

[#if resizable]
    <div id="${resizableId}" class="bambooAceResizableContainer">
[/#if]
    <div id="${editorElementId}" style="position: relative" class="bambooAceEditor"></div>
[#if resizable]
    </div>
[/#if]

<script>
    window.${editorRef} = ace.edit("${editorElementId}"); //this has to be a global var, otherwise you'll get line numbers as a part of the content...

    var     editor = ${editorRef},
            HighlightMode = ace.require("${mode}").Mode;

    editor.getSession().setMode(new HighlightMode());
    editor.setShowPrintMargin(false);
    editor.renderer.setHScrollBarAlwaysVisible(false);

    [#if isReadonly]
        editor.setReadOnly(true);
    [/#if]

    [#if resizable]
        AJS.$("#${resizableId}").resizable({
                                               resize: function(event, ui) { editor.resize(); }
                                           });
    [/#if]

    [#if growVertical]
        (function($) {
            var handler = function () {
                var $editorElement = $('#${editorElementId}');
                var sizeOfEverythingExceptEditor = Math.min(
                        //take height of everything except current editor
                        $("html").outerHeight(true) - $editorElement.outerHeight(true),
                        //if page content has height bigger than window take window height instead
                        window.innerHeight - $editorElement.outerHeight(true)
                );
                //100vh means 100% viewport height; we substract height of everything else
                var calc = AJS.format('calc(100vh - {0}px)', sizeOfEverythingExceptEditor);
                $editorElement.css('height', calc);
                editor.resize();
            };
            $(window).on('resize', handler);
            $(handler);
        })(AJS.$);
    [/#if]

    //we need to copy data from editor to form on submit
    AJS.$('#${editorElementId}').closest('form').submit(AceEditorManager.editorToModel);

    AJS.$(AceEditorManager.init());
</script>
