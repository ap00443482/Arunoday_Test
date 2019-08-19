<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fs="http://schemas.xmlsoap.org/soap/envelope/">
    <xsl:output method="xml" />
    <xsl:template name="error">
	<xsl:param name="errMessage" select="''" />

        <!--*********************************
                               Get Service Error Code response
                       **********************************-->
					   <dp:reject>
 <dp:send-error>					   
        <xsl:variable name="ErrorMessage" select="$errMessage" />
		<dp:set-variable name="'var://context/elf/dpErrorMsg'" value ="$ErrorMessage"/>
<xsl:variable name="ErrorDetailsLookup" select="document(concat('local:///disk0/WsdlXsd/ConsumerEOSL/Common/Internal_ErrorLookup.xml'))" />
        <xsl:variable name="ErrorDetails" select="$ErrorDetailsLookup/ErrorDetails" />
        <xsl:choose>
            <xsl:when test="(($ErrorMessage = 'DUNS not received') or ($ErrorMessage = 'Contact name not received') or ($ErrorMessage = 'DUNS validation fails') or ($ErrorMessage = 'Contact name validation fails') or ($ErrorMessage = 'ServiceAccess Denied') or ($ErrorMessage = 'Back-end URL not available'))">
                <dp:set-http-response-header name="'x-dp-response-code'" value="'401 Unauthorized'" />
<dp:set-variable name="'var://service/error-protocol-response'" value ="'401'"/>
<dp:set-variable name="'var://service/error-protocol-reason-phrase'" value ="'Unauthorized'"/>
<xsl:variable name="ERROR.REASON">
            <xsl:value-of select="$ErrorDetails/ServiceDetails/Error[@ErrorReason=$ErrorMessage]"/>
        </xsl:variable>
<dp:set-local-variable name="'Error'" value="$ERROR.REASON" />
            </xsl:when>
            <xsl:when test="(($ErrorMessage = 'Invalid Method Type') or ($ErrorMessage = 'Invalid URI'))">
                <dp:set-http-response-header name="'x-dp-response-code'" value="'404 Not Found'" />
<dp:set-variable name="'var://service/error-protocol-response'" value ="'404'"/>
<dp:set-variable name="'var://service/error-protocol-reason-phrase'" value ="'Not Found'"/>
<xsl:variable name="ERROR.REASON">
            <xsl:value-of select="$ErrorDetails/ServiceDetails/Error[@ErrorReason=$ErrorMessage]"/>
        </xsl:variable>
<dp:set-local-variable name="'Error'" value="$ERROR.REASON" />
            </xsl:when>
            <xsl:otherwise>
                <dp:set-http-response-header name="'x-dp-response-code'" value="'500 Internal Server Error'" />
<dp:set-variable name="'var://service/error-protocol-response'" value ="'500'"/>
<dp:set-variable name="'var://service/error-protocol-reason-phrase'" value ="'Internal Server Error'"/>
<xsl:variable name="ERROR.REASON">
            <xsl:value-of select="$ErrorDetails/ServiceDetails/Error[@ErrorReason=$ErrorMessage]"/>
        </xsl:variable>
<dp:set-local-variable name="'Error'" value="$ERROR.REASON" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="URI" select="dp:variable('var://service/URI')" />
        <xsl:variable name="BT.SYSTEM.NAME" select="dp:variable('var://service/domain-name')" />

        <xsl:variable name="DUNSID" select="dp:variable('var://context/ELF/DUNSID')" />
		<dp:set-local-variable name="'user'" value="$DUNSID" />
		<xsl:if test = "(string-length($DUNSID) = '0')">
		<dp:set-local-variable name="'user'" value="'not available'" />
		</xsl:if>
		<xsl:variable name="dunsid">
            <xsl:value-of select="dp:local-variable('user')" />
        </xsl:variable>
		   
        <xsl:variable name="ERRORS.REASON">
            <xsl:value-of select="dp:local-variable('Error')" />
        </xsl:variable>
		<xsl:if test = "(string-length($ERRORS.REASON) = '0')">
		<dp:set-local-variable name="'Error'" value="'BT RETAIL HAS EXPERIENCED A PROBLEM WITH YOUR REQUEST SEE BELOW FOR TECHNICAL REASON :- Process Error aborted processing.
Process Error aborted processing. Internal Error'" />
		</xsl:if>
		<xsl:variable name="ERRORREASON">
            <xsl:value-of select="dp:local-variable('Error')" />
        </xsl:variable>
        <!--*********************************
                               Generate error message
                       **********************************-->
   
	 <soap:Envelope>
            <soap:Body>
                <soap:Fault>
                    <faultstring>
                        <xsl:value-of select="$ERRORREASON" />
                    </faultstring>
                    <detail>
                        <fs:Detail xmlns:fs="http://www.forumsystems.com/2004/04/soap-fault-detail">
                            <fs:SystemName>
                                <xsl:value-of select="$BT.SYSTEM.NAME" />
                            </fs:SystemName>
                            <fs:User>
                                <xsl:value-of select="$dunsid" />
                            </fs:User>
                            <fs:Policy>
                                <xsl:value-of select="$URI" />
                            </fs:Policy>
                        </fs:Detail>
                    </detail>
                </soap:Fault>
            </soap:Body>
        </soap:Envelope>
</dp:send-error>	
 </dp:reject>   
    </xsl:template>
</xsl:stylesheet>
