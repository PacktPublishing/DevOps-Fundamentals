[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]

[#import "/fragments/docker/docker.ftl" as docker/]

<title>[@ww.text name='job.create.new.title' /]</title>
<meta name="decorator" content="createWizard"/>
<meta name="tab" content="1"/>
<meta name="prefix" content="job"/>

[@ui.header pageKey='job.create.new.title' title=true/]

[@ww.form action="/chain/admin/createJob.action"
          method="post" enctype="multipart/form-data"
          cancelUri='/browse/${buildKey}/stages'
          submitLabelKey='job.create.step.one.description'
          descriptionKey='job.create.new.description']

        [@ww.hidden name='buildKey' value='${immutableChain.key}' /]

        [@ui.bambooSection titleKey="job.details"]
            [#include "/fragments/chains/selectCreateStage.ftl"]
            [#include "/fragments/plan/editJobKeyName.ftl"]
        [/@ui.bambooSection]

        [@docker.dockerCreateConfigurationFragment
            headerKey='job.docker.isolate.header'
            descriptionKey='job.docker.isolate.description'
            isolationTypeRadioLabelKey='job.docker.isolate.type'
            isolationTypeRadioName='jobRunEnvironmentIsolation'
            isolationOptions=action.environmentIsolationOptions/]
[/@ww.form]
