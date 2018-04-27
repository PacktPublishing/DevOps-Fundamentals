        <footer id="footer" role="contentinfo">
            <div class="footer-body">
                <p><a href="http://www.atlassian.com/software/bamboo/">Continuous integration</a> powered by <a href="http://www.atlassian.com/software/bamboo/">Atlassian Bamboo</a> version ${buildUtils.getCurrentVersion()} build ${buildUtils.getCurrentBuildNumber()} - [@ui.time datetime=buildUtils.getCurrentBuildDate()]${buildUtils.getCurrentBuildDate()?date?string("dd MMM yy")}[/@ui.time]</p>
                <div id="footer-logo"><a href="http://www.atlassian.com/">Atlassian</a></div>
            </div> <!-- END .footer-body -->
        </footer> <!-- END #footer -->
    </div> <!-- END #page -->
</body>
</html>