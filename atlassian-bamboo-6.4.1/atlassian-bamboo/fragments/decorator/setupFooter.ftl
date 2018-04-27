    [#if ctx?? && ctx.pluggableFooter??]
        ${ctx.pluggableFooter.getHtml(req)}
    [#else]
        [#assign licenseMessage]
            [#if !bambooLicenseManager??]
            [#elseif !bambooLicenseManager.license??]
                [@ww.text name="license.footer.missing"]
                    [@ww.param]${buildUtils.getCurrentVersion()}[/@ww.param]
                    [@ww.param]${buildUtils.getCurrentBuildNumber()}[/@ww.param]
                    [@ww.param]${buildUtils.getCurrentEdition()}[/@ww.param]
                    [@ww.param]${bootstrapManager.serverID}[/@ww.param]
                [/@ww.text]
            [/#if]
        [/#assign]
        <footer id="footer" role="contentinfo"[#if licenseMessage?has_content] class="has-notifications"[/#if]>
            [#if licenseMessage?has_content]
                <section class="notifications">
                    [@ui.messageBox type="warning" id="license-message" title=licenseMessage /]
                </section>
            [/#if]
            <div class="footer-body">
                <p><a href="http://www.atlassian.com/software/bamboo/">Continuous integration</a> powered by <a href="http://www.atlassian.com/software/bamboo/">Atlassian Bamboo</a> version ${buildUtils.getCurrentVersion()} build ${buildUtils.getCurrentBuildNumber()} - [@sc.time datetime=buildUtils.getCurrentBuildDate()]${buildUtils.getCurrentBuildDate()?date?string("dd MMM yy")}[/@sc.time]</p>
                <ul>
                    <li><a href="https://support.atlassian.com/contact/">Report a problem</a></li>[#rt]
                    <li><a href="http://jira.atlassian.com/secure/CreateIssue.jspa?pid=11011&amp;issuetype=4">Request a feature</a></li>[#t]
                    <li><a href="http://www.atlassian.com/about/contact.jsp">Contact Atlassian</a></li>[#lt]
                </ul>
                <div id="footer-logo"><a href="http://www.atlassian.com/">Atlassian</a></div>
            </div> <!-- END .footer-body -->
        </footer> <!-- END #footer -->
    [/#if]
    </div> <!-- END #page -->
</body>
</html>