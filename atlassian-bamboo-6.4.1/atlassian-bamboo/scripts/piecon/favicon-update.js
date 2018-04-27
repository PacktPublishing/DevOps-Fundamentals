(function ($, BAMBOO) {
    BAMBOO.FaviconUpdate = function (opts) {
        var resourcePrefix = opts.resourcePrefix,
            url = opts.faviconRestUrl,
            update = function () {
                $.ajax({
                           url: url,
                           dataType: "json",
                           cache: false,
                           success: function (json) {
                               Piecon.setFavicon(resourcePrefix + json.faviconUrl);
                           }
                       });
                // Update again in 20 seconds
                setTimeout(update, 20000);
            };
        return {
            init: function () {
                update();
            }
        };
    }
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));
