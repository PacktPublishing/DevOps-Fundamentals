[#--
    objectName if defined it will be used in page source headed - worst case

    project and immutablePlan must be defined to display bread crumb for plan
        otherwise
    deploymentProject must be defined to display bread crumb for deployment project
        otherwise header will be displayed at all
--]

[#import "/lib/ace.ftl" as ace ]

<head>
    [@ui.header pageKey='specs.config.export.view.header' object='${objectName!""}' title=true /]
    <meta name="tab" content="export"/>

</head>

[#-- ace auto resize function is not "pixel perfect", sometimes scroll will appear but we don't need it
     "overflow: hidden" prevents it
 --]
<body style="overflow: hidden;">
    [@ace.textarea name="exportItem" resizable=false isReadonly=true mode="ace/mode/java" growVertical=true /]
</body>

