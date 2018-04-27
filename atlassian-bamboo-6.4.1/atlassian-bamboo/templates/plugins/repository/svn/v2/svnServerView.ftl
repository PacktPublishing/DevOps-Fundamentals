[@s.textfield labelKey='repository.svn.repository' name='repository.svn.repositoryRoot' cssClass="long-field" disabled=true /]
[@s.textfield labelKey='repository.svn.username' name='repository.svn.username' disabled=true/]

[@s.select
    labelKey='repository.svn.authentication'
    name='repository.svn.authType'
    list=svnAuthenticationTypes
    listKey='name'
    listValue='label'
    disabled = true/]

[#if stack.findValue('repository.svn.authType') == 'ssh']
    [@s.textfield labelKey='repository.svn.keyFile' name='repository.svn.keyFile' cssClass="long-field" disabled=true/]
[/#if]

[#if stack.findValue('repository.svn.authType') == 'ssl-client-certificate']
    [@s.textfield labelKey='repository.svn.keyFile' name='repository.svn.sslKeyFile' cssClass="long-field" disabled = true/]
[/#if]
