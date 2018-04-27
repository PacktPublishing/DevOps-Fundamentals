(function (window) {
    window.BAMBOO = (window.BAMBOO || {});

    BAMBOO.SetupWait = (function ($) {
        var defaults = {
                refreshDelay: 2000,
                currentUrl: null,
                completedUrl: null,
                spinnerId: null
            },
            options,
            refreshStatus = function () {
                $.post(BAMBOO.contextPath + options.currentUrl, { "statusRequest": true }, onComplete, "json");
            },
            onComplete = function (data) {
                if (data.completed) {
                    if (options.completedUrl) {
                        window.location = BAMBOO.contextPath + options.completedUrl;
                    } else if (options.currentUrl) {
                        window.location = BAMBOO.contextPath + options.currentUrl;
                    } else {
                        window.location.reload(true);
                    }
                } else {
                    setTimeout(refreshStatus, options.refreshDelay);
                }
            };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                setTimeout(refreshStatus, options.refreshDelay);
                $(function () {
                    $('#' + options.spinnerId).spin({
                        length: 20,
                        lines: 12,
                        radius: 30,
                        speed: 1.5,
                        trail: 60,
                        width: 15
                    });
                });
            }
        };
    })(jQuery);
})(window);