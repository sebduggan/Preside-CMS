<cfparam name="args.body" default="" />
<cfparam name="args.tab"  default="preview" />

<cfscript>
	templateId = rc.template ?: "";
	tabs       = [];

	tabs.append({
		  id     = "preview"
		, icon   = "fa-eye blue"
		, title  = translateResource( "cms:emailcenter.systemTemplates.template.tab.preview" )
		, active = ( args.tab == "preview" )
		, link   = ( args.tab == "preview" ) ? "" : event.buildAdminLink( linkTo="emailcenter.systemTemplates.template", queryString="template=" & templateId )
	});
	tabs.append({
		  id     = "edit"
		, icon   = "fa-pencil green"
		, title  = translateResource( "cms:emailcenter.systemTemplates.template.tab.edit" )
		, active = ( args.tab == "edit" )
		, link   = ( args.tab == "edit" ) ? "" : event.buildAdminLink( linkTo="emailcenter.systemTemplates.edit", queryString="template=" & templateId )
	});
	tabs.append({
		  id     = "layout"
		, icon   = "fa-cogs grey"
		, title  = translateResource( "cms:emailcenter.systemTemplates.template.tab.layout" )
		, active = ( args.tab == "layout" )
		, link   = ( args.tab == "layout" ) ? "" : event.buildAdminLink( linkTo="emailcenter.systemTemplates.configurelayout", queryString="template=" & templateId )
	});
</cfscript>

<cfoutput>
	<div class="tabbable">
		<ul class="nav nav-tabs">
			<cfloop array="#tabs#" index="i" item="tab">
				<li <cfif tab.active>class="active"</cfif>>
					<a href="#tab.link#">
						<i class="fa fa-fw #tab.icon#"></i>&nbsp;
						#tab.title#
					</a>
				</li>
			</cfloop>
		</ul>
		<div class="tab-content">
			<div class="tab-pane active">#args.body#</div>
		</div>
	</div>
</cfoutput>