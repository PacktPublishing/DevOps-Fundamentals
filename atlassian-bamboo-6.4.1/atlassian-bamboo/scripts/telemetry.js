(function ($, BAMBOO) {
    BAMBOO.TELEMETRY = (function () {
        var refreshDelay = 30000,
            refreshDelayOnError = 30000,
            wallboardSelector = "#wallboard",
            $wallboard = null,
            refresh = function () {
                $.ajax({
                    url: document.location.href,
                    cache: false,
                    data: {
                        decorator: 'nothing',
                        confirm: 'true'
                    },
                    dataType: 'html',
                    error: function () {
                        message.show("An error occurred while refreshing the wallboard.<br>Trying again soon&hellip;", "");
                        setTimeout(refresh, refreshDelayOnError);
                    },
                    success: function (data) {
                        var $response = $(data),
                            $serverMsg = $response.filter("#" + message.messageId);

                        if ($serverMsg.length) {
                            message.show($serverMsg.html(), $serverMsg.attr("class"));
                        } else {
                            message.clear();
                        }
                        $wallboard.html($response.filter(wallboardSelector).html());
                        addIndicators();
                        setTimeout(refresh, refreshDelay);
                    }
                });
            },
            addIndicators = function () {
                clearSpinners();
                $(".indicator").each(function() {
                    var $this = $(this);

                    if ($this.hasClass("building")) {
                        $this.empty().spin('medium');
                    }
                });
            },
            clearSpinners = function() {
                $(".indicator").each(function () {
                    $(this).spinStop();
                });
            },
            message = {
                blanketId: "message-blanket",
                messageId: "message",
                show: function (messageHtml, messageClass) {
                    var $blanket = $("#" + message.blanketId),
                        $message = $("#" + message.messageId);

                    if (!$blanket.length) {
                        $blanket = $("<div/>", { id: message.blanketId }).appendTo(document.body);
                    }
                    if (!$message.length) {
                        $message = $("<div/>", { id: message.messageId, html: messageHtml, "class": messageClass }).insertAfter($blanket);
                    } else {
                        $message.html(messageHtml).attr("class", messageClass);
                    }

                    return $message;
                },
                clear: function () {
                    $("#" + message.blanketId + ", #" + message.messageId).remove();
                }
            };

        $(document).delegate('.build', 'click', function (e) {
            var $details = $(this).find('.details-ext');

            $details[( $details.is(':visible') ? 'fadeOut' : 'fadeIn' )]();
        });

        $(function ($) {
            $wallboard = $(wallboardSelector);
            addIndicators();
            setTimeout(refresh, refreshDelay);
        });
    })();
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));