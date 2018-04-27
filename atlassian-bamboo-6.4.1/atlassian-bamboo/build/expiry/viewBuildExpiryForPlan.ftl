[#-- @ftlvariable name="expiryConfig" type="com.atlassian.bamboo.build.expiry.CombinedExpiryConfig" --]

[#if expiryConfig.enabled]
    [#include "/admin/build/viewBuildExpiryFragment.ftl" /]
[/#if]
