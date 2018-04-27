//
// piecon.js
//
// https://github.com/lipka/piecon
//
// Copyright (c) 2012 Lukas Lipka <lukaslipka@gmail.com>. All rights reserved.
//
// Licenced under MIT Licence
//
// Modified by Atlassian
(function($, Piecon) {
    var currentFavicon = null;
    var originalFavicon = null;
    var originalTitle = null;
    var canvas = null;
    var options = {};
    var defaults = {
        color: '#3b73af',
        //background: '#999',
        background: '#ccd9ea',
        shadow: '#fff',
        fallback: false
    };

    var isRetina = window.devicePixelRatio > 1;

    var ua = (function () {
        var agent = navigator.userAgent.toLowerCase();
        return function (browser) {
            return agent.indexOf(browser) !== -1;
        };
    }());

    var browser = {
        ie: ua('msie'),
        chrome: ua('chrome'),
        webkit: ua('chrome') || ua('safari'),
        safari: ua('safari') && !ua('chrome'),
        mozilla: ua('mozilla') && !ua('chrome') && !ua('safari')
    };

    var getFaviconTag = function() {
        var links = $("head").find("link");

        for (var l = links.length, i = l-1; i >= 0; i--) {
            if (links[i].getAttribute('rel') === 'icon' || links[i].getAttribute('rel') === 'shortcut icon') {
                return links[i];
            }
        }
        return false;
    };

    var removeFaviconTag = function() {
        var $head = $("head");
        $head.find("link[rel='icon']").remove();
        $head.find("link[rel='shortcut icon']").remove();
    };

    var setFaviconTag = function(url) {
        removeFaviconTag();
        $("head").append("<link rel='icon' type='image/x-icon' href='" + url + "'/>")
    };

    var getCanvas = function () {
        if (!canvas) {
            canvas = document.createElement("canvas");
            if (isRetina) {
                canvas.width = 32;
                canvas.height = 32;
            } else {
                canvas.width = 16;
                canvas.height = 16;
            }
        }

        return canvas;
    };

    var drawFavicon = function(percentage) {
        var canvas = getCanvas();
        var context = canvas.getContext("2d");
        var percentage = percentage || 0;
        var src = currentFavicon;

        var faviconImage = new Image();
        faviconImage.onload = function() {
            if (context) {
                context.clearRect(0, 0, canvas.width, canvas.height);

                // Draw empty circle
                context.beginPath();
                context.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width / 2 -1 , canvas.height / 2 -1), 0, Math.PI * 2, false);
                context.strokeStyle = options.color;
                context.stroke();

                // Draw pie
                if (percentage > 0) {
                    context.beginPath();
                    context.moveTo(canvas.width / 2, canvas.height / 2);
                    context.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width / 2 - 1, canvas.height / 2 -1), (-0.5) * Math.PI, (-0.5 + 2 * percentage / 100) * Math.PI, false);
                    context.lineTo(canvas.width / 2, canvas.height / 2);
                    context.fillStyle = options.color;
                    context.fill();
                }

                setFaviconTag(canvas.toDataURL());
            }
        };

        // allow cross origin resource requests if the image is not a data:uri
        // as detailed here: https://github.com/mrdoob/three.js/issues/1305
        if (!src.match(/^data/)) {
            faviconImage.crossOrigin = 'anonymous';
        }

        faviconImage.src = src;
    };

    var updateTitle = function(percentage) {
        if (percentage > 0) {
            document.title = '(' + percentage + '%) ' + originalTitle;
        } else {
            document.title = originalTitle;
        }
    };

    Piecon.setOptions = function(custom) {
        options = {};

        for (var key in defaults){
            options[key] = custom.hasOwnProperty(key) ? custom[key] : defaults[key];
        }

        return this;
    };

    Piecon.setProgress = function(percentage) {
        if (!originalTitle) {
            originalTitle = document.title;
        }

        if (!originalFavicon || !currentFavicon) {
            var tag = getFaviconTag();
            originalFavicon = currentFavicon = tag ? tag.getAttribute('href') : '/favicon.ico';
        }

        if (!isNaN(parseFloat(percentage)) && isFinite(percentage)) {
            if (!getCanvas().getContext || browser.ie || browser.safari || options.fallback === true) {
                // Fallback to updating the browser title if unsupported
                return updateTitle(percentage);
            } else if (options.fallback === 'force') {
                updateTitle(percentage);
            }

            return drawFavicon(percentage);
        }

        return false;
    };

    Piecon.reset = function() {
        if (originalTitle) {
            document.title = originalTitle;
        }

        if (originalFavicon) {
            currentFavicon = originalFavicon;
            setFaviconTag(currentFavicon);
        }
    };

    Piecon.setFavicon = function(url)
    {
        if (!browser.ie)
        {
            setFaviconTag(url);
        }
    };

    Piecon.browserSupportsDynamicFavicon = function()
    {
        return !browser.ie && !browser.safari;
    };

    Piecon.setOptions(defaults);
}(jQuery, window.Piecon = (window.Piecon || {})));
