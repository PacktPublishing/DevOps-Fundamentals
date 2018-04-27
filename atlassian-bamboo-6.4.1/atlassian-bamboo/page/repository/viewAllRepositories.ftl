[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.ViewAllRepositories" --]

<html>
<head>
    [@ui.header pageKey="menu.vcs" title=true/]
    <meta name="decorator" content="atl.vcs"/>
</head>
<body>

[#assign repositories=allRepositories /]

[#if repositories?size > 0]
    [@ui.header descriptionKey="repository.list.description"/]

    <table class="aui aui-zebra" id="dashboard">
        <colgroup>
            <col style="min-width: 200px;"/>
            <col width="25%"/>
            <col width="30%"/>
            <col width="76px"/>
        </colgroup>
        <thead>
        <tr>
            <th>[@s.text name="repository.name"/]</th>
            <th>[@s.text name="repository.type"/]</th>
            <th>[@s.text name="repository.location"/]</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
            [#list repositories as rd]
            <tr>
                <td><a id="viewRepository:${rd.repositoryData.id}" href="[@s.url namespace='/admin' action='viewLinkedRepository' repositoryId=rd.repositoryData.id/]">${rd.repositoryData.name?html}</a></td>
                <td>${rd.repositoryData.name?html}</td>
                <td>${rd.locationIdentifier!?html}</td>
                <td>[#if fn.hasEntityPermission('ADMINISTRATION', rd.repositoryData) ]
                    <a id="editRepository:${rd.repositoryData.id}" href="[@s.url namespace='/admin' action='editLinkedRepository' repositoryId=rd.repositoryData.id/]">[@ui.icon useIconFont=true type="edit" text="Edit repository"/]</a>
                    <a class="delete" id="${rd.repositoryData.id}deleteRepository:${rd.repositoryData.id}" href="[@s.url namespace='/admin' action='confirmDeleteLinkedRepository' repositoryId=rd.repositoryData.id/]">[@ui.icon useIconFont=true type="delete" text="Delete repository"/]</a>
                [/#if]</td>
            </tr>
            [/#list]
        </tbody>
    </table>
[#else]
    [#assign emptyMessageLinks]
        [#if fn.hasGlobalPermission('CREATEREPOSITORY') ]
            <li><a href="[@ww.url action='viewLinkedRepositoryTypes' namespace='/admin'/]">[@ww.text name="vcs.create.new.title" /]</a></li>
        [/#if]
    [/#assign]
    [@ui.emptyStateHelp textKey="repository.list.description" links=emptyMessageLinks extraClasses="empty-state-main" /]
[/#if]

[@ww.text var="repositoryDeleteHeader" name="repository.delete" /]
<script type="text/javascript">
    AJS.$(function() {
        BAMBOO.simpleDialogForm({
            trigger: '#dashboard .delete',
            dialogWidth: 540,
            dialogHeight: 400,
            header: '${repositoryDeleteHeader?js_string}',
            success: redirectAfterReturningFromDialog
        });
    });
</script>
</body>
</html>