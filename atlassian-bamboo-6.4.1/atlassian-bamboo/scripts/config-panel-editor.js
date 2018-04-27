BAMBOO.ConfigPanelEditor = function () {
    var events = require('util/events');
    var $ = AJS.$,
        defaults = {
            editor: null,
            configContainer: null,
            itemList: null,
            deleteItemKey: null,
            configFormSuccess: $.noop,
            configFormWarnings: $.noop,
            checkListHasItems: $.noop,
            templates: {
                item: null,
                icon: null
            },
            i18n: {
                confirmAbandonItem: null,
                itemDeleteSuccess: null,
                sortingHasUnsavedItemError: null,
                sortingHasUnspecifiedError: null,
                sortingErrorDialogHeader: null,
                defaultDisplayText: null,
                defaultDisplayTextDescription: null
            },
            sortable: {
                enabled: true,
                items: "> li",
                moveItem: $.noop
            },
            deleteDialogHeight: 200,
            onShowData: null
        },
        options,
        $editor,
        $configContainer,
        $itemList,
        setFocus = function () {
            var $firstError = $configContainer.find(":input:visible:enabled.errorField:first").focus();

            if (!$firstError.length) {
                $configContainer.find(":input:visible:enabled:first").focus();
            }
        },
        insertDefaultText = function () {
            var noItemId = "no-item-selected",
                $noItem = $("#" + noItemId);

            if (!$noItem.length) {
                $noItem = $("<div/>", { "id": noItemId })
                    .append($("<h2/>", { text: options.i18n.defaultDisplayText }))
                    .append($("<p/>", { text: options.i18n.defaultDisplayTextDescription }))
                    .hide()
                    .prependTo($configContainer)
                    .fadeIn();
            }
            return $noItem;
        },
        setupAsyncForm = function ($item) {
            BAMBOO.asyncForm({
                $delegator: $configContainer,
                target: "form",
                success: function (data) {
                    var $newItem = options.configFormSuccess(data, $item.hasClass("unsaved"));
                    $item.replaceWith($newItem);
                    if (data.warnings) {
                        options.configFormWarnings(data.warnings);
                    }
                    setTimeout(function () { $newItem.removeClass("active"); }, 0); // this is so that the class doesn't get removed immediately after the DOM element is replaced which would causes the CSS transition (fading) not to be applied
                },
                cancel: function () {
                    // simply empty the container
                    $configContainer.empty();

                    // clean previous widgets
                    events.EventBus.trigger('unbind');

                    if ($item.hasClass("unsaved")) {
                        $item.remove();
                        checkListHasItems();
                    } else {
                        $item.removeClass("active");
                    }
                    insertDefaultText();
                },
                formReplaced: asyncFormReplaced
            });
        },
        asyncFormReplaced = function () {
            handleOnShow();
            setFocus();
        },
        showItemLoadingIndicator = function ($item) {
            var $configLink;
            if (!$item) {
                $item = $itemList.find('.active');
            }
            $configLink = $item.find("> a:not(.delete)");
            $(AJS.template.load(options.templates.icon).fill({ type: "loading" }).toString()).insertAfter($configLink);
        },
        hideItemLoadingIndicator = function ($item) {
            if (!$item) $item = $itemList.find('.active');
            $item.find(".icon-loading").remove();
        },
        hasUnsavedItem = function () {
            var $unsaved = $itemList.find(".unsaved");

            return ($unsaved.length ? $unsaved : false);
        },
        isOkayToProceedWithUnsavedItem = function () {
            var $unsavedItem = hasUnsavedItem();

            if ($unsavedItem) {
                if (confirm(options.i18n.confirmAbandonItem)) {
                    $unsavedItem.remove();
                    $configContainer.empty();
                    checkListHasItems();
                } else {
                    return false;
                }
            }
            return true;
        },
        checkListHasItems = function () {
            var hasItems = $itemList.children(".item").length;

            $editor.toggleClass("no-items", !hasItems);
            options.checkListHasItems(hasItems);
        },
        add = function (url, $item, attachMethod, attachTarget) {
            // clean previous widgets
            events.EventBus.trigger('unbind');

            return $.ajax({
                url: url,
                data: { decorator: 'nothing', confirm: true },
                success: function (html) {
                    $item[attachMethod](attachTarget).addClass("active unsaved").siblings().removeClass("active");
                    checkListHasItems();
                    $configContainer.html(html);
                    handleOnShow();
                    setupAsyncForm($item);
                    setFocus();
                    if (options.onShowData) {
                        options.onShowData();
                    }
                },
                cache: false
            });
        },
        edit = function (e) {
            var $item = $(this),
                $target = $(e.target),
                showData = function (html) {
                    $configContainer.html(html);
                    handleOnShow();
                    hideItemLoadingIndicator($item);
                    $item.addClass("active").siblings().removeClass("active");
                    setupAsyncForm($item);
                    setFocus();
                    if (options.onShowData) {
                        options.onShowData();
                    }
                };

            if (!$target.hasClass("delete") && !$target.hasClass("icon-delete") && !$target.is(":input")) {
                e.preventDefault();
                if ($item.hasClass("active") || !isOkayToProceedWithUnsavedItem()) {
                    setFocus();
                } else {
                    showItemLoadingIndicator($item);

                    // clean previous widgets
                    events.EventBus.trigger('unbind');

                    $.ajax({
                        url: $item.find("> a:not(.delete)").attr("href"),
                        data: { decorator: 'nothing', confirm: true },
                        success: showData,
                        error: function (data) {
                            showData(data.responseText ? data.responseText : data.responseXML);
                        },
                        cache: false
                    });
                }
            }
        },
        sortUpdate = function (event, ui) {
            if (hasUnsavedItem()) {
                alert(options.i18n.sortingHasUnsavedItemError);
                $itemList.sortable("cancel");
                return;
            }
            var Dialog2 = require('widget/dialog2');
            var $item = $(ui.item),
                showSortingError = function (errors) {
                    var index = $item.prevAll().length;
                    var errorsLength = errors.length;
                    var $content;

                    if (!errors || errorsLength === 0) {
                        $content = $('<div />', {text: options.i18n.sortingHasUnspecifiedError});
                    } else if (errorsLength === 1) {
                        $content = $('<div />', {text: errors[0]});
                    } else {
                        $content = $('<ul />').append(errors.map(function(error) {
                            return $('<li />', {text: error});
                        }));
                    }

                    Dialog2.show({
                        warning: true,
                        removeOnHide: true,
                        titleText: options.i18n.sortingErrorDialogHeader,
                        content: $content.wrap('<div />').parent().html(),
                        size: Dialog2.SMALL
                    });

                    if (($itemList.children().length - 1) == $item.data("movedFromPos")) {
                        $item.appendTo($itemList).removeData("movedFromPos");
                    } else {
                        $item.insertBefore($itemList.children("li:eq(" + ($item.data("movedFromPos") + (($item.data("movedFromPos") > index) ? 1 : 0)) + ")")).removeData("movedFromPos");
                    }
                },
                jqXHR = options.sortable.moveItem($item);

            if (jqXHR) {
                jqXHR.done(function (json) {
                    if (json.status == "ERROR") {
                        if (json.errors && json.errors.length) {
                            showSortingError(json.errors);
                        } else {
                            showSortingError();
                        }
                    }
                }).fail(function () {
                    showSortingError();
                });
            }
        },
        sortStart = function (event, ui) {
            var $self = $(ui.item);

            $self.data("movedFromPos", $self.prevAll().length);
        },
        handleOnShow = function () {
            BAMBOO.DynamicFieldParameters.syncFieldShowHide($configContainer);
            AJS.messages.setup();
        };

    return {
        displayMessages: function (messages) {
            var $dummy = $("<div/>"),
                $messages,
                defaultMsgType = "success";

            for (var i = 0, ii = messages.length; i < ii; i++) {
                var message = messages[i],
                    msgType = message.type || defaultMsgType;

                AJS.messages[msgType]($dummy, { title: message.title, closeable: (msgType != defaultMsgType), body: message.body });
            }

            $messages = $dummy.children();

            $configContainer.empty();
            $configContainer.append($messages);

            $messages.filter("." + defaultMsgType).delay(3000).fadeOut(function () {
                $(this).remove();
            });
            insertDefaultText();
        },

        init: function (opts) {
            options = $.extend(true, defaults, opts);

            var self = this;

            $(document)
                .delegate(options.itemList + " > .item", "click", edit)
                .delegate("#finalisePlanCreation, #finaliseJobCreation", "submit", function (e) {
                    if (!isOkayToProceedWithUnsavedItem()) {
                        e.preventDefault();
                    }
                });

            $(function () {
                $editor = $(options.editor);
                $configContainer = $(options.configContainer)
                    .delegate("form", "submit", function () {
                        showItemLoadingIndicator();

                        // clean previous widgets
                        events.EventBus.trigger('unbind');
                    })
                    .delegate("form", "asyncform-error asyncform-replaced", function () {
                        hideItemLoadingIndicator();
                    });
                $itemList = $(options.itemList);
                if (options.sortable.enabled) {
                    $itemList.sortable({
                        cursor: "move",
                        items: options.sortable.items,
                        update: sortUpdate,
                        start: sortStart
                    });
                }

                BAMBOO.simpleDialogForm({
                    $delegator: $itemList,
                    trigger: "a.delete",
                    dialogWidth: 540,
                    dialogHeight: options.deleteDialogHeight,
                    success: function (data) {
                        self.displayMessages([{ title: options.i18n.itemDeleteSuccess }]);
                        $("#item-" + data[options.deleteItemKey].id).remove();
                        checkListHasItems();
                        events.EventBus.trigger('config-panel-item-removed', data);
                    }
                });
                insertDefaultText();
            });
        },
        add: add,
        setFocus: setFocus,
        isOkayToProceedWithUnsavedItem: isOkayToProceedWithUnsavedItem,
        checkListHasItems: checkListHasItems,
        updateUnspecifiedSortingErrorText: function (updatedText) {
            options.i18n.sortingHasUnspecifiedError = updatedText;
        }
    }
};
