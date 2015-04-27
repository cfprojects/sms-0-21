<cfparam name="url.smsfrom"		default="13033251979"/>
<cfparam name="url.smsto"		default="12345"/>
<cfparam name="url.smsdate"		default=""/>
<cfparam name="url.smsmsg"		default="this is my message"/>

<cfset variables.obj.smsService = createObject("component","com.blayter.services.smsService").init()>

<cfset variables.args					= structNew()>
<cfset variables.args.smsFrom			= url.smsFrom>
<cfset variables.args.smsTo				= url.smsTo>
<cfset variables.args.message			= url.smsmsg>
<cfset variables.args.processKeywords	= true>

<cfset variables.smsBean = variables.obj.smsService.addInbound(argumentCollection=variables.args)>

<cfoutput>
	<h1>This page accepts inbound SMS messages from the gateway</h1>
	<p><strong>ID:</strong>#variables.smsBean.getSMSId()#</p>
	<cfdump var="#variables.smsBean.dump()#">
</cfoutput>