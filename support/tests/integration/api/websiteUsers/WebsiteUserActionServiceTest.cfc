component extends="resources.HelperObjects.PresideBddTestCase" {

	function run() {
		describe( "recordAction()", function(){
			it( "should save the action to the database, serializing the detail to json", function(){
				var service    = _getService();
				var dbId       = CreateUUId();
				var userId     = CreateUUId();
				var action     = "logout";
				var type       = "login";
				var identifier = CreateUUId();
				var detail     = { test=CreateUUId() };
				var sessionId  = CreateUUId();

				mockActionDao.$( "insertData" ).$args( {
					  user       = userId
					, action     = action
					, type       = type
					, detail     = SerializeJson( detail )
					, uri        = cgi.request_url
					, user_ip    = cgi.remote_addr
					, user_agent = cgi.http_user_agent
					, session_id = sessionId
					, identifier = identifier
				} ).$results( dbId );

				service.$( "_getSessionId", sessionId )

				var actionId = service.recordAction(
					  userId     = userId
					, action     = action
					, type       = type
					, detail     = detail
					, identifier = identifier
				);

				expect( actionId ).toBe( dbId );
			} );

			it( "should record visitor ID instead of user ID when user ID is not supplied", function(){
				var service    = _getService();
				var dbId       = CreateUUId();
				var visitorId  = CreateUUId();
				var action     = "logout";
				var type       = "login";
				var identifier = CreateUUId();
				var detail     = { test=CreateUUId() };
				var sessionId  = CreateUUId();

				mockVisitorService.$( "getVisitorId", visitorId );
				mockActionDao.$( "insertData" ).$args( {
					  visitor    = visitorId
					, action     = action
					, type       = type
					, detail     = SerializeJson( detail )
					, uri        = cgi.request_url
					, user_ip    = cgi.remote_addr
					, user_agent = cgi.http_user_agent
					, session_id = sessionId
					, identifier = identifier
				} ).$results( dbId );

				service.$( "_getSessionId", sessionId )

				var actionId = service.recordAction(
					  action     = action
					, type       = type
					, detail     = detail
					, identifier = identifier
				);

				expect( actionId ).toBe( dbId );
			} );
		} );

		describe( "promoteVisitorActionsToUserActions()", function(){
			it( "should update action records that match the given sessionId and visitor, changing them to using the supplied user ID", function(){
				var service        = _getService();
				var sessionId      = CreateUUId();
				var visitorId      = CreateUUId();
				var userId         = CreateUUId();
				var recordsUpdated = Round( Rand() * 1000 );

				service.$( "_getSessionId", sessionId );
				mockVisitorService.$( "getVisitorId", visitorId );
				mockActionDao.$( "updateData" ).$args(
					  filter = { "website_user_action.session_id" = sessionId, "website_user_action.visitor" = visitorId }
					, data   = { visitor = "", user = userId }
				).$results( recordsUpdated );

				expect( service.promoteVisitorActionsToUserActions( userId = userId ) ).toBe( recordsUpdated );
			} );
		} );
	}

// PRIVATE HELPERS
	private any function _getService() {
		mockVisitorService = createEmptyMock( "preside.system.services.websiteUsers.WebsiteVisitorService" );
		mockSessionStorage = createStub();
		configuredActions = {
			  login = [ "test", "this", "stuff" ]
			, test  = [ "this", "stuff" ]
		}

		var service = createMock( object=new preside.system.services.websiteUsers.WebsiteUserActionService(
			  configuredActions     = configuredActions
			, websiteVisitorService = mockVisitorService
			, sessionStorage        = mockSessionStorage
		) );

		mockActionDao = CreateStub();

		service.$( "$getPresideObject" ).$args( "website_user_action" ).$results( mockActionDao );

		return service;
	}
}