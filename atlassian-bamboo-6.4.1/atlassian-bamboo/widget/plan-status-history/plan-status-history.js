define('widget/plan-status-history', [
    'jquery',
    'underscore',
    'backbone',
    'widget/result-summary',
    'widget/result-summaries',
    'widget/page-visibility-manager'
], function(
    $,
    _,
    Backbone,
    ResultSummary,
    ResultSummaries,
    pageVisibilityManager
) {

    'use strict';

    var MAX_WINDOW_SIZE = 10; // synchronised with PlanStatusHistoryAction#MAX_RESULTS
    var SCROLL_BEFORE = "before";
    var SCROLL_AFTER = "after";

    var PlanStatusHistory = Backbone.View.extend({
        id: 'plan-status-history',
        events: {
            "click a.previous": "clickPreviousButton",
            "click a.next": "clickNextButton"
        },
        getShowRightArrow: function() {
            if (this.collection.length == 0) {
                return null;
            }
            return this.maxVisibleBuildNumber && this.maxVisibleBuildNumber < this._lastBuildNumber;
        },
        initialize: function(options) {
            _.extend(this, options || (options = {}));
            this.buildNumber = options.buildNumber;
            this.returnUrl = options.returnUrl || '';
            this.keyToNavigate = options.keyToNavigate;
            this._firstBuildNumber = options.firstBuildNumber;
            this._lastBuildNumber = options.lastBuildNumber;
            this._updateTimeoutSuccess = options.updateTimeoutSuccess || 15000;
            this._updateTimeoutFailure = options.updateTimeoutFailure || 20000;
            this.collection = new ResultSummaries(options.bootstrap || [], {
                planKey: options.planKey
            });
            this.minVisibleBuildNumber = this.collection.getMinimumBuildNumber();
            this.maxVisibleBuildNumber = this.collection.getMaximumBuildNumber();
            this.showRightArrow = this.getShowRightArrow();
            $(document).on('statechange.historyxhr', _.bind(this.updateReturnUrls, this));

            this._inlineDialog = AJS.InlineDialog(
                '#' + this.$el.attr('id') + ' li > *',
                'plan-status-history-info',
                _.bind(this.showInlineDialog, this),
                {
                    onHover: true,
                    fadeTime: 50,
                    hideDelay: 50,
                    showDelay: 0,
                    useLiveEvents: true
                }
            );

            this.render();

            pageVisibilityManager.setUp(
                this.scheduleNextUpdate.bind(this),
                this.cancelNextUpdate.bind(this)
            );
        },
        render: function(scrollDirection) {
            if (!scrollDirection) {
                this._renderBuilds();
            } else {
                this._renderBuildsWithAnimation(scrollDirection);
            }
            return this;
        },
        _showSpinner: function(buttonClass) {
            var id = this.$el.attr('id');
            var $spinner = $('#' + id + ' .spinner' + buttonClass);
            var $button = $('#' + id + ' .button' + buttonClass);
            $button.hide();
            $spinner.show();
        },
        _hideSpinner: function(buttonClass) {
            var id = this.$el.attr('id');
            var $spinner = $('#' + id + ' .spinner' + buttonClass);
            var $button = $('#' + id + ' .button' + buttonClass);
            $spinner.hide();
            $button.show();
        },
        _renderBuilds: function () {
            this.$el.html(bamboo.widget.planStatusHistory.navigator({
                builds: this.getBuildsToRender(),
                currentBuildNumber: this.buildNumber,
                firstBuildNumber: this._firstBuildNumber,
                minVisibleBuildNumber: this.minVisibleBuildNumber,
                maxVisibleBuildNumber: this.maxVisibleBuildNumber,
                showRightArrow: this.getShowRightArrow(),
                keyToNavigate: this.keyToNavigate,
                returnUrl: this.returnUrl
            }));
        },
        _renderBuildsWithAnimation: function (scrollDirection) {
            var $firstLi = this.$el.find('li.animated:first');
            var buildElementWidth = $firstLi.width();
            var translateX = "0";

            if (scrollDirection == SCROLL_BEFORE) {
                translateX = "translateX(" + buildElementWidth + "px)";
            } else if (scrollDirection == SCROLL_AFTER) {
                translateX = "translateX(-" + buildElementWidth + "px)";
            }

            this.$el.find("li.animated").css({
                "transform": translateX,
                "-moz-transform": translateX,
                "-webkit-transform": translateX,
                "-ms-transform": translateX
            });

            _.delay(_.bind(this._renderBuilds, this), 250); // delay must be matched with transition duration in CSS
        },
        getBuildsToRender: function() {
            var buildsToRender = this.collection.toJSON();
            var minVisibleBuildNumber = this.minVisibleBuildNumber;
            var maxVisibleBuildNumber = this.maxVisibleBuildNumber;
            buildsToRender = _.filter(buildsToRender, function(build) {
                return (build.buildNumber >= minVisibleBuildNumber &&  build.buildNumber <= maxVisibleBuildNumber);
            });
            return buildsToRender;
        },
        update: function(options) {
            var data = {};
            options = options || {};
            if (options.buildNumber) {
                data.buildNumber = options.buildNumber;
            } else if (this.buildNumber) {
                data.buildNumber = this.buildNumber;
            }
            if (options.scanDirection) {
                data.scanDirection = options.scanDirection;
            }

            return this.collection.fetch({
                cache: false,
                dataType: 'json',
                data: data,
                remove: false
            })
                    .done(_.bind(this.updateBuildNumberDetails, this))
                    .done(_.bind(this.render, this, options.scanDirection))
                    .always(_.bind(this.recordLastUpdateTime, this))
                    .always(_.bind(this.scheduleNextUpdate, this));
        },
        updateBuildNumberDetails: function() {
            var lastBuildNumber = (this.collection.length ? this.collection.last().id : null);
            if (lastBuildNumber > this._lastBuildNumber) {
                this._lastBuildNumber = lastBuildNumber;
            }
        },
        recordLastUpdateTime: function() {
            this._lastUpdateTime = new Date();
        },
        cancelNextUpdate: function() {
            clearTimeout(this._timeout);
        },
        scheduleNextUpdate: function(jqXHR) {
            this.cancelNextUpdate();
            if (!pageVisibilityManager.isPageVisible()) {
                return;
            }
            var delayBeforeUpdate = ((typeof jqXHR === 'undefined' || jqXHR.status == 'OK')
                ? this._updateTimeoutSuccess
                : this._updateTimeoutFailure);
            if (this._lastUpdateTime) {
                delayBeforeUpdate -= (new Date().getTime() - this._lastUpdateTime.getTime());
                if (delayBeforeUpdate < 0) {
                    delayBeforeUpdate = 0;
                }
            }
            this._timeout = setTimeout(_.bind(this.update, this), delayBeforeUpdate);
        },
        updateReturnUrls: function(event, newReturnUrl) {
            this.returnUrl = encodeURIComponent(this.cleanReturnUrl(newReturnUrl));
            this.render();
        },
        cleanReturnUrl: function(url) {
            var a = document.createElement('a');
            a.href = url;
            return (AJS.contextPath().length ? a.pathname.replace(AJS.contextPath(), '') : a.pathname) + a.search;
        },
        clickPreviousButton: function (event) {
            event.preventDefault();
            var scrollDirection = SCROLL_BEFORE;

            if (this.minVisibleBuildNumber === this._firstBuildNumber) {
                return;
            }

            this.cancelNextUpdate();

            var needsFetch = this.needsFetchOnScroll(scrollDirection);

            var oldMinVisibleBuildNumber = this.minVisibleBuildNumber;
            var oldMaxVisibleBuildNumber = this.maxVisibleBuildNumber;
            this.minVisibleBuildNumber = this.collection.getPreviousBuildNumber(oldMinVisibleBuildNumber);
            this.maxVisibleBuildNumber = this.collection.getPreviousBuildNumber(oldMaxVisibleBuildNumber);
            if (this.minVisibleBuildNumber === null) {
                this.minVisibleBuildNumber = oldMinVisibleBuildNumber - 1;
                this.maxVisibleBuildNumber = oldMaxVisibleBuildNumber - 1;
            }

            if (needsFetch) {
                this._showSpinner('.previous');
                this.update({
                    buildNumber: oldMinVisibleBuildNumber,
                    scanDirection: "before"
                }).always(_.bind(this._hideSpinner, this, '.previous'));
            } else {
                this.render(scrollDirection);
                this.scheduleNextUpdate();
            }
        },
        clickNextButton: function (event) {
            event.preventDefault();
            var scrollDirection = SCROLL_AFTER;

            if (this.maxVisibleBuildNumber === this._lastBuildNumber) {
                return;
            }

            this.cancelNextUpdate();

            var needsFetch = this.needsFetchOnScroll(scrollDirection);

            var oldMinVisibleBuildNumber = this.minVisibleBuildNumber;
            var oldMaxVisibleBuildNumber = this.maxVisibleBuildNumber;
            this.minVisibleBuildNumber = this.collection.getNextBuildNumber(oldMinVisibleBuildNumber);
            this.maxVisibleBuildNumber = this.collection.getNextBuildNumber(oldMaxVisibleBuildNumber);
            if (this.maxVisibleBuildNumber === null) {
                this.minVisibleBuildNumber = oldMinVisibleBuildNumber + 1;
                this.maxVisibleBuildNumber = oldMaxVisibleBuildNumber + 1;
            }

            if (needsFetch) {
                this._showSpinner('.next');
                this.update({
                    buildNumber: oldMaxVisibleBuildNumber,
                    scanDirection: "after"
                }).always(_.bind(this._hideSpinner, this, '.next'));
            } else {
                this.render(scrollDirection);
                this.scheduleNextUpdate();
            }
        },
        needsFetchOnScroll: function(scrollDirection) {
            // do we have enough data to render straight away?
            if (scrollDirection === SCROLL_BEFORE) {
                // if our minimum visible build is not first or second in the collection, then yes.
                return (this.collection.getIndexOfBuildNumber(this.minVisibleBuildNumber) < 2);
            } else {
                // if our maximum visible build is not last or second last in the collection, then yes.
                var boundary = this.collection.length - 2;
                return (this.collection.getIndexOfBuildNumber(this.maxVisibleBuildNumber) >= boundary);
            }
        },
        showInlineDialog: function(contents, trigger, doShowPopup) {
            var $li = $(trigger).parent(),
                buildNumber = $li.data('buildNumber'),
                buildModel = this.collection.get(buildNumber),
                attributes = _.clone(buildModel.attributes);

            var hasFailed = attributes.buildStatus === 'Failed',
                existingFailuresText = null,
                newFailuresText = null;

            if (hasFailed) {
                var existingFailures = attributes.existingFailedTestCaseCount,
                    newFailures = attributes.newFailedTestCaseCount;
                if (existingFailures > 0) {
                    existingFailuresText = AJS.I18n.getText('buildResult.tests.dialog.existingFailedCount', existingFailures)
                }
                if (newFailures > 0) {
                    newFailuresText = AJS.I18n.getText('buildResult.tests.dialog.newFailedCount', newFailures)
                }
            }

            _.extend(attributes, {
                hasFailed: hasFailed,
                existingFailuresText: existingFailuresText,
                newFailuresText: newFailuresText,
                triggerHtml: attributes.trigger
            });

            if (this._inlineDialog.data('buildNumber') != buildNumber) {
                contents.html(bamboo.widget.planStatusHistory.buildDialog(attributes));
                this._inlineDialog.refresh();
                this._inlineDialog.data('buildNumber', buildNumber);
            }
            
            doShowPopup();
        }
    });

    return PlanStatusHistory;
});
