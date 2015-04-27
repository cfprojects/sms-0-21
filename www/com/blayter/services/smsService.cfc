<cfcomponent displayname="smsService" extends="com.blayter.services.smsSettingsService" output="false">
	
	
	<!----------------------------------------------------------------------------->
	<!--- global variables to the CFC --->
	<cfscript>
	cfc.smsDAO			= createObject("component","com.blayter.dao.smsDAO").init();
	cfc.smsGateway		= createObject("component","com.blayter.gateways.smsGateway").init();
	</cfscript>
	<!--- global variables to the CFC --->
	<!----------------------------------------------------------------------------->
	
	
	<!----------------------------------------------------------------------------->
	<!--- addInbound --->
	<cffunction name="addInbound" output="false" returntype="com.blayter.beans.smsBean" hint="Adds a incoming SMS message" access="public">
		<cfargument name="smsFrom" required="true" type="numeric">
		<cfargument name="smsTo" required="true" type="numeric">
		<cfargument name="message" required="true" type="string">
		<cfargument name="processKeywords" required="false" type="boolean" default="false">
		<cfargument name="providerId" required="false" type="string" default="" hint="This is the ID that comes from the SMS gateway">
		<cfargument name="gateway" required="false" type="string" hint="the string name of the aggregator. Used for overwriting the default.">
		<cfargument name="country" required="false" type="string">
		<cfset var local = structNew()>
		<cfscript>
		// create the bean and load it up with the arguments
		local.smsBean = createObject("component","com.blayter.beans.smsBean").init();
		local.smsBean.setSMSfrom(arguments.smsFrom);
		local.smsBean.setSMSto(arguments.smsTo);
		local.smsBean.setMessage(arguments.message);
		local.smsBean.setSMStype("sms_in");
		local.smsBean.setProviderId(arguments.providerId);
		if(structKeyExists(arguments,"gateway")){
			local.smsBean.setGateway(arguments.gateway);
		}
		if(structKeyExists(arguments,"country")){
			local.smsBean.setCountry(arguments.country);
		}
		// save the SMS
		cfc.smsDAO.create(local.smsBean);
		// process the keywords
		if(arguments.processKeywords IS true){
			keywordProcess(local.smsBean);
			cfc.smsDAO.update(local.smsBean);
			}
		</cfscript>
		<cfreturn local.smsBean>
	</cffunction>
	<!--- addInbound --->
	<!----------------------------------------------------------------------------->
	
	
	<!----------------------------------------------------------------------------->
	<!--- outgoingSMS --->
	<cffunction name="outgoingSMS" output="false" returntype="com.blayter.beans.smsBean" hint="Adds an outgoing SMS message" access="public">
		
		<cfargument name="smsFrom" required="false" type="numeric">
		<cfargument name="smsTo" required="false" type="numeric">
		<cfargument name="message" required="false" type="string">
		<cfargument name="providerId" required="false" type="string" default="" hint="This is the ID that comes from the SMS gateway">
		<cfargument name="gateway" required="false" type="string" hint="the string name of the aggregator. Used for overwriting the default.">
		<cfargument name="country" required="false" type="string">
		<cfargument name="smsBean" required="false" type="com.blayter.beans.smsBean">
		
		<cfset var local = structNew()>
		<cfif structKeyExists(arguments,"smsBean")>
			<cfset local.smsBean = arguments.smsBean>
		<cfelse>
			<cfscript>
			local.smsBean = createObject("component","com.blayter.beans.smsBean").init();
			local.smsBean.setSMSfrom(arguments.smsFrom);
			local.smsBean.setSMSto(arguments.smsTo);
			local.smsBean.setMessage(arguments.message);
			local.smsBean.setSMStype("sms_out");
			if(structKeyExists(arguments,"gateway")){
				local.smsBean.setGateway(arguments.gateway);
			}
			if(structKeyExists(arguments,"country")){
				local.smsBean.setCountry(arguments.country);
			}
			// save the SMS
			cfc.smsDAO.create(local.smsBean);
			</cfscript>
		</cfif>
		<cfset cfc.smsDAO.create(local.smsBean)>
		<cfset outboundProcess(local.smsBean)>
		<cfreturn local.smsBean>
	</cffunction>
	<!--- outgoingSMS --->
	<!----------------------------------------------------------------------------->
	
	
	<!----------------------------------------------------------------------------->
	<!--- outboundProcess --->
	<cffunction name="outboundProcess" output="false" returntype="com.blayter.beans.smsBean" hint="processes an outgoing SMS message" access="private">
		<cfargument name="smsBean" required="true" type="com.blayter.beans.smsBean">
		<cfset var local = structNew()>
		<cfset local.obj.smsGateway = createObject("component","com.blayter.gateways.smsGateway").init()>
		<cfswitch expression="#arguments.smsBean.getGateway()#">
			<cfcase value="MXtelcom">
				<cfset local.smsBean = outboundMXtelcom(arguments.smsBean)>
			</cfcase>
			<cfcase value="clickAtell">
				<cfset outboundClickATell(arguments.smsBean)>
			</cfcase>
			<cfcase value="bulkSMS">
				<cfset local.smsBean = outboundBulkSMS(arguments.smsBean)>
			</cfcase>
			<cfdefaultcase>
				<cfthrow detail="You have specified a SMS gateway that is not supported">
			</cfdefaultcase>
		</cfswitch>
		
		<cfset arguments.smsBean.setThruDate(now())>
		<cfset cfc.smsDAO.update(arguments.smsBean)>
		
		<cfreturn arguments.smsBean>
	</cffunction>
	<!--- outboundProcess --->
	<!----------------------------------------------------------------------------->
	
	
	<!----------------------------------------------------------------------------->
	<!--- outboundMXtelcom --->
	<cffunction name="outboundMXtelcom" output="false" returntype="void" hint="sends the SMS out through MX Telcom" access="private">
		<cfargument name="smsBean" required="true" type="com.blayter.beans.smsBean">
		<cfset var local = structNew()>
		<cfset var cfhttp = structNew()>
		<cfscript>
		local.getURL = "http://sms.mxtelecom.com/SMSSend?";
		local.getURL = local.getURL & "user="		& cfc.mxTelcom.username;
		local.getURL = local.getURL & "&pass="		& cfc.mxTelcom.password;
		local.getURL = local.getURL & "&smsto="		& formatMobile(arguments.smsBean.getSMSto(),arguments.smsBean.getCountry());
		local.getURL = local.getURL & "&smsfrom="	& arguments.smsBean.getSMSto();
		local.getURL = local.getURL & "&smsmsg="	& arguments.smsBean.getMessage();
		</cfscript>
		<cfhttp url="#local.getURL#" method="get"></cfhttp>
	</cffunction>
	<!--- outboundMXtelcom --->
	<!----------------------------------------------------------------------------->
	
	
	<!----------------------------------------------------------------------------->
	<!--- outboundClickATell --->
	<cffunction name="outboundClickAtell" output="false" returntype="void" hint="sends the SMS out through Click A Tell" access="private">
		<cfargument name="smsBean" required="true" type="com.blayter.beans.smsBean">
		<cfset var local = structNew()>
		<cfset var cfhttp = structNew()>
		<cfhttp url="http://api.clickatell.com/http/sendmsg" method="get" resolveurl="false">
			<cfhttpparam type="FORMFIELD" name="api_id" value="#cfc.clickATell.apiId#">
			<cfhttpparam type="FORMFIELD" name="user" value="#cfc.clickATell.username#">
			<cfhttpparam type="FORMFIELD" name="password" value="#cfc.clickATell.password#">
			<cfhttpparam type="FORMFIELD" name="text" value="#arguments.smsBean.getMessage()#">
			<cfhttpparam type="FORMFIELD" name="to" value="#formatMobile(arguments.smsBean.getSMSto(),arguments.smsBean.getCountry())#">
		</cfhttp>
		<cfif findNoCase("ID:",cfhttp.fileContent)>
			<cfset local.content = cfhttp.fileContent>
			<cfset local.content = replaceNoCase(local.content,"ID: ","")>
			<cfset local.content = trim(stripCR(local.content))>
			<cfset arguments.smsBean.setProviderId(local.content)>
		</cfif>
	</cffunction>
	<!--- outboundClickATell --->
	<!----------------------------------------------------------------------------->


	<!----------------------------------------------------------------------------->
	<!--- formatMobile --->
	<cffunction name="formatMobile" access="public" returntype="numeric">
		<cfargument name="mobileNumber" type="numeric" required="true">
		<cfargument name="country" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.mobileNumber = arguments.mobileNumber>
		<cfswitch expression="#arguments.country#">
			<cfcase value="US,CA">
				<cfif len(arguments.mobileNumber) IS 10>
					<cfset local.mobileNumber = 1 & arguments.mobileNumber>
				</cfif>
			</cfcase>
		</cfswitch>
		<cfreturn local.mobileNumber/>
	</cffunction>
	<!--- formatMobile --->
	<!----------------------------------------------------------------------------->

</cfcomponent>