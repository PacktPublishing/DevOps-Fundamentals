<div id="${parameters.containerId}"></div>
<script type="text/javascript">
    require(['jquery', 'feature/branch-label'], function($, BranchLabel){
        return new BranchLabel({
            el: $('#${parameters.containerId}')
        });
    });
</script>