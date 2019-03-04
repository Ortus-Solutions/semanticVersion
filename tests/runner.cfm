<cfsetting showDebugOutput="false">
<!--- Executes all tests in the 'specs' folder with simple reporter by default --->
<cfparam name="url.reporter" default="simple">
<cfparam name="url.directory" default="tests.specs">
<cfparam name="url.recurse" default="false" type="boolean">
<cfparam name="url.bundles" default="">
<cfparam name="url.labels" default="">
<cfparam name="url.excludes" default="">
<cfparam name="url.reportpath" default="#expandPath( "/tests/results" )#">
<cfparam name="url.propertiesFilename" default="TEST.properties">
<cfparam name="url.propertiesSummary" default="false" type="boolean">

<cfparam name="url.coverageEnabled" default="true">
<cfparam name="url.coverageSonarQubeXMLOutputPath" default="">
<cfparam name="url.coveragePathToCapture" default="#expandPath( '/' )#">
<cfparam name="url.coverageWhitelist" default="">
<cfparam name="url.coverageBlacklist" default="/testbox/,/tests/,/ModuleConfig.cfc">
<cfparam name="url.coverageBrowserOutputDir" default="#expandPath( '/tests/results/coverageReport' )#">

<cfscript>

	include template="/testbox/system/runners/HTMLRunner.cfm";
</cfscript>
