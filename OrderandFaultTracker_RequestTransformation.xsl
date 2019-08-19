<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://exslt.org/strings"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:open="http://www.openuri.org/"
    xmlns:urn="urn:com.btwholesale.Assurance4-v5-0"
    xmlns:dial="http://www.bt.com/eai/pal/btw/DialogueServices"
    xmlns:regexp="http://exslt.org/regular-expressions" extension-element-prefixes="dp" exclude-result-prefixes="dp regexp" version="1.0">
	<xsl:import href="local:///disk0/WsdlXsd/ConsumerEOSL/Common/Internal_ErrorTransformation.xsl" />
	<xsl:import href="local:///disk0/WsdlXsd/ConsumerEOSL/Common/Duns_And_ContactName_Validation.xsl" />
    

    <xsl:template match="/">
        
        <xsl:variable name="URI">
            <xsl:value-of select="dp:variable('var://service/URI')" />
        </xsl:variable>
		
		<xsl:variable name="content-type" select="dp:variable('var://service/original-request-content-type')"/>
		    <xsl:message dp:priority="debug">content-type data:::   
               <xsl:copy-of select="$content-type" />
			</xsl:message>
		<xsl:if test="not($content-type = 'TEXT/XML*' or 'application/*+xml' or 'application/json' or 'application/x-www-form-urlencoded' or 'image/png' or  'application/xml*' or 'text/xml*' or 'multipart/*' or 'text/html' or 'text/plain')">
		    <xsl:call-template name="error">
			<xsl:with-param name="errMessage" select="'Invalid MIME Type'"/>
			</xsl:call-template>
        </xsl:if>
		
        <!--Request with URI '/btr/emp/2000/Orderandfaulttracker'-->
		<xsl:if test = "($URI = '/bi-rest/emp/2000/Orderandfaulttracker')" >
			<xsl:variable name="DUNSId">
				<xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='getOrderDetails']/*[local-name()='GenericCPWSHubService']/*[local-name()='AddOrderDetailsQuery']/*[local-name()='Query']/*[local-name()='RequesterParty']/*[local-name()='Party']/*[local-name()='PartyIdentification']/*[local-name()='ID']/text()"/>
			</xsl:variable>
			<dp:set-local-variable name="'dunsID'" value="$DUNSId" />
        </xsl:if>
        <xsl:variable name="DUNSID">
            <xsl:value-of select="dp:local-variable('dunsID')" />
        </xsl:variable>
        <dp:set-variable name="'var://context/ELF/DUNSID'" value="$DUNSID" />
        <xsl:message dp:priority="debug">DUNSID Data:::   
   
            <xsl:copy-of select="normalize-space(string-length($DUNSID))"/>
        </xsl:message>
        <xsl:if test = "(string-length($DUNSID) = '0')">
		<xsl:call-template name="error">
			<xsl:with-param name="errMessage" select="'DUNS not received'"/>
			</xsl:call-template>
       
        </xsl:if>
        <!-- DUNSID VALIDATION-->
	<xsl:call-template name="DUNS-VALIDATION">
		<xsl:with-param name="data" select="$DUNSID"/>
	</xsl:call-template>

		<!--DUNSID VALIDATION CLOSE-->
        <xsl:variable name="BackendDetailsLookup" select="document(concat('local:/disk0/WsdlXsd/ConsumerEOSL/Common/BackendRouting_Lookup.xml'))" />
        <xsl:variable name="URLDetails" select="$BackendDetailsLookup/ServiceBackend" />
		<xsl:variable name="ServiceAccess">
            <xsl:value-of select="$URLDetails/Service[@uri=$URI]/ServiceAccess[@UniqueID=$DUNSID]"/>
        </xsl:variable>
        <xsl:if test = "($ServiceAccess != 'YES')">
			<xsl:call-template name="error">
			<xsl:with-param name="errMessage" select="'ServiceAccess Denied'"/>
			</xsl:call-template>
           
        </xsl:if>
        <xsl:variable name="Backendurl">
            <xsl:value-of select="$URLDetails/Service[@uri=$URI]/BackendServiceAccess[@UniqueID=$DUNSID]/text()"/>
        </xsl:variable>
		 <xsl:message dp:priority="debug">Backendurl data:::
   
            <xsl:copy-of select="$Backendurl" />
			</xsl:message>
		<dp:set-local-variable name="'Backend'" value="$Backendurl" />
        <xsl:if test = "(string-length($BackendURL) = '0')">
           <xsl:variable name="Backendurl">
            <xsl:value-of select="$URLDetails/Service[@uri=$URI]/BackendURL[@UniqueID='NA']/text()"/>
			<dp:set-local-variable name="'Backend'" value="$Backendurl" />
        </xsl:variable>
        </xsl:if>
		<xsl:variable name="BackendURL">
            <xsl:value-of select="dp:local-variable('Backend')" />
        </xsl:variable>
		<xsl:if test = "string-length($BackendURL) = '0' ">
		 <xsl:call-template name="error">
			<xsl:with-param name="errMessage" select="'Back-end URL not available'"/>
			</xsl:call-template>
        </xsl:if>
        <dp:set-variable name="'var://service/routing-url'" value="$BackendURL" />
        <dp:set-variable name="'var://service/routing-url-sslprofile'" value="'client:ELF_OR_CIT_Client'" />
        <xsl:copy-of select="." />
    </xsl:template>
</xsl:stylesheet>
