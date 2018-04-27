[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildDocker" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildDocker" --]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[#import "/fragments/docker/docker.ftl" as docker/]

[#assign pageDescription]
    [@s.text name='job.docker.image.name.description']
        [@s.param][@help.href pageKey='docker.pipelines' /][/@s.param]
    [/@s.text]
[/#assign]

[@ebcc.editConfigurationPage plan=immutablePlan selectedTab='build.docker' titleKey='job.docker.edit']
    [@s.form action="updateBuildDocker" namespace="/build/admin/edit" id="configureDocker"
            cancelUri='/build/admin/edit/editBuildDocker.action?buildKey=${immutableBuild.key}'
            submitLabelKey='global.buttons.update' ]

        [@s.hidden name="buildKey" /]
        [@docker.dockerEditConfigurationFragment
            headerKey="job.docker.isolate.header"
            descriptionKey="job.docker.isolate.description"
            isolationTypeRadioLabelKey="job.docker.isolate.type"
            isolationTypeRadioName="isolationType"
            isolationOptions=isolationOptions
            dataVolumes=dataVolumes /]
    [/@s.form]
[/@ebcc.editConfigurationPage]
