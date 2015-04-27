<cfcomponent extends="com.blayter.baseComponent" output="false">
	
	
	<!----------------------------------------------------------------------------->
	<!--- keywordProcess --->
	<cffunction name="keywordProcess" output="false" returntype="com.blayter.beans.smsBean" hint="looks at the incoming SMS message and replies with the appropriate response" access="private">
		<cfargument name="smsBean" required="true" type="com.blayter.beans.smsBean" hint="The incoming sms bean">
		<cfset var local = structNew()>
		<cfscript>
		// prep the response for the keywords -----------------------------
		local.sendResponse = false;
		local.outgoingMessageBean = createObject("component","com.blayter.beans.smsBean").init();
		local.outgoingMessageBean.setSMSfrom(arguments.smsBean.getSMSto());
		local.outgoingMessageBean.setSMSto(arguments.smsBean.getSMSfrom());
		local.outgoingMessageBean.setSMSType("sms_out");
		local.outgoingMessageBean.setParentId(arguments.smsBean.getSMSid());
		if(len(arguments.smsBean.getNetwork())){
			local.outgoingMessageBean.setNetwork(arguments.smsBean.getNetwork());
		}
		if(arguments.smsBean.getGateway() NEQ cfc.sms.gatewayProvider){
			local.outgoingMessageBean.setProvider(arguments.smsBean.getProvider());
		}
		
		// --------------------------------------------------------------------------------
		// process the potential keywords (Replace this with your own businesss logic)
		if(findNoCase("vote 1",arguments.smsBean.getMessage())){
			local.sendResponse = true;
			local.outgoingMessageBean.setMessage("Thank you I see that you voted for john");	
		}
		else if(findNoCase("vote 2",arguments.smsBean.getMessage())){
			local.sendResponse = true;
			local.outgoingMessageBean.setMessage("Thank you I see that you voted for joe");	
		}
		else if(findNoCase("vote 3",arguments.smsBean.getMessage())){
			local.sendResponse = true;
			local.outgoingMessageBean.setMessage("Thank you I see that you voted for jane");	
		}
		// --------------------------------------------------------------------------------
		
		// send the message -----------------------------------------------
		if(local.sendResponse IS true){
			outgoingSMS(smsBean=local.outgoingMessageBean);
			arguments.smsBean.setChildId(local.outgoingMessageBean.getSMSId());
		}
		</cfscript>
		<cfreturn arguments.smsBean>
	</cffunction>
	<!--- keywordProcess ---> 
	<!----------------------------------------------------------------------------->
	

</cfcomponent>