[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.plans.admin.ConfigurePlanDependencies" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.plans.admin.ConfigurePlanDependencies" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@ww.text name="chain.dependency.description" var="chainDependencyDescription"]
    [@ww.param][@help.href pageKey="dependency.general"/][/@ww.param]
[/@ww.text]

[@eccc.editChainConfigurationPage  plan=immutablePlan selectedTab='dependencies' titleKey='chain.dependency.title' description=chainDependencyDescription]

    [#assign pluginInjectedConfiguration = dependenciesBuildConfigurationEditHtml /]

    [#if possiblePlanDependencies?has_content || pluginInjectedConfiguration?has_content]
        [@ww.form id='updateChainDependencies' action='updateChainDependencies' cancelUri='/browse/${immutablePlan.key}/config' submitLabelKey='global.buttons.update']

            [#if possiblePlanDependencies?has_content]

                [@ui.bambooSection ]

                    [#assign addChildPlanTextfield = 'childPlanKeys' /]
                    [#assign childPlansListClass = 'dependencies-child-plans' /]
                    [@ww.textfield id=addChildPlanTextfield name=addChildPlanTextfield cssClass="long-field"
                        labelKey='chain.dependency.child.title' placeholderKey='chain.dependency.child.search' /]
                    [@ui.displayFieldGroup descriptionKey='chain.dependency.child.description']
                        ${soy.render("bamboo.widget.autocomplete.planDependency.list", {
                            "dependencies": childPlans,
                            "isParent": true,
                            "extraClasses": childPlansListClass + " bamboo-selected-set-list"
                        })}
                    [/@ui.displayFieldGroup]
                    <script type="text/javascript">
                        require(['jquery', 'widget/dependent-plan-select'], function($, DependentPlanSelect){
                            return new DependentPlanSelect({
                                el: $('#${addChildPlanTextfield?js_string}'),
                                selectedPlansEl: $('.${childPlansListClass?js_string}'),
                                bootstrap: ${childPlansJson.toString()}
                            });
                        });
                    </script>
                [/@ui.bambooSection]

            [#else]
                [@ww.hidden name='custom.dependencies.triggerForBranches'/]
            [/#if]

            [@ui.bambooSection titleKey='chain.dependency.advanced' collapsible=true isCollapsed=true]

                [@ww.hidden name="buildKey" /]

                [@ww.checkbox labelKey='chain.dependency.trigger_only_after_all_stages' name='custom.dependencies.triggerOnlyAfterAllStages'/]

                ${pluginInjectedConfiguration}

                [#if possiblePlanDependencies?has_content]

                    [@ww.checkbox labelKey='chain.config.branches.dependencies' name='custom.dependencies.triggerForBranches'/]

                    [#if parentPlanKeys?has_content]
                        [@ui.bambooSection titleKey='chain.dependency.parent']
                            [@ui.displayFieldGroup descriptionKey='chain.dependency.parent.description']
                            ${soy.render("bamboo.widget.autocomplete.planDependency.list", {
                                "dependencies": parentPlans,
                                "isParent": false,
                                "extraClasses": "dependencies-parent-plans bamboo-selected-set-list",
                                "isReadOnly": true
                            })}
                            [/@ui.displayFieldGroup]
                        [/@ui.bambooSection]
                    [/#if]

                    [#assign dependencyBlockingTitle]
                        [@ww.text name="chain.dependency.strategy"/]
                        <span class="aui-icon icon-help" id="chainDependencyStrategyInfo">Info</span>
                    [/#assign]
                    [@ui.bambooSection title=dependencyBlockingTitle ]

                        [#assign inlineText]
                            [@ui.displayText]
                                [@ww.text name='chain.dependency.long.description']
                                    [@ww.param][@help.url pageKey="dependency.blocking"][@ww.text name="chain.dependency.strategy"/][/@help.url][/@ww.param]
                                [/@ww.text]
                            [/@ui.displayText]
                        [/#assign]

                        <script>
                            AJS.InlineDialog(AJS.$("#chainDependencyStrategyInfo"), 1,
                                    function (content, trigger, showPopup) {
                                        content.html("${inlineText?js_string}");
                                        showPopup();
                                        return false;
                                    }, {hideDelay: null, offsetX: -60, arrowOffsetX: -7, width: 420}
                            );
                        </script>
                        [@ww.radio name="custom.dependencies.trigger.remote.strategy" listKey="value" listValue="value" i18nPrefixForValue="chain.dependency.strategy" showDescription=true list=dependencyBlockingStrategies /]
                    [/@ui.bambooSection]
                [/#if]

            [/@ui.bambooSection]

        [/@ww.form]
    [#else]
        <p>
            [@ww.text name='chain.dependency.possible.none' /]
        </p>
    [/#if]
[/@eccc.editChainConfigurationPage]