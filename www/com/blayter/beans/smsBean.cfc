<cfcomponent displayName="smsBean" extends="com.blayter.baseComponent" output="false" hint="This encapsulates all the data for a SMS">
	
	<cfscript>
		cfc.smsID 		= 0;
		cfc.smsType		= "";
		cfc.smsFrom		= "";
		cfc.smsTo		= "";
		cfc.message 	= "";
		cfc.network		= "";
		cfc.parentId	= "";
		cfc.childId		= "";
		cfc.providerId	= "";
		cfc.fromDate	= now();
		cfc.thruDate	= "12/31/2999";
		cfc.lockDate	= "";
		cfc.locked		= false;
		cfc.gateway		= cfc.sms.gatewayProvider;
		cfc.country		= "US";
	</cfscript>

	<cffunction name="getSmsId" access="public" output="false" returntype="string">
		<cfreturn cfc.smsId>
	</cffunction>
	<cffunction name="setSmsId" access="public" output="false" returntype="void">
		<cfargument name="smsId" type="string" required="true">
		<cfset cfc.smsId = arguments.smsId>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getSMStype" access="public" output="false" returntype="string">
		<cfreturn cfc.smsType>
	</cffunction>
	<cffunction name="setSMStype" access="public" output="false" returntype="void">
		<cfargument name="smsType" type="string" required="true">
		<cfset cfc.smsType = arguments.smsType>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getSmsFrom" access="public" output="false" returntype="string">
		<cfreturn cfc.smsFrom>
	</cffunction>
	<cffunction name="setSmsfrom" access="public" output="false" returntype="void">
		<cfargument name="smsFrom" type="numeric" required="true">
		<cfset cfc.smsFrom = arguments.smsFrom>
		<cfreturn>
	</cffunction>

	<cffunction name="getSMSto" access="public" output="false" returntype="string">
		<cfreturn cfc.smsTo>
	</cffunction>
	<cffunction name="setSMSto" access="public" output="false" returntype="void">
		<cfargument name="smsTo" type="numeric" required="true">
		<cfset cfc.smsTo = arguments.smsTo>
		<cfreturn>
	</cffunction>

	<cffunction name="getMessage" access="public" output="false" returntype="string">
		<cfreturn cfc.Message>
	</cffunction>
	<cffunction name="setMessage" access="public" output="false" returntype="void">
		<cfargument name="Message" type="string" required="true">
		<cfset cfc.Message = arguments.Message>
		<cfreturn>
	</cffunction>

	<cffunction name="getNetwork" access="public" output="false" returntype="string">
		<cfreturn cfc.network>
	</cffunction>
	<cffunction name="setNetwork" access="public" output="false" returntype="void">
		<cfargument name="network" type="string" required="true">
		<cfset cfc.network = arguments.network>
		<cfreturn>
	</cffunction>

	<cffunction name="getParentId" access="public" output="false" returntype="string">
		<cfreturn cfc.parentId>
	</cffunction>
	<cffunction name="setParentId" access="public" output="false" returntype="void">
		<cfargument name="parentId" type="string" required="true">
		<cfset cfc.parentId = arguments.parentId>
		<cfreturn>
	</cffunction>

	<cffunction name="getChildId" access="public" output="false" returntype="string">
		<cfreturn cfc.childId>
	</cffunction>
	<cffunction name="setChildId" access="public" output="false" returntype="void">
		<cfargument name="childId" type="string" required="true">
		<cfset cfc.childId = arguments.childId>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getproviderId" access="public" returntype="string">
		<cfreturn cfc.providerId>
	</cffunction>
	<cffunction name="setproviderId" access="public" returntype="void">
		<cfargument name="providerId" type="string" required="true">
		<cfset cfc.providerId = arguments.providerId>
		<cfreturn />
	</cffunction>	
	
	<cffunction name="getFromDate" access="public" output="false" returntype="date">
		<cfreturn cfc.fromDate>
	</cffunction>
	<cffunction name="setFromDate" access="public" output="false" returntype="void">
		<cfargument name="fromDate" type="date" required="true">
		<cfset cfc.fromDate = arguments.fromDate>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getThruDate" access="public" output="false" returntype="date">
		<cfreturn cfc.thruDate>
	</cffunction>
	<cffunction name="setThruDate" access="public" output="false" returntype="void">
		<cfargument name="thruDate" type="date" required="true">
		<cfset cfc.thruDate = arguments.thruDate>
		<cfreturn>
	</cffunction>

	<cffunction name="getLockDate" access="public" output="false" returntype="any">
		<cfreturn cfc.lockDate>
	</cffunction>
	<cffunction name="setLockDate" access="public" output="false" returntype="void">
		<cfargument name="lockDate" type="date" required="true">
		<cfset cfc.lockDate = arguments.lockDate>
		<cfreturn>
	</cffunction>
	
	<cffunction name="isLocked" access="public" output="false" returntype="boolean">
		<cfreturn cfc.locked>
	</cffunction>
	<cffunction name="setLocked" access="public" output="false" returntype="void">
		<cfargument name="locked" type="boolean" required="true">
		<cfset cfc.locked = arguments.locked>
		<cfreturn>
	</cffunction>

	<cffunction name="getGateway" access="public" returntype="string">
		<cfreturn cfc.gateway>
	</cffunction>
	<cffunction name="setGateway" access="public" returntype="void">
		<cfargument name="Gateway" type="string" required="true">
		<cfset cfc.gateway = arguments.gateway>
		<cfreturn />
	</cffunction>

	<cffunction name="getCountry" access="public" returntype="string">
		<cfreturn cfc.Country>
	</cffunction>
	<cffunction name="setCountry" access="public" returntype="void">
		<cfargument name="Country" type="string" required="true">
		<cfset cfc.Country = arguments.Country>
		<cfreturn />
	</cffunction>

</cfcomponent>