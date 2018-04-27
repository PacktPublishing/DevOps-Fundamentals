(function ($, BAMBOO) {
    BAMBOO.TRIGGER = {};

    BAMBOO.TRIGGER.chainTriggerConfig = (function () {
        var defaults = {
                    addTriggerTrigger: null,
                    triggerSetupContainer: null,
                    triggerConfigContainer: null,
                    triggerList: null,
                    templates: {
                        triggerListItem: null,
                        triggerListItemDefaultMarker: null,
                        iconTemplate: null,
                        lozengeDisabled: null
                    },
                    triggerTypesDialog: {
                        id: "trigger-types-dialog",
                        header: AJS.I18n.getText("trigger.types.title"),
                        width: 865,
                        height: 530,
                        filterForm: null
                    },
                    i18n: {
                        cancel: AJS.I18n.getText("global.buttons.cancel"),
                        confirmAbandonTrigger: AJS.I18n.getText("chain.trigger.add.abandon"),
                        triggerAddSuccess: AJS.I18n.getText("chain.trigger.add.success"),
                        triggerEditSuccess: AJS.I18n.getText("chain.trigger.edit.success"),
                        triggerDeleteSuccess: AJS.I18n.getText("chain.trigger.delete.success"),
                        defaultDisplayText: AJS.I18n.getText("chain.trigger.config.noTriggerSelected"),
                        defaultDisplayTextDescription: AJS.I18n.getText("chain.trigger.config.noTriggerSelected.help")
                    },
                    preselectItemId: null
                },
                options,
                editor = new BAMBOO.ConfigPanelEditor(),
                $triggerSetupContainer,
                $triggerConfigContainer,
                $triggerList,
                $loadingIndicator,
                $triggerTypesDialog,
                triggerTypesDialog,
                checkListHasItems = function(hasItems) {
                },
                configFormSuccess = function (data, isUnsaved) {
                    editor.displayMessages([{ title: (isUnsaved ? options.i18n.triggerAddSuccess : options.i18n.triggerEditSuccess) }]);
                    var triggerItem = $(AJS.template.load(options.templates.triggerListItem).fill({ name: data.triggerResult.name, id: data.triggerResult.id, description: data.triggerResult.description }).toString()).addClass("active");
                    if (data.triggerResult.isEnabled === false) {
                        $(AJS.template.load(options.templates.lozengeDisabled).toString()).insertBefore(triggerItem.find(".delete"));
                    }
                    return triggerItem;
                },
                configFormWarnings = function (warnings) {
                    for (var i = 0, ii = warnings.length; i < ii; i++) {
                        editor.displayMessages([{ type: "warning", title: warnings[i] }]);
                    }
                },
                addTrigger = function (e) {
                    var $triggerTypeListItem = $(this).append($(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString())),
                        $triggerConfigLink = $triggerTypeListItem.find(".trigger-type-title > a"),
                        $triggerListItem = $(AJS.template.load(options.templates.triggerListItem).fill({ name: $triggerConfigLink.text(), description: "", id: "" , valid : true }).toString());

                    e.preventDefault();

                    editor.add($triggerConfigLink.attr("href"), $triggerListItem, "appendTo", $triggerList).success(function () {
                        triggerTypesDialog.remove();
                    });

                },
                setupTriggerTypesDialogContent = function (html) {
                    var $html = $(html);

                    $loadingIndicator.hide();

                    triggerTypesDialog.addPanel("All", $html);
                    triggerTypesDialog.show().gotoPanel(0);

                    $triggerTypesDialog = $("#" + options.triggerTypesDialog.id).delegate(".trigger-type-list > li", "click", addTrigger);

                    if (options.triggerTypesDialog.filterForm) {
                        $filterForm.find("> input").focus();
                    }
                },
                showTaskTypesPicker = function (e) {
                    var $addTriggerTrigger = $(this),
                        header = options.triggerTypesDialog.header ? options.triggerTypesDialog.header : $addTriggerTrigger.text();

                    e.preventDefault();

                    if (!editor.isOkayToProceedWithUnsavedItem()) {
                        editor.setFocus();
                        return false;
                    }

                    if (!$loadingIndicator) {
                        $loadingIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($addTriggerTrigger.closest(".aui-toolbar"));
                    } else {
                        $loadingIndicator.show();
                    }

                    triggerTypesDialog = new AJS.Dialog({
                                                         id: options.triggerTypesDialog.id,
                                                         width: options.triggerTypesDialog.width,
                                                         height: options.triggerTypesDialog.height,
                                                         keypressListener: function (e) {
                                                             if (e.which == jQuery.ui.keyCode.ESCAPE) {
                                                                 triggerTypesDialog.remove();
                                                             }
                                                         }
                                                     });

                    if (header) {
                        triggerTypesDialog.addHeader(header);

                        if (options.triggerTypesDialog.filterForm) {
                            $filterForm = $(options.triggerTypesDialog.filterForm).appendTo(triggerTypesDialog.page[0].header);

                            $filterForm.submit(function (e) { e.preventDefault(); }).find("> input").bind("keypress keyup click", function (e) {
                                var textToLookFor = $(this).val().toUpperCase();

                                e.stopPropagation();
                                $triggerTypesDialog.find(".trigger-type-list > li").each(function () {
                                    var $li = $(this);

                                    $li[( $li.text().toUpperCase().indexOf(textToLookFor) >= 0 ? "show" : "hide" )]();
                                });
                            });
                        }
                    }
                    triggerTypesDialog.addCancel(options.i18n.cancel, function () { triggerTypesDialog.remove(); });
                    if (options.templates.getMoreOnPac) {
                        triggerTypesDialog.addHelpText(options.templates.getMoreOnPac, {});
                    }

                    $.ajax({
                               url: $addTriggerTrigger.attr("href"),
                               data: { decorator: "nothing", confirm: true },
                               success: setupTriggerTypesDialogContent,
                               cache: false
                           });
                };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                editor.init({
                                editor: options.triggerSetupContainer,
                                configContainer: options.triggerConfigContainer,
                                itemList: options.triggerList,
                                deleteItemKey: "triggerResult",
                                checkListHasItems: checkListHasItems,
                                configFormSuccess: configFormSuccess,
                                configFormWarnings: configFormWarnings,
                                templates: {
                                    item: options.templates.triggerListItem,
                                    icon: options.templates.iconTemplate
                                },
                                i18n: {
                                    confirmAbandonItem: options.i18n.confirmAbandonTrigger,
                                    itemDeleteSuccess: options.i18n.triggerDeleteSuccess,
                                    defaultDisplayText: options.i18n.defaultDisplayText,
                                    defaultDisplayTextDescription: options.i18n.defaultDisplayTextDescription
                                },
                                sortable: {
                                    enabled: false
                                }
                            });

                $(function () {
                    $triggerSetupContainer = $(options.triggerSetupContainer)
                            .delegate(options.addTriggerTrigger, "click", showTaskTypesPicker);
                    $triggerList = $(options.triggerList);
                    $triggerConfigContainer = $(options.triggerConfigContainer);

                    editor.checkListHasItems();

                    if (options.preselectItemId) {
                        $(options.triggerList).children("#item-" + options.preselectItemId).click();
                    }
                });
            }
        }
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));