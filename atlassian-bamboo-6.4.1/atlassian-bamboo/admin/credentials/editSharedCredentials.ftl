[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.CreateSharedCredentials" --]
[@s.form  action='updateSharedCredentials'
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="credentials.update.button"
        cancelUri="/admin/configureSharedCredentials.action"
        cssClass="aui"]

	<h2>
        [@s.text name="sharedCredentials.edit"]
            [@s.param]${credentialsType?html}[/@s.param]
        [/@s.text] - ${credentialsName?html}
    </h2>

    <div class="aui-message warning">
         [@s.text name="sharedCredentials.edit.warning" /]
         <span class="aui-icon icon-warning"></span>
    </div>

    [@s.hidden name="credentialsId" value=credentialsId /]

    [@ui.bambooSection id='credentials-id']
        [@s.textfield labelKey="credentials.name" name="credentialsName" id="credentialsName" required=true/]
    [/@ui.bambooSection]

    [@ui.bambooSection id='credentials-config']
        ${editHtml!}    
    [/@ui.bambooSection]
[/@s.form]
