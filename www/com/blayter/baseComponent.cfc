<cfcomponent name="BaseComponent" hint="All cfcs inherit from this." output="false">
	
	<!----------------------------------------------------------------------------->
	<!--- global variables to the CFC --->
	<cfscript>
	variables.cfc					= structNew();
	cfc.dsn							= "blayter_demo";
	
	cfc.sms.gatewayProvider			= "clickAtell";
	
	// MXTelcom API Settings
	cfc.mxTelcom.username			= "";
	cfc.mxTelcom.password			= "";
	
	
	// ClickATell API Settings
	cfc.clickATell.username			= "";
	cfc.clickATell.password			= "";
	cfc.clickATell.apiId			= "";
	
	
	</cfscript>
	<!--- global variables to the CFC --->
	<!----------------------------------------------------------------------------->
	
		
	<cffunction name="init" access="public" returntype="any">
		<cfreturn this>
	</cffunction>	

	<cffunction name="setDSN" access="public" returntype="void">
		<cfargument name="dsn" type="string" required="true">
		<cfset cfc.dsn = arguments.dsn>
		<cfreturn/>
	</cffunction>
	<cffunction name="getDSN" access="public" returntype="string">
		<cfreturn cfc.dsn>
	</cffunction> 
	
	<!----------------------------------------------------------------------------->
	<!--- dump --->
	<cffunction name="dump" access="public" returntype="any" output="true" hint="Will dump the private variable scope of the component. This is set in basecomponent.">
		<cfreturn cfc>
	</cffunction>	
	<!--- dump --->	
	<!----------------------------------------------------------------------------->

</cfcomponent>