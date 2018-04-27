[#assign svnUrlCssClass="long-field"/]
[#if plan??]
    [#assign svnUrlCssClass="long-field autocomplete-variables"/]
[/#if]
[@s.textfield labelKey='repository.svn.repository' name='repository.svn.repositoryUrl' cssClass="${svnUrlCssClass}" required=true /]
[@s.textfield labelKey='repository.svn.username' name='repository.svn.username' /]

[@s.select
    labelKey='repository.svn.authentication'
    name='repository.svn.authType'
    toggle='true'
    list=repository.authenticationTypes
    listKey='name'
    listValue='label']
[/@s.select]

[@ui.bambooSection dependsOn='repository.svn.authType' showOn='password']
    [#if buildConfiguration.getString('repository.svn.userPassword')?has_content]
        [@s.checkbox labelKey='repository.password.change' toggle='true' name='temporary.svn.passwordChange' /]
        [@ui.bambooSection dependsOn='temporary.svn.passwordChange' showOn='true']
            [@s.password labelKey='repository.svn.password' name="temporary.svn.password" required=false /]
        [/@ui.bambooSection]
    [#else]
        [@s.hidden name="temporary.svn.passwordChange" value="true" /]
        [@s.password labelKey='repository.svn.password' name='temporary.svn.password' /]
    [/#if]
[/@ui.bambooSection]

[@ui.bambooSection dependsOn='repository.svn.authType' showOn='ssh']
    [@s.textfield labelKey='repository.svn.keyFile' name='repository.svn.keyFile' cssClass="long-field" /]
    [#if buildConfiguration.getString('repository.svn.passphrase')?has_content]
        [@s.checkbox labelKey='repository.passphrase.change' toggle='true' name='temporary.svn.passphraseChange' /]
        [@ui.bambooSection dependsOn='temporary.svn.passphraseChange' showOn='true']
             [@s.password labelKey='repository.svn.passphrase' name='temporary.svn.passphrase' /]
        [/@ui.bambooSection]
    [#else]
        [@s.hidden name="temporary.svn.passphraseChange" value="true" /]
        [@s.password labelKey='repository.svn.passphrase' name='temporary.svn.passphrase' /]
    [/#if]
[/@ui.bambooSection]

[@ui.bambooSection dependsOn='repository.svn.authType' showOn='ssl-client-certificate']
    [@s.textfield labelKey='repository.svn.keyFile' name='repository.svn.sslKeyFile' cssClass="long-field" /]
    [#if buildConfiguration.getString('repository.svn.sslPassphrase')?has_content]
        [@s.checkbox labelKey='repository.passphrase.change' toggle='true' name='temporary.svn.sslPassphraseChange' /]
        [@ui.bambooSection dependsOn='temporary.svn.sslPassphraseChange' showOn='true']
             [@s.password labelKey='repository.svn.passphrase' name='temporary.svn.sslPassphrase' /]
        [/@ui.bambooSection]
    [#else]
        [@s.hidden name="temporary.svn.sslPassphraseChange" value="true" /]
        [@s.password labelKey='repository.svn.passphrase' name='temporary.svn.sslPassphrase' /]
    [/#if]
[/@ui.bambooSection]