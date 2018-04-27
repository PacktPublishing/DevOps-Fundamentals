[#-- @ftlvariable name="linkGenerator" type="com.atlassian.bamboo.vcs.viewer.runtime.VcsRepositoryViewer" --]
[#-- @ftlvariable name="repositoryChangeset" type="com.atlassian.bamboo.resultsummary.vcs.RepositoryChangeset" --]

[#macro displayChangeSet resultsSummary repositoryData repositoryChangeset linkGenerator]
    [#if repositoryChangeset.commits?has_content]
        [@ui.bambooInfoDisplay title=repositoryChangeset.repositoryData.name?html headerWeight='h2']
        <ul>
        [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
            <li>
                [@ui.displayAuthorAvatarForCommit commit=commit avatarSize='24' /]
                <h3>
                    <a href="[@cp.displayAuthorOrProfileLink author=commit.author /]">[@ui.displayAuthorFullName author=commit.author /]</a>
                    <span class="revision-date">
                        [@ui.time datetime=commit.date relative=true /]
                    </span>
                    [#if "Unknown" != commit.author.name]
                        [#assign guessedRevision = commit.guessChangeSetId()!("")]
                        [#assign commitUrl = (linkGenerator.getWebRepositoryUrlForRevision(guessedRevision, repositoryData))!('') /]
                        [#if commitUrl?has_content && guessedRevision?has_content]
                            <a href="${commitUrl?html}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]">${guessedRevision?html}</a>
                        [#else ]
                            <span class="revision-id" title="[@ww.text name='webRepositoryViewer.error.cantCreateUrl' /]">${commit.changeSetId!?html}</span>
                        [/#if]
                        [#if commit.foreignCommit!false]
                            [@ui.lozenge textKey="commit.merged"  showTitle=false/]
                        [/#if]
                    [/#if]
                </h3>
                <p>[@ui.renderValidJiraIssues commit.comment resultsSummary /]</p>
               <ul class="files">
                    [#list commit.files as file]
                    <li>
                        [#if "Unknown" != commit.author.name]
                           [#assign fileLink = linkGenerator.getWebRepositoryUrlForFile(file, repositoryData)!]
                           [#if fileLink?has_content]
                              <a href="${fileLink?html}">${file.cleanName!?html}</a>
                           [#else]
                              ${file.cleanName!?html}
                           [/#if]
                           [#if file.revision?has_content]
                                [#local fileLinkUrl = linkGenerator.getWebRepositoryUrlForFileRevision(file, repositoryData)!/]
                                [#if fileLinkUrl?has_content]
                                    <a href="${fileLinkUrl?html}">(version ${file.revision?html})</a>
                                [#else]
                                    (version ${file.revision?html})
                                [/#if]
                                [#local fileDiffUrl = linkGenerator.getWebRepositoryUrlForFileDiff(file, repositoryData)!/]
                                [#if fileDiffUrl?has_content]
                                    <a href="${fileDiffUrl?html}">(diffs)</a>
                                [/#if]
                           [/#if]
                        [#else]
                            ${file.cleanName!?html}
                            [#if file.revision??]
                            (version ${file.revision?html})
                            [/#if]
                        [/#if]
                    </li>
                    [/#list]
                </ul>
            </li>
        [/#list]
        </ul>
        [/@ui.bambooInfoDisplay]
    [/#if]
[/#macro]

[#macro displayChangeSetWithoutViewer resultsSummary repositoryData repositoryChangeset]
    [#if repositoryChangeset.commits?has_content]
        [@ui.bambooInfoDisplay title=repositoryChangeset.repositoryData.name?html headerWeight='h2']
        <ul>
            [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
                <li>
                    [@ui.displayAuthorAvatarForCommit commit=commit avatarSize='24' /]
                    <h3>
                        <a href="[@cp.displayAuthorOrProfileLink author=commit.author /]">[@ui.displayAuthorFullName author=commit.author /]</a>
                        <span class="revision-date">
                            [@ui.time datetime=commit.date relative=true /]
                        </span>
                        <span class="revision-id">${commit.changeSetId!?html}</span>
                        [#if commit.foreignCommit!false]
                            [@ui.lozenge textKey="commit.merged" showTitle=false/]
                        [/#if]
                    </h3>
                    <p>[@ui.renderValidJiraIssues commit.comment resultsSummary /]</p>
                    <ul class="files">
                        [#list commit.files as file]
                            <li>
                            ${file.cleanName!?html}
                                (version ${file.revision!?html})
                            </li>
                        [/#list]
                    </ul>
                </li>
            [/#list]
        </ul>
        [/@ui.bambooInfoDisplay]
    [/#if]
[/#macro]

