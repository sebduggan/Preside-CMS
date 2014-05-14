component output=false {

	property name="presideObjectService" inject="presideObjectService";
	property name="dataManagerService" inject="dataManagerService";

	public string function index( event, rc, prc, viewletArgs={} ) output=false {
		var targetObject = viewletArgs.object ?: "";
		var ajax         = viewletArgs.ajax   ?: true;

		if ( IsBoolean( ajax ) && ajax ) {
			if ( not StructKeyExists( viewletArgs, "prefetchUrl" ) ) {
				var prefetchCacheBuster = dataManagerService.getPrefetchCachebusterForAjaxSelect( targetObject );

				viewletArgs.prefetchUrl = event.buildAdminLink( linkTo="datamanager.getObjectRecordsForAjaxSelectControl", querystring="object=#targetObject#&prefetchCacheBuster=#prefetchCacheBuster#" );
			}
			viewletArgs.remoteUrl = viewletArgs.remoteUrl ?: event.buildAdminLink( linkTo="datamanager.getObjectRecordsForAjaxSelectControl", querystring="object=#targetObject#&q=%QUERY" );
		} else {
			viewletArgs.records = presideObjectService.selectData(
				  objectName   = targetObject
				, selectFields = [ "id", "label" ]
				, orderBy      = "label"
		 	);
		}

		if ( !Len( Trim( viewletArgs.placeholder ?: "" ) ) ) {
			viewletArgs.placeholder = translateResource(
				  uri  = "cms:datamanager.search.data.placeholder"
				, data = [ translateResource( uri=presideObjectService.getResourceBundleUriRoot( targetObject ) & "title", defaultValue=translateResource( "cms:datamanager.records" ) ) ]
			);
		}

		return renderView( view="formcontrols/objectPicker/index", args=viewletArgs );
	}
}