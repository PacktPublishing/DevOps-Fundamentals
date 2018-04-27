[@s.label labelKey='repository.svn.useExternals' value=repository.useExternals hideOnNull=true /]
[@s.label labelKey='repository.svn.useExport' value=repository.useExport hideOnNull=true /]
[@s.label labelKey='repository.common.commitIsolation.enabled' value=repository.commitIsolationEnabled hideOnNull=true /]

[#if !repository.autodetectBranchRootUrl]
    [@s.label labelKey='repository.svn.branch.manualRootUrl' value=repository.manualBranchRootUrl/]
[/#if]

[#if !repository.autodetectTagRootUrl]
    [@s.label labelKey='repository.svn.tag.manualRootUrl' value=repository.manualTagRootUrl/]
[/#if]