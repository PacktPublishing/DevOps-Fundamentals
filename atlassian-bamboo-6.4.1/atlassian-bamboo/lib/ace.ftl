[#macro textarea name labelKey="" isReadonly=false required=false resizable=true mode="ace/mode/sh" growVertical=false]
    [@ww.component template="ace-textarea.ftl" name=name labelKey=labelKey isReadonly=isReadonly required=required
    resizable=resizable mode=mode growVertical=growVertical /]
[/#macro]
