[@s.textfield labelKey='repository.cvs.root' name='repository.cvs.cvsRoot' required=true cssClass="long-field" /]

[@s.select
    labelKey='repository.cvs.authentication'
    name='repository.cvs.authType'
    toggle='true'
    list=repository.authenticationTypes
    listKey='name'
    listValue='label']
[/@s.select]

[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='password']
    [@s.hidden name="temporary.cvs.passwordChange" value="true" /]
    [@s.password labelKey='repository.cvs.password' name='temporary.cvs.password' /]
[/@ui.bambooSection]

[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='ssh']
    [@s.textfield labelKey='repository.cvs.keyFile' name='repository.cvs.keyFile' cssClass="long-field" /]
    [@s.hidden name="temporary.cvs.passphraseChange" value="true" /]
    [@s.password labelKey='repository.cvs.passphrase' name='temporary.cvs.passphrase'  /]
[/@ui.bambooSection]

[@s.textfield labelKey='repository.cvs.module' name='repository.cvs.module' required=true /]

[@s.select labelKey='repository.cvs.module.versionType' name='repository.cvs.selectedVersionType'
            listKey='name' listValue='label' toggle='true'
            list=repository.versionTypes required=true helpKey='cvs.module.version'  /]

[@ui.bambooSection dependsOn='repository.cvs.selectedVersionType' showOn='branch']
    [@s.textfield labelKey='repository.cvs.module.branch' name='repository.cvs.branchName' /]
[/@ui.bambooSection]

[@s.hidden name="repository.cvs.quietPeriod" value="0" /]
