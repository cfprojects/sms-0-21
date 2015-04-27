<cfif isDefined("form.fieldNames")>
	<cfset variables.obj.smsService = createObject("component","com.blayter.services.smsService").init()>

	<cfset variables.args					= structNew()>
	<cfset variables.args.smsFrom			= form.phone>
	<cfset variables.args.smsTo				= 83960>
	<cfset variables.args.message			= form.vote>
	<cfset variables.args.processKeywords	= true>
	
	<cfset variables.smsBean = variables.obj.smsService.addInbound(argumentCollection=variables.args)>
	
	<cfoutput>
		<p><strong>ID:</strong>#variables.smsBean.getSMSId()#</p>
		<cfdump var="#variables.smsBean.dump()#">
	</cfoutput>
	
</cfif>

<h1>This is the sample page of a 2 way SMS</h1>

<cfoutput>
	<form action="#cgi.script_name#" method="post">
		<fieldset>
			<legend>User 1</legend>
			Phone:
			<input type="text" name="phone"/><br/>
			<input type="radio" value="vote 1" name="vote"/>John
			<input type="radio" value="vote 2" name="vote"/>Joe
			<input type="radio" value="vote 3" name="vote"/>Jane
			<br/>
			<input type="submit" value="Send"/>
		</fieldset>
	</form>
</cfoutput>