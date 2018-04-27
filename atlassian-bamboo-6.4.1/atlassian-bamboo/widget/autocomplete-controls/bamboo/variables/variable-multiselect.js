define('widget/variable-multi-select', [
    'jquery',
    'underscore',
    'backbone',
    'widget/variable-single-select',
    'widget/selected-list'
], function(
    $,
    _,
    Backbone,
    VariableSingleSelect,
    SelectedList
) {

    'use strict';

    var VariableMultiSelect = Backbone.View.extend({
        initialize: function(options) {
            this.variableSelect = new VariableSingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap || [],
                maxResults: 10
            });
            this.variableSelect.on('selected', this.handleSelection, this);

            this.selectedVariables = new SelectedList({
                el: options.selectedVariablesEl,
                bootstrap: options.selectedVariables ? _.map(options.selectedVariables, function(variable) {
                    return $.extend(true, variable, {id: variable.key});
                }) : [],
                itemTemplate: bamboo.widget.autocomplete.variableSelect.item
            });
        },
        handleSelection: function(model) {
            this.selectedVariables.addItem(model);
            this.variableSelect.singleSelect.setValue('');
        }
    });

    return VariableMultiSelect;
});
