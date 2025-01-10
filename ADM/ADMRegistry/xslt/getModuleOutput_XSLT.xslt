<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="getModuleOutput" select="$ctx:returnGetModule"/>
	<xsl:template match="/">
    	<getModuleOutput>       
        	<result>
	            <timestamp>
              		<xsl:value-of select="xp20:current-dateTime ( )"/>
	            </timestamp>
	            <resultDescription>SustIMS0000 - Sucesso</resultDescription>
	            <totalRecords>
	               <xsl:value-of select="count (//selectModuleOutput)"/>
	            </totalRecords>
	            <hasmore>false</hasmore>
	            <offset>0</offset>
	            <message>OK</message>
	            <status>200</status>
			</result> 
	        <xsl:for-each select="//selectModuleOutput">
	         <module>
               <module>
                  <id>
                     <xsl:value-of select="IdModule"/>
                  </id>
                  <code>
                     <xsl:value-of select="ModuleCode"/>
                  </code>
                  <idTableDesc>
                     <xsl:value-of select="IdTableDesc"/>
                  </idTableDesc>
                  <smallDescription>
                     <xsl:value-of select="DescriptionSmall"/>
                  </smallDescription>
                  <mediumDescription>
                     <xsl:value-of select="DescriptionMedium"/>
                  </mediumDescription>
                  <largeDescription>
                     <xsl:value-of select="DescriptionLarge"/>
                  </largeDescription>
               </module>
               <image>
                  <xsl:value-of select="Image"/>
               </image>
               <functional>
                  <xsl:value-of select="Functional"/>
               </functional>
               <audit>
                  <creationUser>
                     <xsl:value-of select="CreationUser"/>
                  </creationUser>
                  <creationDate>
                     <xsl:value-of select="CreationDate"/>
                  </creationDate>
                  <lastUpdatedUser>
                     <xsl:value-of select="LastUpdatedUser"/>
                  </lastUpdatedUser>
                  <lastUpdatedDate>
                     <xsl:value-of select="LastUpdatedDate"/>
                  </lastUpdatedDate>
               </audit>
               <active>
                  <xsl:value-of select="Active"/>
               </active>
            </module>
	       </xsl:for-each>
      </getModuleOutput>
   </xsl:template>
</xsl:stylesheet>
