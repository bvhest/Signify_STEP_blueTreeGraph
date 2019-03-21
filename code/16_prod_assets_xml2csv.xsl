<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
  <xsl:output method="text" indent="no"/>
   
  <!-- create headers and call tree-nodes to convert into lines: -->
  <xsl:template match="/">
    <xsl:text>productId,assetId,AssetType,AssetPublUrl</xsl:text>
    <xsl:apply-templates select="//Product[@UserTypeID='Final Product']"/>
  </xsl:template>

  <!-- create lines with tree-node data: -->
  <xsl:template match="Product">
"<xsl:value-of select="@ID" />","<xsl:value-of select="AssetCrossReference/@AssetID" />","<xsl:value-of select="AssetCrossReference/@Type" />","<xsl:value-of select="AssetCrossReference/MetaData/Value[@AttributeID='xUCDM.Asset.PublicURL']" />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
