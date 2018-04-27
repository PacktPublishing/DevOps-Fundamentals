<title>[@ww.text name="sharedCredentials.delete" /]</title>
[@ww.form action="deleteSharedCredentials" namespace="/admin"
submitLabelKey="global.buttons.delete"
id="confirmDelete"]
    [@s.hidden name="returnUrl" /]
    [@s.hidden name="credentialsId" /]
    [@ui.messageBox type="warning" titleKey="sharedCredentials.delete.confirm.title" /]
    <br/>
    [#assign repoList]
        [@printRepos repositoryType="sharedCredentials.delete.global" repositoryMap=globalRepositoryDefinitionsMap
            action="configureLinkedRepositories" namespace="/admin" /]
        [@printRepos repositoryType="sharedCredentials.delete.plan" repositoryMap=planRepositoryDefinitionsMap
            action="editChainRepository" namespace="/chain/admin/config" useBuildKey=true /]
        [@printRepos repositoryType="sharedCredentials.delete.branch" repositoryMap=planBranchRepositoryDefinitionsMap
            action="editChainBranchRepository" namespace="/branch/admin/config" usePlanKey=true /]
    [/#assign]

    [#if repoList != ""]
        <p>[@s.text name="sharedCredentials.delete.confirm.repos" /]</p>
        <ul>
            ${repoList}
        </ul>
    [/#if]

    [#if buildTaskDefinitionsMap?keys?size > 0]
        <p>[@s.text name="sharedCredentials.delete.confirm.tasks" /]</p>
        <ul>
        [#list buildTaskDefinitionsMap?keys as t]
            [@s.url var='editBuildTasksUrl' action="editBuildTasks" namespace="/build/admin/edit" buildKey=buildTaskDefinitionsMap.get(t)!"" /]
            <li><a href="${editBuildTasksUrl}">${t}</a></li>
        [/#list]
        </ul>
    [/#if]

    [#if deploymentTaskDefinitionsMap?keys?size > 0]
    <p>[@s.text name="sharedCredentials.delete.confirm.env" /]</p>
    <ul>
        [#list deploymentTaskDefinitionsMap?keys as t]
            [@s.url var='editEnvTasksUrl' action="configureEnvironmentTasks" namespace="/deploy/config" environmentId=deploymentTaskDefinitionsMap.get(t)!"" /]
            <li><a href="${editEnvTasksUrl}">${t}</a></li>
        [/#list]
    </ul>
    [/#if]

    [#if repoList == "" && buildTaskDefinitionsMap?keys?size == 0 && deploymentTaskDefinitionsMap?keys?size == 0]
        [@s.text name="sharedCredentials.delete.none" /]
    [/#if]
[/@ww.form]

[#macro printRepos repositoryType repositoryMap action namespace useBuildKey=false usePlanKey=false]
    [#if !repositoryMap.isEmpty()]
        [#list repositoryMap?keys as r]
            <li>
                [#if useBuildKey]
                    [@s.url var='editRepositoryUrl' action=action namespace=namespace repositoryId=r.id buildKey=repositoryMap.get(r)!"" /]
                [#elseif usePlanKey]
                    [@s.url var='editRepositoryUrl' action=action namespace=namespace repositoryId=r.id planKey=repositoryMap.get(r)!"" /]
                [#else]
                    [@s.url var='editRepositoryUrl' action=action namespace=namespace repositoryId=r.id /]
                [/#if]
                <a href="${editRepositoryUrl}">${r.name}</a> [@s.text name=repositoryType /]
            </li>
        [/#list]
    [/#if]
[/#macro]