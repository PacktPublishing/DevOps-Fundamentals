[@s.textfield labelKey='repository.cvs.root' name='repository.cvs.cvsRoot' disabled=true cssClass="long-field" /]

[@s.select
    labelKey='repository.cvs.authentication'
    name='repository.cvs.authType'
    list=repository.authenticationTypes
    listKey='name'
    listValue='label'
    disabled=true/]

[#if buildConfiguration.getString('repository.cvs.authType')=='ssh']
    [@s.textfield labelKey='repository.cvs.keyFile' name='repository.cvs.keyFile' cssClass="long-field" disabled=true/]
[/#if]

[@s.textfield labelKey='repository.cvs.quiet' name='repository.cvs.quietPeriod' disabled=true helpKey='cvs.quiet.period'/]
[@s.textfield labelKey='repository.cvs.module' name='repository.cvs.module' disabled=true /]

[@s.select labelKey='repository.cvs.module.versionType' name='repository.cvs.selectedVersionType'
listKey='name' listValue='label'
list=repository.versionTypes disabled=true helpKey='cvs.module.version' /]

[#if buildConfiguration.getString('repository.cvs.selectedVersionType')=='branch']
    [@ww.textfield labelKey='repository.cvs.module.branch' name='repository.cvs.branchName' disabled=true/]
[/#if]


