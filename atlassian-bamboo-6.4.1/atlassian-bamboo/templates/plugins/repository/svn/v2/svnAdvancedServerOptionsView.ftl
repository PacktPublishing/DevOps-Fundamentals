[@s.checkbox labelKey='repository.svn.useExternals' name='repository.svn.useExternals' disabled=true/]
[#assign useExternals = stack.findValue('repository.svn.useExternals')!false/]
[#if useExternals && stack.findValue('repository.svn.externalsToRevisionMappings')?has_content]
<table class="aui">
    <thead>
    <tr>
        <th>
            Externals Path
        </th>
        <th>
            Revision
        </th>
    </tr>
    </thead>
    <tbody>
        [#list stack.findValue('repository.svn.externalsToRevisionMappings').entrySet() as entry]
        <tr>
            <td>
            ${entry.key}?html
            </td>
            <td>
            ${entry.value}?html
            </td>
        </tr>
        [/#list]
    </tbody>
</table>
[/#if]

[@s.checkbox labelKey='repository.svn.useExport' name='repository.svn.useExport' disabled=true/]

[@s.checkbox labelKey='repository.svn.branch.autodetectRootUrl' name='repository.svn.branch.create.autodetectPath' disabled=true/]
[#assign autodetectBranchRootUrl = stack.findValue('repository.svn.branch.create.autodetectPath')!false/]
[#if !autodetectBranchRootUrl]
    [@s.textfield labelKey='repository.svn.branch.manualRootUrl' name='repository.svn.branch.create.manualPath' cssClass="long-field" disabled=true/]
[/#if]

[@s.checkbox labelKey='repository.svn.tag.autodetectRootUrl' toggle=true name='repository.svn.tag.create.autodetectPath' disabled=true/]
[#assign autodetectTagRootUrl = stack.findValue('repository.svn.tag.create.autodetectPath')!false/]
[#if !autodetectTagRootUrl]
    [@s.textfield labelKey='repository.svn.tag.manualRootUrl' name='repository.svn.tag.create.manualPath' cssClass="long-field" disabled=true/]
[/#if]
