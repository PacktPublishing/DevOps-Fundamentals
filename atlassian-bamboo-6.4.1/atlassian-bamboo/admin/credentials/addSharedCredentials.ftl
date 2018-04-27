[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.CreateSharedCredentials" --]
[@s.form  action='createSharedCredentials'
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="credentials.update.button"
        cancelUri="/admin/configureSharedCredentials.action"
        cssClass="aui"]

	<h2>
        [@s.text name="sharedCredentials.add"]
            [@s.param]${credentialsType?html}[/@s.param]
        [/@s.text]
    </h2>

    [@s.hidden name="credentialsId" value=credentialsId /]

    [@ui.bambooSection id='credentials-id']
        [@s.textfield labelKey="credentials.name" name="credentialsName" id="credentialsName" required=true/]
    [/@ui.bambooSection]

    ${editHtml!}

    [@s.hidden name="createCredentialsKey"/]
[/@s.form]