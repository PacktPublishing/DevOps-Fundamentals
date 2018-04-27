[#-- Docker pipelines configuration for creation of an entity. In create mode user can not specify detailed configuration. --]
[#macro dockerCreateConfigurationFragment headerKey descriptionKey isolationTypeRadioLabelKey isolationTypeRadioName isolationOptions headerElement='h3']
    [@dockerConfigurationFragment
            headerKey=headerKey
            descriptionKey=descriptionKey
            isolationTypeRadioLabelKey=isolationTypeRadioLabelKey
            isolationTypeRadioName=isolationTypeRadioName
            isolationOptions=isolationOptions
            headerElement=headerElement]
        [@dockerImage /]
    [/@dockerConfigurationFragment]
[/#macro]

[#-- Docker pipelines configuration for editing an entity. In edit mode user can specify more detailed configuration. --]
[#macro dockerEditConfigurationFragment headerKey descriptionKey isolationTypeRadioLabelKey isolationTypeRadioName isolationOptions dataVolumes headerElement='h3']
    [@dockerConfigurationFragment
            headerKey=headerKey
            descriptionKey=descriptionKey
            isolationTypeRadioLabelKey=isolationTypeRadioLabelKey
            isolationTypeRadioName=isolationTypeRadioName
            isolationOptions=isolationOptions
            headerElement=headerElement]
        [@dockerImage /]
        [@dockerVolumes dataVolumes /]
    [/@dockerConfigurationFragment]
[/#macro]

[#-- wrapper of Docker configuration fragment macros --]
[#macro dockerConfigurationFragment headerKey descriptionKey isolationTypeRadioLabelKey isolationTypeRadioName isolationOptions headerElement='h3']
    [#if featureManager.dockerPipelinesEnabled]
        [@ui.header pageKey=headerKey headerElement=headerElement /]
        <div class="description full-size">[@s.text name=descriptionKey /]</div>

        [@s.radio
            id=isolationTypeRadioName
            name=isolationTypeRadioName
            labelKey=isolationTypeRadioLabelKey
            toggle='true'
            listKey='key'
            listValue='value'
            required='true'
            list=isolationOptions /]

        [@ui.bambooSection dependsOn=isolationTypeRadioName showOn='DOCKER']
            [#nested /]
        [/@ui.bambooSection]
    [#else]
        [@s.hidden name=isolationTypeRadioName value='AGENT'/]
    [/#if]
[/#macro]

[#-- Docker image configuration --]
[#macro dockerImage]
    [@s.textfield
        id='dockerImage'
        name='dockerImage'
        labelKey='build.isolation.docker.image.name'
        required=true/]
[/#macro]

[#-- renders a collapsable list of data volume mappings --]
[#macro dockerVolumes dataVolumes]
[#-- @ftlvariable name="dataVolumes" type="java.util.List<com.atlassian.bamboo.docker.DataVolume>" --]
    [@ui.bambooSection id='volumesSection' titleKey='build.isolation.docker.volumes.header' collapsible=true isCollapsed=!(dataVolumes?has_content)]
        <div class="description full-size">[@s.text name='build.isolation.docker.volumes.description' /]</div>
        <div class="docker-pipelines__volumes"></div>

        <script type="text/javascript">
            require(['feature/docker-volume'], function (DockerVolume) {
                new DockerVolume({
                    el: '.docker-pipelines__volumes',
                    volumeMappings: [
                        [#list dataVolumes as dataVolume]
                            {
                                hostDirectory: '${dataVolume.hostDirectory?js_string}',
                                containerDirectory: '${dataVolume.containerDirectory?js_string}'
                            },
                        [/#list]
                    ],
                }).render();
            });
        </script>
    [/@ui.bambooSection]
[/#macro]
