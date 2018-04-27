[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[#--full method notation required for getCurrentUrl() cause its a static method. Weird.--]
[@cp.displayComments result=action.resultsSummary comments=action.commentsByEntityId returnUrl=action.getCurrentUrl() showFormOnLoad=action.commentMode!false/]