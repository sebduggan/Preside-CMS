<cfscript>
	detailMessages = args.detailMessages ?: [];
	customMessage  = args.customMessage  ?: "";
</cfscript>

<cfoutput>
	<cfif !isEmpty( detailMessages ) || !isEmptyString( customMessage )>
		<div class="password-policy-message">
	</cfif>

		<cfif !isEmpty( detailMessages )>
			<h4>#translateResource( "cms:passwordpolicy.title" )#</h4>

			<ul>
				<cfloop array="#detailMessages#" item="message">
					<li>#ucFirst( message )#</li>
				</cfloop>
			</ul>
		</cfif>

		<cfif !isEmptyString( customMessage )>
			#renderContent( "richeditor", customMessage )#
		</cfif>

	<cfif !isEmpty( detailMessages ) || !isEmptyString( customMessage )>
		</div>
	</cfif>
</cfoutput>