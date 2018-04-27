[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[@s.url var="artifactsTabUrl" value='/browse/${chainResult.planResultKey}/artifact' /]
[#assign sharedArtifactsFound = action.hasSharedArtifacts(chainResult)/]
[#assign limit=10/]
[#if sharedArtifactsFound]
<div id="shared-artifacts">
    <h2>[@s.text name='artifact.shared.title'/]</h2>
    <table class="aui">
        <colgroup>
            <col>
            <col width="100px">
        </colgroup>
        <thead>
        <tr>
            <th>[@s.text name="chain.artifacts.table.header"/]</th>
            <th>[@s.text name="chain.artifacts.size"/]</th>
        </tr>
        </thead>
        <tbody>
            [#assign count = 0]
            [#list chainResult.stageResults as stageResult]
                [#list stageResult.getSortedBuildResults() as buildResult]
                    [#assign artifactLinks = action.getSharedArtifactLinks(buildResult)!/]
                    [#list artifactLinks as artifactLink]
                        [#if count lt limit]
                        <tr>
                            <td>
                            [@ui.icon type="artifact-shared" /]
                                [#assign artifactUrl=action.getArtifactLinkUrl(artifactLink)!/]
                                [#if artifactUrl?has_content]
                                    <a id="artifact-${artifactLink.label?html}" href="${artifactUrl}">${artifactLink.label?html}</a>
                                [#else]
                                    <span id="artifact-${artifactLink.label?html}">${artifactLink.label?html}</span>
                                [/#if]
                            </td>
                            <td>
                                [#if artifactLink.artifact.size != -1]
                                    <span class="filesize">${action.getArtifactSizeDescription(artifactLink)}</span>
                                [#else]
                                        <span class="filesize">[@s.text name='buildResult.artifacts.not.exists' /]</span>
                                [/#if]
                            </td>
                        </tr>
                        [/#if]
                        [#assign count = count + 1]
                    [/#list]
                [/#list]
            [/#list]
        </tbody>
    </table>
    [#if count gt limit]
        <p>
            <a href="${artifactsTabUrl}">[@s.text name='artifact.shared.showinglimit'][@ww.param value=count-limit/][/@s.text]</a>
        </p>
    [/#if]
</div>
[/#if]