<cfscript>
	taskId         = rc.taskId ?: "";
	task           = prc.task ?: QueryNew('');
	taskProgress   = prc.taskProgress ?: {};
	status         = taskProgress.status ?: "";
	progress       = Round( Val( taskProgress.progress ) );
	progressActive = progress < 100;
	log            = taskProgress.log;
	timeTaken      = taskProgress.timeTaken;

	canCancel    = IsTrue( prc.canCancel ?: "" );
	hasReturnUrl = Len( Trim( taskProgress.returnUrl ) );
	hasResultUrl = Len( Trim( taskProgress.resultUrl ) );
	succeeded    = status == "succeeded";
	isRunning    = status == "running";
	resultDisabled = !hasResultUrl || !succeeded;

	if ( canCancel ) {
		cancelAction = event.buildAdminLink( linkto="adhocTaskManager.cancelTaskAction", querystring="taskId=" & taskId );
		cancelPrompt = HtmlEditFormat( translateResource( "cms:adhoctaskmanager.progress.cancel.task.prompt" ) );
	}

	progressClass = "danger";
	switch( status ) {
		case "running":
		case "succeeded":
			progressClass = "success";
	}

	event.include( "/css/admin/specific/taskmanager/" );
	if ( isRunning ) {
		event.include( "/js/admin/specific/adhoctaskprogress/" );
		event.includeData({ adhocTaskStatusUpdateUrl=event.buildAdminLink( linkto="adhocTaskManager.status", queryString="taskId=#taskId#" ) } );
	}
</cfscript>
<cfoutput>
	<div id="ad-hoc-task-progress-container">
		<div class="progress progress-striped pos-rel<cfif progressActive> active</cfif>" data-percent="#progress#%">
			<div class="progress-bar progress-bar-#progressClass#" style="width:#progress#%;"></div>
		</div>
		<div class="task-log">
			<pre id="taskmanager-log">#log#</pre>
		</div>
		<div class="clearfix">
			<div class="pull-right log-actions">
				<span class="time-taken <cfif succeeded>complete green<cfelseif isRunning>running blue<cfelse>red</cfif>">
					<i class="fa fa-fw fa-clock-o"></i>

					<span class="time-taken">#translateResource( "cms:taskamanager.log.timetaken" )#</span>
					<span class="running-for">#translateResource( "cms:taskamanager.log.runningfor" )#</span>

					<span class="time" id="task-log-timetaken">#timeTaken#</span>
				</span>
			</div>
		</div>

		<div class="form-actions row">
			<cfif hasReturnUrl>
				<a href="#task.return_url#" class="btn btn-default">
					<i class="fa fa-reply bigger-110"></i>
					#translateResource( "cms:adhoctaskmanager.progress.return.btn" )#
				</a>
			</cfif>
			<cfif canCancel>
				<a href="#cancelAction#" class="btn btn-danger confirmation-prompt" title="#cancelPrompt#" id="task-cancel-button">
					<i class="fa fa-ban bigger-110"></i>
					#translateResource( "cms:adhoctaskmanager.progress.cancel.task.btn" )#
				</a>
			</cfif>

			<a href="#task.result_url#" class="btn btn-info<cfif resultDisabled> btn-disabled</cfif>"<cfif resultDisabled> disabled</cfif> id="view-result-button">
				<i class="fa fa-check bigger-110">
					#translateResource( "cms:adhoctaskmanager.progress.view.result.btn" )#
				</i>
			</a>
		</div>
	</div>
</cfoutput>