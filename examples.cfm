<!--- Create the ELE Quova User --->
<cfset quovaUser = {
	Key="",
	sharedSecret=""
} />

<!--- Instantiate the ele CFC --->
<cfset quova = createObject("component","cfc.quova").init(argumentCollection=quovaUser) />

<cfset quovaRequest = quova.sendRequest("212.52.63.112") />

<cfdump var="#quovaRequest#" label="quova request" />
