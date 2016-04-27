<!--- Quova.cfc

	Interacts with the Quova GeoLocation service. Get your API Key here:
	http://developer.quova.com/
	
	Quova provides the MOST IP geolocation data available on the planet. And it’s the most accurate. Check it out.
	The Quova API lets you plug into the vast world of IP intelligence, allowing you to instantly build your own
	Quova-powered applications for the web, desktop and mobile devices.
	
	Author: David Cooke
	Created: 2011-01-11
	Version 0.1.0
	
	License:-
	
	Copyright (c) 2010 David Cooke

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	Contributors:
	
		David Cooke
	
--->
<cfcomponent hint="CFC allowing users to interact with the Quova GeoLocation API" displayname="Quova" output="false">
	
	<cfset variables.Key = "" />
	<cfset variables.sharedSecret = "" />
	<cfset variables.domain = "http://api.quova.com/" />
	<cfset variables.version = "v1/ipinfo/" />
	
	<cffunction name="init" description="Initialises the Quova CFC, returns itself" access="public" returntype="any" output="false">
		<cfargument name="key" type="String" required="true" hint="I am the users API Key" />
		<cfargument name="sharedSecret" type="String" required="true" hint="I am the users API shared Secret" />
		<cfargument name="domain" type="String" required="false" hint="I am the domain" />

		<cfset setKey(arguments.key) />
		<cfset setSharedSecret(arguments.sharedSecret) />
							
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="sendRequest" access="public" returntype="any" output="false" hint="I send the request to the Quova API">
		<cfargument name="IPAddress" type="String" required="true" hint="I am an IP Address" />
		<cfset var response = {} />
		<cfset var URL = getDomain() & getVersion() & arguments.IPAddress />
		<cfset var queryString = "?apikey=" & getKey() & "&sig=" & signRequest() />
		<!--- Try and run the request --->
		<cftry>
			<cfhttp url="#URL##queryString#" method="GET" />
			<cfcatch type="Any">
				<cfreturn "The http request to #URL# failed" />
			</cfcatch>
		</cftry>

		<!--- Return response --->
		<cfset response = duplicate(cfhttp) />
		<cfset response.queryString = "#URL##queryString#" />
		<cfset response.fileContent = toString(response.fileContent) />
		<cfset response.success = response.statusCode eq "200 OK" />
		
		<cfif IsXML(response.fileContent)>
			<cfreturn XmlParse(response.fileContent) />
		<cfelse>
			<cfreturn "The request to #response.queryString# failed: #response.fileContent#">
		</cfif>
	</cffunction>

	<cffunction name="signRequest" access="public" returntype="String" output="false" hint="I sign the request">
		<cfset var epochTime = DateDiff("s", DateConvert("utc2Local", "January 1 1970 00:00"), now() ) />
		<cfreturn lcase( Hash( getKey() & getSharedSecret() & epochTime, "MD5" )) />
	</cffunction>
		
	<!--- *********************************************************************************************************	--->
	<!---                                         Getters and Setters									         	--->
	<!--- *********************************************************************************************************	--->
	
	<cffunction name="setKey" access="public" returntype="void">
		<cfargument name="key" type="String" required="true" />
		<cfset variables.key = arguments.key />
	</cffunction>
	
	<cffunction name="getKey" access="public" returntype="any">
		<cfreturn variables.key />
	</cffunction>
	
	<cffunction name="setDomain" access="public" returntype="void">
		<cfargument name="domain" type="String" required="true" />
		<cfset variables.domain = arguments.domain />
	</cffunction>
	
	<cffunction name="getDomain" access="public" returntype="any">
		<cfreturn variables.domain />
	</cffunction>
	
	<cffunction name="setSharedSecret" access="public" returntype="void">
		<cfargument name="sharedSecret" type="String" required="true" />
		<cfset variables.sharedSecret = arguments.sharedSecret />
	</cffunction>
	
	<cffunction name="getSharedSecret" access="public" returntype="any">
		<cfreturn variables.sharedSecret />
	</cffunction>	
	
	<cffunction name="setVersion" access="public" returntype="void">
		<cfargument name="version" type="String" required="true" />
		<cfset variables.version = arguments.version />
	</cffunction>
	
	<cffunction name="getVersion" access="public" returntype="any">
		<cfreturn variables.version />
	</cffunction>	
	
</cfcomponent>