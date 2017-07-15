<cfcomponent extends="RootProxy" accessors="true" output="false">

	<cfset this.name = hash( getBaseTemplatePath() )>
	<cfset this.datasource = 'fw1-demo01'>

	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan( 0, 6, 0, 0 )>

	<cfset this.mappings[ '/framework' ] = expandPath( '../app/framework' )>
	<cfset this.mappings[ '/fw1app' ] = expandPath( '../app' )>

	<cfset variables.framework = {
		base = '/fw1app',
		viewsFolder = 'views',
		diLocations = '/fw1app/model/beans,/fw1app/model/services',
		generateSES = true,
		SESOmitIndex = true
	}>


	<cffunction name="before" output="false">
		<cfargument name="rc" type="any">
		<cfargument name="headers" type="struct" required="true">

<!---
		<cflog file="#this.name#" text="#SerializeJSON( rc )#" type="information" >
 --->

		<cfset rc.struControllerErg = {
			bSuccess = false,
			catch = {},
			bCaught = false,
			strError = "",
			arrCSSFiles = [],
			arrJSFiles = [],
			iHTTPStatus = 200, strHTTPStatus = "OK",
			iCntPage = "0"
		}>

	</cffunction>

	<cffunction name="after" output="false">
		<cfargument name="rc" type="any">
		<cfargument name="headers" type="struct" required="true">

		<cfif rc.struControllerErg.iHTTPStatus NEQ 200>
			<cfset renderData().data( "" ).type( "html" ).statusCode( rc.struControllerErg.iHTTPStatus )>
		</cfif>

	</cffunction>

	<cffunction name="setupApplication" output="false">

	</cffunction>

	<cffunction name="setupEnvironment" output="false">
		<cfargument name="env" type="string">

	</cffunction>

	<cffunction name="setupSession" output="false">

	</cffunction>

	<cffunction name="setupRequest" output="false">
		<cfset var resp = getPageContext().getResponse()>
		<cfset resp.setHeader( "Access-Control-Allow-Origin", "*" )>

	</cffunction>

	<cffunction name="setupResponse" output="false">
		<cfargument name="rc" type="struct" required="true">

	</cffunction>

	<cffunction name="setupSubsystem" output="false">
		<cfargument name="module" type="string" required="true">

	</cffunction>

	<cffunction name="setupView" output="false">
		<cfargument name="rc" type="struct" required="true">

	</cffunction>

	<cffunction name="render_zip">
		<cfargument name="renderData" type="struct">

		<cfreturn {
			contentType = 'application/zip',
			output = renderData.data,
			writer = zipwriter
		}>
	</cffunction>

	<cffunction name="zipwriter">
		<cfargument name="renderData" type="any">

		<cfheader name="content-length" value="#arrayLen( renderData )#">
		<cfcontent type="application/zip" variable="#renderData#">

	</cffunction>

	<cffunction name="onError" output="false">
		<cfargument name="exception" type="any" required="true">
		<cfargument name="event" type="string" required="true">

		<cfset super.onError( exception, event )>

		<cfsavecontent variable="local.strStack"><cfoutput>
			#EncodeForHTML( exception.detail )#
			#EncodeForHTML( exception.message )#
			<cfif StructKeyExists( exception, "rootcause" )>
				#EncodeForHTML( exception.rootcause.message )#
				#EncodeForHTML( exception.rootcause.detail )#
			</cfif>
			<cfif StructKeyExists( exception, "tagcontext" )>
				<cfset local.strPref = "">
				<cfloop array="#exception.tagcontext#" index="local.struFile">
					#local.strPref##local.struFile.template#:#local.struFile.line#
					<cfset local.strPref = "| ">
				</cfloop>
			</cfif>
			<cfif StructKeyExists( exception, "SQL" )>
				#exception.SQL#
			</cfif>
			<cfif StructKeyExists( exception, "QueryError" )>
				#exception.queryError#
			</cfif>
			<cfif StructKeyExists( exception, "Where" )>
				#exception.Where#
			</cfif>
		</cfoutput></cfsavecontent>

		<cflog file="fw1-demo01" text="#local.strStack#" type="error">

	</cffunction>

</cfcomponent>
