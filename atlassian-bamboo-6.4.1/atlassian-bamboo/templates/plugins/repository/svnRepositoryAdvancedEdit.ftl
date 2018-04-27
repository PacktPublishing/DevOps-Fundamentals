[@s.hidden name='repository.svn.advanced.options.on' value='true'/]
[@s.checkbox labelKey='repository.svn.useExternals' name='repository.svn.useExternals' /]
[@s.checkbox labelKey='repository.svn.useExport' name='repository.svn.useExport' /]

[@s.checkbox labelKey='repository.svn.branch.autodetectRootUrl' toggle=true name='repository.svn.branch.autodetectRootUrl'/]
[@ui.bambooSection dependsOn='repository.svn.branch.autodetectRootUrl' showOn=false]
    [@s.textfield labelKey='repository.svn.branch.manualRootUrl' name='repository.svn.branch.manualRootUrl' cssClass="long-field" required=true/]
[/@ui.bambooSection]

[@s.checkbox labelKey='repository.svn.tag.autodetectRootUrl' toggle=true name='repository.svn.tag.autodetectRootUrl'/]
[@ui.bambooSection dependsOn='repository.svn.tag.autodetectRootUrl' showOn=false]
    [@s.textfield labelKey='repository.svn.tag.manualRootUrl' name='repository.svn.tag.manualRootUrl' cssClass="long-field" required=true/]
[/@ui.bambooSection]