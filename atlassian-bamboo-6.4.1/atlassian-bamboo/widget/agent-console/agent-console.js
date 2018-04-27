define('widget/agent-console', [
    'jquery',
    'underscore',
    'backbone',
    'brace'
], function(
    $,
    _,
    Backbone,
    Brace
) {

    'use strict';

    var AgentConsole = (function($) {
        var ConsoleSectionModel = Brace.Model.extend({
            namedAttributes: ['type', 'text'],
            slice: function(val) {
                this.setText(this.getText().split('\n').slice(val).join('\n'));
            },
            countLines: function() {
                return (this.getText().match(/\n/g) || []).length + 1;
            }
        });

        var ShellSessionModel = Backbone.Collection.extend({
            model: ConsoleSectionModel,
            MAX_LINES: 500,
            currentLines: 0,
            initialize: function() {
                _.bindAll(this, 'addConsoleText');

                this.sessionId = Math.random().toString().substring(2);

                var eventSource = new EventSource(AJS.contextPath()
                    + '/server-sent-events?sessionId=' + this.sessionId);

                var onEvent =
                        function onEvent(e) {
                            this.addConsoleText(e.type, e.data);
                        }.bind(this);

                eventSource.addEventListener('STDOUT', onEvent, false);
                eventSource.addEventListener('STDERR', onEvent, false);
            },
            trimLines: function() {
                var hasTrimHappened = this.currentLines > this.MAX_LINES;

                while (this.currentLines > this.MAX_LINES) {
                    var
                            linesInSection = this.at(0).countLines(),
                            linesToRemoveFromSection = this.currentLines - this.MAX_LINES;

                    if (linesToRemoveFromSection >= linesInSection)
                    {
                        this.shift({silent: true});
                        this.currentLines -= linesInSection;
                    }
                    else
                    {
                        this.at(0).slice(linesToRemoveFromSection);
                        this.currentLines -= linesToRemoveFromSection;
                    }
                }

                return hasTrimHappened;
            },
            addConsoleText: function(type, text) {
                var section = new ConsoleSectionModel({type: type, text: $('<div/>').text(text).html()});

                this.add(section, {silent: true});
                this.currentLines += section.countLines();

                this.trimLines() ? this.trigger('reset', this) : this.trigger('add', section);
            }
        });

        var InputLineModel = Brace.Model.extend({
            namedAttributes: ['text', 'agentId', 'sessionId', 'permissionPlanKey'],
            initialize: function() {
                _.bindAll(this, 'submit');
            },
            submit: function() {
                var params = {
                    command: this.getText(),
                    sessionId: this.getSessionId(),
                    agentId: this.getAgentId(),
                    planKey: this.getPermissionPlanKey()
                };

                $.post(AJS.contextPath() + '/agent/agentConsole!sendCommand.action', params)
                        .done($.proxy(function() {
                            this.setText('');
                            this.trigger('request', params.command);
                        }, this));
            }
        });

        var InputLineView = Backbone.View.extend({
            events: {
                'keydown textarea': 'onKeydown'
            },
            initialize: function(options) {
                _.bindAll(this, 'render', 'onKeydown');

                this.shellSessionModel = options.shellSessionModel;
                this.inputLineModel = new InputLineModel({
                    agentId: options.agentId,
                    sessionId: options.shellSessionModel.sessionId,
                    permissionPlanKey: options.permissionPlanKey
                });
                this.inputLineModel.on('request', this.render);
                this.inputLineModel.bind('request', function(command) {
                    this.shellSessionModel.addConsoleText('STDIN',  '# ' + command);
                }, this);

                this.$inputLine = $('<textarea/>', {class: 'terminal', rows: '2', autofocus: 'autofocus'});
                options.el.append(this.$inputLine);
            },
            onKeydown: function(e) {
                if (e.which !== jQuery.ui.keyCode.ENTER) {
                    return;
                }
                e.preventDefault();
                this.inputLineModel.setText($(e.target).val());
                this.inputLineModel.submit();
            },
            render: function() {
                this.$inputLine.val(this.inputLineModel.getText());
            }
        });

        var ShellSessionView = Backbone.View.extend({
            initialize: function(options) {
                _.bindAll(this, 'render', 'appendSection');

                this.$console = $('<div/>', {id: 'console', class: 'terminal terminal-window'});

                options.el
                        .append(this.$console);

                this.shellSessionModel = new ShellSessionModel();
                this.shellSessionModel.on('add', this.appendSection);
                this.shellSessionModel.on('reset', this.render);

                this.inputLineView = new InputLineView({
                    el: options.el,
                    agentId: options.agentId,
                    shellSessionModel: this.shellSessionModel,
                    permissionPlanKey: options.permissionPlanKey
                });
            },

            render: function() {
                var
                        mergedSections = null;

                this.$console.html('');
                this.shellSessionModel.models.each(function(sectionModel) {
                    if (mergedSections === null) {
                        mergedSections = sectionModel.clone();
                    } else {
                        if (sectionModel.getType() === mergedSections.getType()) {
                            mergedSections.setText(mergedSections.getText() + '\n' + sectionModel.getText());
                        } else {
                            this.appendSection(mergedSections);
                            mergedSections = sectionModel.clone();
                        }
                    }
                }, this);
                if (mergedSections !== null) {
                    this.appendSection(mergedSections);
                }
            },

            appendSection: function(sectionModel) {
                this.$console.append(sectionModel.getText() + '\n');
                this.$console.scrollTop(this.$console[0].scrollHeight - this.$console.height());
            }
        });

        return ShellSessionView;
    }($));

    return AgentConsole;
});
