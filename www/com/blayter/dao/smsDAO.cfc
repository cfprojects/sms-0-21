<cfcomponent displayname="smsDAO" extends="com.blayter.baseComponent" output="false">

	<!----------------------------------------------------------------------------->
	<!--- read --->
	<cffunction name="read" output="false" returntype="com.blayter.beans.smsBean" hint="returns a smsBean based on the ID of the SMS passed in" access="public">
		<cfargument name="smsId" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.smsBean = createObject("component","com.blayter.beans.smsBean").init()>
		<cfquery datasource="#cfc.dsn#" name="local.readSMS">
			SELECT
				sms_id,
				sms_type,
				sms_from,
				sms_to,
				message,
				network_type,
				parent_id,
				child_id,
				from_date,
				thru_date,
				lock_date,
				locked
			FROM
				smsQueue
			WHERE
				sms)id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.smsId#">
					AND
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> BETWEEN from_date AND thru_date
		</cfquery>
		<cfscript>
		if(local.readSMS.recordCount GT 0){
			// set items that will have a value no matter what
			local.smsBean.setId(local.readSMS.sms_id);
			local.smsBean.setType(trim(local.readSMS.sms_type));
			local.smsBean.setFrom(local.readSMS.sms_from);
			local.smsBean.setTo(local.readSMS.sms_to);
			local.smsBean.setMessage(local.readSMS.message);
			local.smsBean.setFromDate(local.readSMS.from_date);
			local.smsBean.setThruDate(local.readSMS.thru_date);
			local.smsBean.setLocked(local.readSMS.locked);
			// set items that may not have a value in the database
			if(len(trim(local.readSMS.network))){
				local.smsBean.setNetwork(trim(local.readSMS.network));
			}
			if(len(local.readSMS.parent_id)){
				local.smsBean.setParentId(local.readSMS.parent_id);
			}
			if(len(local.readSMS.child_id)){
				local.smsBean.setChildId(local.readSMS.child_id);
			}
			if(len(local.readSMS.lock_date)){
				local.smsBean.setLockDate(local.readSMS.lock_date);
			}
		}
		</cfscript>
		<cfreturn local.smsBean>
	</cffunction>
	<!--- read --->
	<!----------------------------------------------------------------------------->

	
	<!----------------------------------------------------------------------------->
	<!--- create --->
	<cffunction name="create" output="false" returntype="void" hint="creates a record in the database for the SMS message" access="public">
		<cfargument name="smsBean" type="com.blayter.beans.smsBean" required="true">
		<cfset var local = structNew()>
		<cfquery datasource="#cfc.dsn#" name="local.createSMS">
			SET NOCOUNT ON;
			INSERT INTO sms_queue
				(
				sms_type_code,
				sms_from,
				sms_to,
				message,
				parent_id,
				child_id,
				from_date,
				thru_date,
				lock_date,
				locked
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.smsBean.getSMStype()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.smsBean.getSMSfrom()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.smsBean.getSMSto()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.smsBean.getMessage()#">,
				<cfif len(arguments.smsBean.getParentId())><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.smsBean.getParentId()#"><cfelse>NULL</cfif>,
				<cfif len(arguments.smsBean.getChildId())><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.smsBean.getChildId()#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(2999,12,31)#">,
				<cfif len(arguments.smsBean.getLockDate())><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.smsBean.getLockDate()#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.smsBean.isLocked()#">
				);
			SELECT ident_current('sms_queue') AS new_sms_id;
			SET NOCOUNT OFF;
		</cfquery>
		<cfset arguments.smsBean.setSMSId(local.createSMS.new_sms_id)>
		<cfreturn/>
	</cffunction>
	<!--- create --->
	<!----------------------------------------------------------------------------->
		
	
	<!----------------------------------------------------------------------------->
	<!--- update --->
	<cffunction name="update" output="false" returntype="void" hint="updates a record in the database for the SMS message" access="public">
		<cfargument name="smsBean" type="com.blayter.beans.smsBean" required="true">
		<cfset var local = structNew()>
		<cfquery datasource="#cfc.dsn#" name="local.updateSMS">
			UPDATE sms_queue
			SET
				sms_type_code	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.smsBean.getSMStype()#">,
				sms_from		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.smsBean.getSMSfrom()#">,
				sms_to			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.smsBean.getSMSto()#">,
				message			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.smsBean.getMessage()#">,
				parent_id		= <cfif len(arguments.smsBean.getParentId())><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.smsBean.getParentId()#"><cfelse>NULL</cfif>,
				child_id		= <cfif len(arguments.smsBean.getChildId())><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.smsBean.getChildId()#"><cfelse>NULL</cfif>,
				thru_date		= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.smsBean.getThruDate()#">,
				lock_date		= <cfif len(arguments.smsBean.getLockDate())><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.smsBean.getLockDate()#"><cfelse>NULL</cfif>,
				locked			= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.smsBean.isLocked()#">
			WHERE
				sms_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.smsBean.getSMSid()#">
		</cfquery>
		<cfreturn/>
	</cffunction>
	<!--- update --->
	<!----------------------------------------------------------------------------->
	
	
</cfcomponent>