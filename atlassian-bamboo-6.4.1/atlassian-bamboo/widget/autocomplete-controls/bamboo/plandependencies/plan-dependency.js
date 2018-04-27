define('widget/dependent-plan-select', [
    'jquery',
    'underscore',
    'brace',
    'backbone',
    'widget/plan-single-select',
    'widget/selected-list',
    'util/events'
], function(
    $,
    _,
    Brace,
    Backbone,
    PlanSingleSelect,
    SelectedList,
    events
) {

    'use strict';

    var DependentPlanSelect = Brace.View.extend({
        mixins: [events.EventBusMixin],
        initialize: function(options) {
            this.planSelect = new PlanSingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap || [],
                maxResults: 10,
                queryData: {
                    fuzzy: true,
                    permission: 'BUILD'
                }
            });

            this.selectedPlans = new SelectedList({
                el: options.selectedPlansEl,
                bootstrap: options.bootstrap || [],
                itemTemplate: bamboo.widget.autocomplete.planDependency.item
            });

            this.onEvent('plan:selected', this.handleSelection);
        },
        // using global event-bus event handling (first argument is an instance)
        handleSelection: function(instance, model) {
            if (model instanceof Backbone.Model) {
                this.selectedPlans.addItem(model);
                this.planSelect.singleSelect.setValue('');
            }
        }
    });

    return DependentPlanSelect;
});
