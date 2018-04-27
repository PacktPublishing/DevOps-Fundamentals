define('model', [
    'jquery',
    'underscore',
    'brace',
    'exports'
], function(
    $,
    _,
    Brace,
    exports
) {

    'use strict';

    var Key = Brace.Model.extend({
        namedAttributes: {
            key: 'string'
        }
    });

    var ResultKey = Brace.Model.extend({
        namedAttributes: {
            key: 'string',
            entityKey: Key,
            resultNumber: 'number'
        }
    });

    var LogEntry = Brace.Model.extend({
        namedAttributes: {
           log: 'string',
           unstyledLog: 'string',
           date: Date,
           formattedDate: 'string'
        }
    });

    var Artifact = Brace.Model.extend({
        namedAttributes: {
            id: 'number',
            label: 'string',
            size: 'number',
            isSharedArtifact: 'boolean',
            isGloballyStored: 'boolean',
            linkType: 'string',
            planResultKey: ResultKey,
            archiverType: 'string'
        }
    });

    var Agent = Brace.Model.extend({
        namedAttributes: {
            name: 'string',
            type: 'string',
            active: 'boolean',
            enabled: 'boolean',
            busy: 'boolean'
        }
    });

    var Operations = Brace.Model.extend({
        namedAttributes: {
            canView: 'boolean',
            canEdit: 'boolean',
            canDelete: 'boolean',
            allowedToExecute: 'boolean',
            canExecute: 'boolean',
            cantExecuteReason: 'string',
            allowedToCreateVersion: 'boolean',
            allowedToSetVersionStatus: 'boolean'
        }
    });

    var DeploymentVersionStatus = Brace.Model.extend({
        namesAttributes: {
            versionState: 'string',
            userName: 'string',
            displayName: 'string',
            gravatarUrl: 'string',
            creationDate: 'date'
        }
    });

    var DeploymentVersionItem = Brace.Model.extend({
        namedAttributes: {
            name: 'string',
            planResultKey: ResultKey,
            type: 'string',
            label: 'string',
            location: 'string',
            copyPattern: 'string',
            size: 'number',
            artifact: Artifact
        }
    });

    var DeploymentVersionVariableContext = Brace.Model.extend({
        namedAttributes: {
            key: 'string',
            value: 'string',
            variableType: 'string',
            isPassword: 'boolean'
        }
    });

    var DeploymentVersion = Brace.Model.extend({
        namedAttributes: {
            name: 'string',
            planBranchName: 'string',
            creationDate: Date,
            creatorUserName: 'string',
            creatorGravatarUrl: 'string',
            creatorDisplayName: 'string',
            planResultKey: ResultKey,
            items: Brace.Collection.extend({
                model: DeploymentVersionItem
            }),
            versionStatus: DeploymentVersionStatus,
            operations:  Operations,
            ageZeroPoint: Date
        }
    });

    var DeploymentResult = Brace.Model.extend({
        namedAttributes: {
            deploymentVersion: DeploymentVersion,
            deploymentVersionName: 'string',
            lifeCycleState: 'string',
            deploymentState: 'string',
            startedDate: Date,
            queuedDate: Date,
            executedDate: Date,
            finishedDate: Date,
            reasonSummary: 'string',
            key: ResultKey,
            agent: Agent,
            logEntries: Brace.Collection.extend({
                model: LogEntry
            }),
            operations: Operations
        }
    });

    var DeploymentEnvironment = Brace.Model.extend({
          namedAttributes: {
              name: 'string',
              deploymentProjectId: 'number',
              position: 'number',
              operations:  Operations
          }
    });

    var DeploymentEnvironmentStatus = Brace.Model.extend({
        namedAttributes: {
            deploymentResult: DeploymentResult,
            environment: DeploymentEnvironment
        }
    });

    var DeploymentProject = Brace.Model.extend({
        namedAttributes: {
            name: 'string',
            oid: 'string',
            key: Key,
            planKey: Key,
            description: 'string',
            environments: Brace.Collection.extend({
                model: DeploymentEnvironment
            }),
            operations: Operations
        }
    });

    var DeploymentProjectWithEnvironmentStatuses = Brace.Model.extend({
        namedAttributes: {
            deploymentProject: DeploymentProject,
            environmentStatuses: Brace.Collection.extend({
                model: DeploymentEnvironmentStatus
            })
        }
    });

    exports.Key = Key;
    exports.ResultKey = ResultKey;
    exports.Artifact = Artifact;
    exports.Agent = Agent;
    exports.LogEntry = LogEntry;
    exports.Operations = Operations;
    exports.DeploymentVersionStatus = DeploymentVersionStatus;
    exports.DeploymentVersionItem = DeploymentVersionItem;
    exports.DeploymentVersionVariableContext = DeploymentVersionVariableContext;
    exports.DeploymentVersion = DeploymentVersion;
    exports.DeploymentResult = DeploymentResult;
    exports.DeploymentEnvironment = DeploymentEnvironment;
    exports.DeploymentEnvironmentStatus = DeploymentEnvironmentStatus;
    exports.DeploymentProject = DeploymentProject;
    exports.DeploymentProjectWithEnvironmentStatuses = DeploymentProjectWithEnvironmentStatuses;

});


