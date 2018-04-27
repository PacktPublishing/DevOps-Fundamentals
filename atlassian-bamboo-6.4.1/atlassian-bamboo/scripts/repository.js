(function ($, BAMBOO) {
    BAMBOO.REPOSITORY = {};

    BAMBOO.REPOSITORY.repositoryConfig = (function () {
        var events = require('util/events');
        var defaults = {
                    addRepositoryTrigger: null,
                    repositorySetupContainer: null,
                    repositoryConfigContainer: null,
                    repositoryList: null,
                    selectRepositorySelector: "#selectedRepository",
                    templates: {
                        repositoryListItem: null,
                        repositoryListItemDefaultMarker: null,
                        iconTemplate: null
                    },
                    displayCategories: null,
                    repositoryTypeCategories: [{
                            key:"linked",
                            label:"Link existing"
                        }, {
                            key:"new",
                            label: "Create new"
                        }
                    ],
                    repositoryTypesDialog: {
                        id: "repository-types-dialog",
                        header: AJS.I18n.getText("repository.type"),
                        width: 865,
                        height: 530,
                        filterForm: null,
                        isNewAllowed: true
                    },
                    i18n: {
                        cancel: AJS.I18n.getText("global.buttons.cancel"),
                        confirmAbandonRepository: AJS.I18n.getText("repository.add.abandon"),
                        repositoryAddSuccess: AJS.I18n.getText("repository.add.success"),
                        repositoryEditSuccess: AJS.I18n.getText("repository.edit.success"),
                        repositoryDeleteSuccess: AJS.I18n.getText("repository.delete.success"),
                        sortingHasUnsavedRepositoryError: AJS.I18n.getText("repository.sort.error.hasUnsavedRepository"),
                        defaultDisplayText: AJS.I18n.getText("repository.config.noRepositorySelected"),
                        defaultDisplayTextDescription: AJS.I18n.getText("repository.config.noRepositorySelected.help"),
                        repositoryMovingError: AJS.I18n.getText("There was a problem moving your repository."),
                        repositoryMovingFailure: AJS.I18n.getText("Repository move failed")
                    },
                    moveRepositoryUrl: null,
                    markDefault: true,
                    preselectItemId: null
                },
                options,
                editor = new BAMBOO.ConfigPanelEditor(),
                $repositorySetupContainer,
                $repositoryConfigContainer,
                $repositoryList,
                $loadingIndicator,
                $repositoryTypesDialog,
                repositoryTypesDialog,
                $filterForm,

                checkListHasItems = function(hasItems) {
                    if (hasItems) {
                        markDefaultRepository();
                    }
                },
                configFormSuccess = function(data, isUnsaved) {
                    editor.displayMessages([{
                        title: isUnsaved ? options.i18n.repositoryAddSuccess : options.i18n.repositoryEditSuccess
                    }]);

                    var repositoryResult = data.repositoryResult;
                    var repositoryItemTemplateString = AJS.template.load(options.templates.repositoryListItem).fill({
                        name: repositoryResult.name,
                        id: repositoryResult.id
                    }).toString();

                    return $(repositoryItemTemplateString).addClass('active');
                },
                configFormWarnings = function (warnings) {
                    for (var i = 0, ii = warnings.length; i < ii; i++) {
                        editor.displayMessages([{ type: "warning", title: warnings[i] }]);
                    }
                },
                markDefaultRepository = function() {
                    if (options.markDefault) {
                        $repositoryList.find(".item-default").removeClass("item-default").find(".item-default-marker").remove();
                        $repositoryList.find(".item:first").addClass("item-default").find(".item-title");
                    }
                },
                addRepository = function (e) {
                    var $repositoryTypeListItem = $(this).append($(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString())),
                        $repositoryConfigLink = $repositoryTypeListItem.find(".trigger-type-title > a"),
                        $repositoryListItem = $(AJS.template.load(options.templates.repositoryListItem).fill({ name: "New Repository", id: "" }).toString());

                    e.preventDefault();

                    editor.add($repositoryConfigLink.attr("href"), $repositoryListItem, "appendTo", $repositoryList).success(function () {
                        repositoryTypesDialog.remove();
                    });
                    markDefaultRepository();
                },
                moveRepository = function ($repositoryListItem) {
                    return $.post(options.moveRepositoryUrl, {
                        repositoryId: $repositoryListItem.data("item-id"),
                        afterPosition: $repositoryListItem.nextAll(".item:first").data("item-id"),
                        beforePosition: $repositoryListItem.prevAll(".item:first").data("item-id"),
                        "bamboo.successReturnMode": "json"
                    }).done(markDefaultRepository);
                },
                setupRepositoryTypesDialogContent = function (html) {
                    var $html = $(html);

                    $loadingIndicator.hide();

                    repositoryTypesDialog.addPanel("All", $html);

                    if (options.displayCategories)
                    {
                        for (var i = 0, ii = options.repositoryTypeCategories.length; i < ii; i++)
                        {
                            var category = options.repositoryTypeCategories[i];

                            if (category.key == "new" && !options.repositoryTypesDialog.isNewAllowed)
                                continue;

                            var $categoryTasks = $html.clone();
                            $categoryTasks.children(":not(.repository-type-category-" + category.key + ")").remove();
                            if ($categoryTasks.children().length)
                            {
                                repositoryTypesDialog.addPanel(category.label, $categoryTasks);
                            }
                        }
                    }

                    repositoryTypesDialog.show().gotoPanel(0);

                    $repositoryTypesDialog = $("#" + options.repositoryTypesDialog.id).delegate(".trigger-type-list > li", "click", addRepository);

                    if (options.repositoryTypesDialog.filterForm) {
                        $filterForm.find("> input").focus();
                    }
                },
                showRepositoryTypesPicker = function (e) {
                    var $addRepositoryTrigger = $(this),
                            header = options.repositoryTypesDialog.header ? options.repositoryTypesDialog.header : $addRepositoryTrigger.text();

                    e.preventDefault();

                    if (!editor.isOkayToProceedWithUnsavedItem()) {
                        editor.setFocus();
                        return false;
                    }

                    if (!$loadingIndicator) {
                        $loadingIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($addRepositoryTrigger.closest(".aui-toolbar"));
                    } else {
                        $loadingIndicator.show();
                    }

                    repositoryTypesDialog = new AJS.Dialog({
                        id: options.repositoryTypesDialog.id,
                        width: options.repositoryTypesDialog.width,
                        height: options.repositoryTypesDialog.height,
                        keypressListener: function (e) {
                            if (e.which == jQuery.ui.keyCode.ESCAPE) {
                                repositoryTypesDialog.remove();
                            }
                        }
                    });

                    if (header) {
                        repositoryTypesDialog.addHeader(header);

                        if (options.repositoryTypesDialog.filterForm) {
                            $filterForm = $(options.repositoryTypesDialog.filterForm).appendTo(repositoryTypesDialog.page[0].header);

                            $filterForm.submit(function (e) { e.preventDefault(); }).find("> input").bind("keypress keyup click", function (e) {
                                var textToLookFor = $(this).val().toUpperCase();

                                e.stopPropagation();
                                $repositoryTypesDialog.find(".trigger-type-list > li").each(function () {
                                    var $li = $(this);

                                    $li[( $li.text().toUpperCase().indexOf(textToLookFor) >= 0 ? "show" : "hide" )]();
                                });
                            });
                        }
                    }
                    repositoryTypesDialog.addCancel(options.i18n.cancel, function () { repositoryTypesDialog.remove(); });
                    if (options.templates.getMoreOnPac) {
                        repositoryTypesDialog.addHelpText(options.templates.getMoreOnPac, {});
                    }

                    $.ajax({
                        url: $addRepositoryTrigger.attr("href"),
                        data: { decorator: "nothing", confirm: true },
                        success: setupRepositoryTypesDialogContent,
                        cache: false
                    });
                };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                editor.init({
                    editor: options.repositorySetupContainer,
                    configContainer: options.repositoryConfigContainer,
                    itemList: options.repositoryList,
                    deleteItemKey: "repositoryResult",
                    checkListHasItems: checkListHasItems,
                    configFormSuccess: configFormSuccess,
                    configFormWarnings: configFormWarnings,
                    templates: {
                        item: options.templates.repositoryListItem,
                        icon: options.templates.iconTemplate
                    },
                    i18n: {
                        confirmAbandonItem: options.i18n.confirmAbandonRepository,
                        itemDeleteSuccess: options.i18n.repositoryDeleteSuccess,
                        sortingHasUnsavedItemError: options.i18n.sortingHasUnsavedRepositoryError,
                        sortingHasUnspecifiedError: options.i18n.repositoryMovingError,
                        sortingErrorDialogHeader: options.i18n.repositoryMovingFailure,
                        defaultDisplayText: options.i18n.defaultDisplayText,
                        defaultDisplayTextDescription: options.i18n.defaultDisplayTextDescription
                    },
                    sortable: {
                        enabled: !!options.moveRepositoryUrl,
                        items: "> li:not(#repository-trigger-item)",
                        moveItem: moveRepository
                    },
                    deleteDialogHeight: 540
                });

                $(function () {
                    $repositorySetupContainer = $(options.repositorySetupContainer)
                            .delegate(options.addRepositoryTrigger, "click", showRepositoryTypesPicker);

                    $repositoryList = $(options.repositoryList);
                    $repositoryConfigContainer = $(options.repositoryConfigContainer);

                    editor.checkListHasItems();

                    if (options.preselectItemId) {
                        $(options.repositoryList).children("#item-" + options.preselectItemId).click();
                    }
                });
            }
        }
    }());


    BAMBOO.REPOSITORY.buildStrategyToggle = (function () {
        var defaults = {
                    noVcsStrategyOptions : null,
                    vcsStrategyOptions : null,
                    strategyList: null
                },
                options,
                $strategyList,
                toggleStrategiesForCreate = function () {
                    if (!$strategyList) {
                        $strategyList = $(options.strategyList);
                    }
                    var value = $strategyList.val();
                    $strategyList.attr("disabled", "disabled");
                    if ($(this).val() == "nullRepository") {
                        $strategyList.html(options.noVcsStrategyOptions);
                    } else {
                        $strategyList.html(options.vcsStrategyOptions);
                    }
                    $strategyList.removeAttr("disabled").val(value).change();
                };
        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);
                $(document).delegate("#selectedRepository", "change", toggleStrategiesForCreate);
            }
        }
    }());

    BAMBOO.REPOSITORY.CheckoutTaskConfiguration = (function () {
        var defaults = {
                    addCheckoutSelector: null,
                    removeCheckoutSelector: '.toolbar-trigger',
                    checkoutListSelector: null,
                    checkoutDirectorySelector: null,
                    selectedRepositorySelector: 'select[name^="selectedRepository_"]',
                    templates: {
                        checkoutListItem: null
                    },
                    i18n: {
                        checkoutDirectoryInUse: null
                    }
                },
                options,
                $list,
                $form,
                addCheckoutListItem = function () {
                    var newIndex, $lastCheckout;

                    $lastCheckout = $list.children(':last');
                    newIndex = ($lastCheckout.length ? (parseInt($lastCheckout.attr('data-checkout-id'), 10) + 1) : 0);

                    $(AJS.template.load(options.templates.checkoutListItem).fill({ index: newIndex }).toString())
                            .hide().appendTo($list)
                            .find(options.selectedRepositorySelector).end()
                            .slideDown();

                    BAMBOO.DynamicFieldParameters.syncFieldShowHide($list);
                },
                removeCheckoutListItem = function () {
                    $(this).closest('.aui-toolbar').closest('li').slideUp(function () { $(this).remove(); });
                },
                validateForm = function (e) {
                    var checkoutDirectories = {},
                            hasError = false,
                            checkField = function () {
                                var $field = $(this),
                                        val = $field.val();

                                if (checkoutDirectories.hasOwnProperty(val)) {
                                    $('<div/>', { 'class': 'error', text: options.i18n.checkoutDirectoryInUse }).insertAfter($field.next('.description'));
                                    hasError = true;
                                } else {
                                    checkoutDirectories[val] = true;
                                }
                            },
                            $trigger = $(this),
                            $fieldsToCheck = $form.find(options.checkoutDirectorySelector);

                    $form.find('.error').remove();

                    if ($trigger.is(':text')) {
                        $fieldsToCheck = $fieldsToCheck.not($trigger);
                        $fieldsToCheck.each(checkField);
                        checkField.apply(this);
                    } else {
                        $fieldsToCheck.each(checkField);
                        if (hasError) {
                            e.preventDefault();
                            e.stopPropagation();
                        }
                    }
                };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                $(function () {
                    $list = $(options.checkoutListSelector)
                            .delegate(options.removeCheckoutSelector, 'click', removeCheckoutListItem)
                            .delegate(options.checkoutDirectorySelector, 'blur', validateForm);

                    $form = $list.closest('form').submit(validateForm);
                    $(options.addCheckoutSelector).click(addCheckoutListItem);
                });
            }
        };
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));