<#if parameters.tooltip??><#t/>
      <img 
      <#if parameters.tooltipIcon??><#t/>
      	src='<@ww.url value="${parameters.tooltipIcon}" />' 
      <#else><#t/>
      	src='<@ww.url value="/webwork/tooltip/tooltip.gif" />'
      </#if><#t/>
      	alt="${parameters.tooltip?html}" 
      	title="${parameters.tooltip?html}" 
      	onmouseover="<#rt/>
      <#if parameters.tooltipAboveMousePointer??><#t/>
    	<#t/>this.T_ABOVE=${parameters.tooltipAboveMousePointer};<#t/>
      </#if><#t/>
      <#if parameters.tooltipBgColor??><#t/>
        <#t/>this.T_BGCOLOR='${parameters.tooltipBgColor}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipBgImg??><#t/>
        <#t/>this.T_BGIMG='<@ww.url value="${parameters.tooltipBgImg}" />';<#t/>
      </#if><#t/>
      <#if parameters.tooltipBorderWidth??><#t/>
        <#t/>this.T_BORDERWIDTH=${parameters.tooltipBorderWidth};<#t/>
      </#if><#t/>
      <#if parameters.tooltipBorderColor??><#t/>
        <#t/>this.T_BORDERCOLOR='${parameters.tooltipBorderColor}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipDelay??><#t/>
      	<#t/>this.T_DELAY=${parameters.tooltipDelay};<#t/>
      </#if><#t/>
      <#if parameters.tooltipFixCoordinateX?? && parameters.tooltipFixCoordinateY??><#t/>
      	<#t/>this.T_FIX=[${parameters.tooltipFixCoordinateX}, ${parameters.tooltipFixCoordinateY}];<#t/>
      </#if><#t/>
      <#if parameters.tooltipFontColor??><#t/>
      	<#t/>this.T_FONTCOLOR='${parameters.tooltipFontColor}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipFontFace??><#t/>
        <#t/>this.T_FONTFACE='${parameters.tooltipFontFace}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipFontSize??><#t/>
      	<#t/>this.T_FONTSIZE='${parameters.tooltipFontSize}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipFontWeight??><#t/>
      	<#t/>this.T_FONTWEIGHT='${parameters.tooltipFontWeight}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipLeftOfMousePointer??><#t/><#t/>
      	<#t/>this.T_LEFT=${parameters.tooltipLeftOfMousePointer};<#t/>
      </#if><#t/>
      <#if parameters.tooltipOffsetX??><#t/>
      	<#t/>this.T_OFFSETX=${parameters.tooltipOffsetX};<#t/>
      </#if><#t/>
      <#if parameters.tooltipOffsetY??><#t/>
      	<#t/>this.T_OFFSETY=${parameters.tooltipOffsetY};<#t/>
      </#if><#t/>
      <#if parameters.tooltipOpacity??><#t/>
      	<#t/>this.T_OPACITY=${parameters.tooltipOpacity};<#t/>
      </#if><#t/>
      <#if parameters.tooltipPadding??><#t/>
      	<#t/>this.T_PADDING=${parameters.tooltipPadding};<#t/>
      </#if><#t/>
      <#if parameters.tooltipShadowColor??><#t/>
      	<#t/>this.T_SHADOWCOLOR='${parameters.tooltipShadowColor}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipShadowWidth??><#t/>
      	<#t/>this.T_SHADOWWIDTH=${parameters.tooltipShadowWidth};<#t/>
      </#if><#t/>
      <#if parameters.tooltipStatic??><#t/>
        <#t/>this.T_STATIC=${parameters.tooltipStatic};<#t/>
      </#if><#t/>
      <#if parameters.tooltipSticky??>
      	<#t/>this.T_STICKY=${parameters.tooltipSticky};<#t/>
      </#if><#t/>
      <#if parameters.tooltipStayAppearTime??><#t/>
      	<#t/>this.T_TEMP=${parameters.tooltipStayAppearTime};<#t/>
      </#if><#t/>
      <#if parameters.tooltipTextAlign??><#t/>
      	<#t/>this.T_TEXTALIGN='${parameters.tooltipTextAlign}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipTitle??><#t/>
      	<#t/>this.T_TITLE='${parameters.tooltipTitle?js_string}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipTitleColor??><#t/>
        <#t/>this.T_TITLECOLOR='${parameters.tooltipTitleColor}';<#t/>
      </#if><#t/>
      <#if parameters.tooltipWidth??><#t/>
      	<#t/>this.T_WIDTH=${parameters.tooltipWidth};<#t/>
      </#if><#t/>
      	<#t/>return escape('${parameters.tooltip?js_string}');" />
</#if><#t/>
