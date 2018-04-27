[#macro deploymentComparisonVersionPicker action deploymentProject deploymentVersion branchName compareWithVersion=""]
    [@ww.form action=action namespace="/deploy" id="${action}Form" method="get"]
        <div id="compareWithContainer">
                    <span>[@ww.text name="deployment.version.this.version"/]</span>
            [@ui.icon type="right-arrow" showTitle=false/]
            <input type="text" name="compareWithVersion" id="compareWithVersion" placeholder="[@ww.text name="deployment.version.previous.version" /]" value="${compareWithVersion?html}" />
            <input id="form_save" class="aui-button" type="submit" accesskey="S" value="[@ww.text name='deployment.version.compare'/]" name="save">
        </div>
            [@ww.hidden name="versionId"/]
            [@ww.hidden name="deploymentProjectId"/]
            [@ww.hidden name="pageSize" value="25"/]
        <script type="text/javascript">
            require(['jquery', 'feature/version-single-select'], function($, VersionSingleSelect){
                var $compareWithVersion = $('#compareWithVersion');
                var VersionSelectWithForbiddenValue = VersionSingleSelect.extend({
                    initialize: function (options) {
                        this.options.branchKey = "${branchName?js_string}";
                        VersionSingleSelect.prototype.initialize.call(this,options);
                    },
                    parser: function (response) {
                        return _.filter(VersionSingleSelect.prototype.parser.apply(this, arguments), function(result) {
                            return result.name != '${deploymentVersion.name?js_string}';
                        });
                    }
                });
                new VersionSelectWithForbiddenValue({
                    el: $compareWithVersion,
                    bootstrap: [],
                    deploymentProjectId: ${deploymentProject.id}
                });
            });
        </script>
    [/@ww.form]
[/#macro]