<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fs="http://schemas.xmlsoap.org/soap/envelope/">
    <xsl:output method="xml" />
	<xsl:template name="DUNS-VALIDATION">
	<xsl:param name="data"/>
	<xsl:if test="string-length($data)&gt;0">
		<xsl:variable name="DUNSID">
			<xsl:value-of select="substring($data,1,1)"/>
		</xsl:variable>
		<xsl:if test="(contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',$DUNSID)!='true')">
			<xsl:call-template name="error">
			<xsl:with-param name="errMessage" select="'DUNS validation fails'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="DUNS-VALIDATION">
			<xsl:with-param name="data" select="substring($data,2)"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<xsl:template name="CONTACTNAME-VALIDATION">
	<xsl:param name="data"/>
	<xsl:if test="string-length($data)&gt;0">
		<xsl:variable name="Contactname">
			<xsl:value-of select="substring($data,1,1)"/>
		</xsl:variable>
		<xsl:if test="(contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',$Contactname)!='true')">
			<xsl:call-template name="error">
			<xsl:with-param name="errMessage" select="'Contact name validation fails'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="CONTACTNAME-VALIDATION">
			<xsl:with-param name="data" select="substring($data,2)"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
