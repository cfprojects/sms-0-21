<cfif isDefined("form.fieldNames")>
	<cfset variables.obj.smsService = createObject("component","com.blayter.services.smsService").init()>

	<cfset variables.args					= structNew()>
	<cfset variables.args.smsTo				= form.phone>
	<cfset variables.args.smsFrom			= 83960>
	<cfset variables.args.message			= form.msg>
	<cfset variables.smsBean = variables.obj.smsService.outgoingSMS(argumentCollection=variables.args)>
	
	<cfoutput>
		<p><strong>ID:</strong>#variables.smsBean.getSMSId()#</p>
		<cfdump var="#variables.smsBean.dump()#">
	
	
		<cfdump var="#request#">
	
	</cfoutput>
	
	
</cfif>

<h1>This is a general outgoing SMS form</h1>

<cfoutput>
	<form action="#cgi.script_name#" method="post">
		<fieldset>
			<legend>User 1</legend>
			Phone:
			<input type="text" name="phone"/><br/>
			Message
			<input type="text" name="msg" maxlength="160"/><br/>
			<input type="submit" value="Send"/>
		</fieldset>
		
	</form>
</cfoutput>