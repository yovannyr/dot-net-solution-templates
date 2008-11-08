<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
exclude-result-prefixes="doc"
version='1.0'>
<xsl:param name="includeidenticals"><xsl:text>true</xsl:text></xsl:param>

<xsl:param name="PageTitle"><xsl:text>SQL Compare Report:</xsl:text></xsl:param>
<xsl:param name="Type"><xsl:text>Type</xsl:text></xsl:param>
<xsl:param name="Owner"><xsl:text>Owner</xsl:text></xsl:param>
<xsl:param name="Object"><xsl:text>Object</xsl:text></xsl:param>
<xsl:param name="ObjectName"><xsl:text>Object Name</xsl:text></xsl:param>
<xsl:param name="Create"><xsl:text>Create</xsl:text></xsl:param>
<xsl:param name="Drop"><xsl:text>Drop</xsl:text></xsl:param>
<xsl:param name="Status"><xsl:text>Status</xsl:text></xsl:param>
<xsl:param name="vs"><xsl:text>vs</xsl:text></xsl:param>
<xsl:param name="Different"><xsl:text>Different</xsl:text></xsl:param>
<xsl:param name="Identical"><xsl:text>Identical</xsl:text></xsl:param>
<xsl:param name="SQLScripts"><xsl:text>SQL Scripts</xsl:text></xsl:param>
<xsl:param name="viewSQL"><xsl:text>view SQL</xsl:text></xsl:param>
<xsl:param name="summary"><xsl:text>Summary</xsl:text></xsl:param>
<xsl:param name="enablescript"><xsl:text>Please enable javascript</xsl:text></xsl:param>
<xsl:param name="SQLView"><xsl:text>SQL View</xsl:text></xsl:param>
<xsl:param name="noSQLError"><xsl:text>Error, No SQL Availible</xsl:text></xsl:param>
<xsl:param name="Table"><xsl:text>Table</xsl:text></xsl:param>
<xsl:param name="View"><xsl:text>View</xsl:text></xsl:param>
<xsl:param name="StoredProcedure"><xsl:text>Stored Procedure</xsl:text></xsl:param>
<xsl:param name="User"><xsl:text>User</xsl:text></xsl:param>
<xsl:param name="Role"><xsl:text>Role</xsl:text></xsl:param>
<xsl:param name="Rule"><xsl:text>Rule</xsl:text></xsl:param>
<xsl:param name="Default"><xsl:text>Default</xsl:text></xsl:param>
<xsl:param name="UDT"><xsl:text>User Defined Type</xsl:text></xsl:param>
<xsl:param name="UDF"><xsl:text>User Defined Function</xsl:text></xsl:param>
<xsl:param name="FTC"><xsl:text>Full Text Catalog</xsl:text></xsl:param>
<xsl:param name="FTS"><xsl:text>Full Text Stoplist</xsl:text></xsl:param>

<xsl:param name="Assembly"><xsl:text>Assembly</xsl:text></xsl:param>
<xsl:param name="AsymmetricKey"><xsl:text>Asymmetric Key</xsl:text></xsl:param>
<xsl:param name="Certificate"><xsl:text>Certificate</xsl:text></xsl:param>
<xsl:param name="Contract"><xsl:text>Contract</xsl:text></xsl:param>
<xsl:param name="DdlTrigger"><xsl:text>DDL Trigger</xsl:text></xsl:param>
<xsl:param name="EventNotification"><xsl:text>Event Notification</xsl:text></xsl:param>
<xsl:param name="MessageType"><xsl:text>Message Type</xsl:text></xsl:param>
<xsl:param name="PartitionFunction"><xsl:text>Partition Function</xsl:text></xsl:param>
<xsl:param name="PartitionScheme"><xsl:text>Partition Scheme</xsl:text></xsl:param>
<xsl:param name="Queue"><xsl:text>Queue</xsl:text></xsl:param>
<xsl:param name="Route"><xsl:text>Route</xsl:text></xsl:param>
<xsl:param name="Schema"><xsl:text>Schema</xsl:text></xsl:param>
<xsl:param name="Service"><xsl:text>Service</xsl:text></xsl:param>
<xsl:param name="ServiceBinding"><xsl:text>Service Binding</xsl:text></xsl:param>
<xsl:param name="SymmetricKey"><xsl:text>Symmetric Key</xsl:text></xsl:param>
<xsl:param name="Synonym"><xsl:text>Synonym</xsl:text></xsl:param>
<xsl:param name="XmlSchemaCollection">XML Schema Collection<xsl:text></xsl:text></xsl:param>

<xsl:param name="OnlyIn1Title"><xsl:text>Only in 1</xsl:text></xsl:param>
<xsl:param name="OnlyIn2Title"><xsl:text>Only in 2</xsl:text></xsl:param>

<xsl:template name="objectTypeToString">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$node/@objecttype = 'table'"><xsl:value-of select="$Table" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'view'"><xsl:value-of select="$View" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'storedprocedure'"><xsl:value-of select="$StoredProcedure"/></xsl:when>
    <xsl:when test="$node/@objecttype = 'user'"><xsl:value-of select="$User" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'role'"><xsl:value-of select="$Role" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'rule'"><xsl:value-of select="$Rule" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'default'"><xsl:value-of select="$Default" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'userdefinedtype'"><xsl:value-of select="$UDT" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'function'"><xsl:value-of select="$UDF" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'fulltextcatalog'"><xsl:value-of select="$FTC" /></xsl:when>
    <xsl:when test="$node/@objecttype = 'fulltextstoplist'"><xsl:value-of select="$FTS" /></xsl:when>
	
	<xsl:when test="$node/@objecttype = 'assembly'"><xsl:value-of select="$Assembly" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'asymmetrickey'"><xsl:value-of select="$AsymmetricKey" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'certificate'"><xsl:value-of select="$Certificate" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'contract'"><xsl:value-of select="$Contract" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'ddltrigger'"><xsl:value-of select="$DdlTrigger" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'eventnotification'"><xsl:value-of select="$EventNotification" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'messagetype'"><xsl:value-of select="$MessageType" /></xsl:when>
 	<xsl:when test="$node/@objecttype = 'partitionfunction'"><xsl:value-of select="$PartitionFunction" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'partitionscheme'"><xsl:value-of select="$PartitionScheme" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'queue'"><xsl:value-of select="$Queue" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'route'"><xsl:value-of select="$Route" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'schema'"><xsl:value-of select="$Schema" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'service'"><xsl:value-of select="$Service" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'servicebinding'"><xsl:value-of select="$ServiceBinding" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'symmetrickey'"><xsl:value-of select="$SymmetricKey" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'synonym'"><xsl:value-of select="$Synonym" /></xsl:when>
	<xsl:when test="$node/@objecttype = 'xmlschemacollection'"><xsl:value-of select="$XmlSchemaCollection" /></xsl:when>
   <xsl:otherwise>
     <xsl:value-of select="$node/@objecttype" />
    </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="onlyIn1Title">
	<xsl:value-of select="$OnlyIn1Title"/>
</xsl:template>

<xsl:template name="onlyIn2Title">
	<xsl:value-of select="$OnlyIn2Title"/>
</xsl:template>

<xsl:template match="comparison">
  <html>
    <head>
      <title><xsl:value-of select="$PageTitle"/></title>
      <style type="text/css">
	<![CDATA[
<!--
.fonts {font-family: Tahoma, Arial, sans-serif}
body {
	background-color: #BED2E9;
}
.dataTable {
	font-family: Tahoma, Arial, sans-serif;
	font-size: 12px;
	background-color: #DDDDDD;
}
.titlediv {
	background-color: #FFFFFF;
}
.sql {
	font-family: Tahoma, Arial, sans-serif;
	text-align: left;
	vertical-align: text-top;
}
-->
]]>
      </style>
    </head>
    <body>
    <div class="titlediv" width="100%">
      <p align="center">
	<span class="style1"><xsl:value-of select="$PageTitle"/><br />
	  <strong>
	    <xsl:value-of select="datasources/datasource[@id='1']/server" />
	    <xsl:text>.</xsl:text>
	    <xsl:value-of select="datasources/datasource[@id='1']/database" />
	    <xsl:text> ( </xsl:text>
	    <xsl:value-of select="datasources/datasource[@id='1']/@type" />
	    <xsl:text> ) </xsl:text>
	  </strong>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="$vs"/>
 	  <xsl:text> </xsl:text>
	  <strong>
   	    <xsl:value-of select="datasources/datasource[@id='2']/server" />
	    <xsl:text>.</xsl:text>
	    <xsl:value-of select="datasources/datasource[@id='2']/database" />
	    <xsl:text> ( </xsl:text>
	    <xsl:value-of select="datasources/datasource[@id='2']/@type" />
	    <xsl:text> ) </xsl:text>
	  </strong>
	  <br />
	  <xsl:value-of select="@timestamp" />
	</span>
      </p>
    </div>
    <p align="left">
      <strong>
        <xsl:value-of select="$Different" />		    
      </strong>
      <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dataTable">
	<tr>
	  <td width="14%">
	    <strong>
              <xsl:value-of select="$Type" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="24%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="3%"></td>
	  <td width="27%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="8%">
	    <div align="center"></div>
	  </td>
	</tr>
	<xsl:for-each select="differences/difference[@status='different']">
	  <xsl:call-template name="nonSQLRows">
	    <xsl:with-param name="node" select="."/>
	    <xsl:with-param name="centerline"><xsl:text>&lt;&gt;</xsl:text></xsl:with-param>
	  </xsl:call-template>
	</xsl:for-each>
      </table>
    </p>
    <p align="left">
      <strong>
	<xsl:call-template name="onlyIn1Title">
	  <xsl:with-param name="node" select="."/>
	</xsl:call-template>	  
      </strong>
      <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dataTable">
	<tr>
	  <td width="14%">
	    <strong>
              <xsl:value-of select="$Type" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="24%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="3%"></td>
	  <td width="27%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="8%">
	    <div align="center"></div>
	  </td>
	  </tr>
  	  <xsl:for-each select="differences/difference[@status='onlyin1']">
	  <xsl:call-template name="nonSQLRows">
	    <xsl:with-param name="node" select="."/>
   	    <xsl:with-param name="centerline"><xsl:text>-&gt;</xsl:text></xsl:with-param>
	  </xsl:call-template>
        </xsl:for-each>
      </table>
    </p>
    <p align="left">
      <strong>
	<xsl:call-template name="onlyIn2Title">
	  <xsl:with-param name="node" select="."/>
	</xsl:call-template>	  
      </strong>
      <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dataTable">
	<tr>
	  <td width="14%">
	    <strong>
              <xsl:value-of select="$Type" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="24%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="3%"></td>
	  <td width="27%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="8%">
	    <div align="center"></div>
	  </td>
	  </tr>
  	  <xsl:for-each select="differences/difference[@status='onlyin2']">
	  <xsl:call-template name="nonSQLRows">
	    <xsl:with-param name="node" select="."/>
    	    <xsl:with-param name="centerline"><xsl:text>&lt;-</xsl:text></xsl:with-param>
	  </xsl:call-template>
        </xsl:for-each>
      </table>
    </p>
    <xsl:choose>
    <xsl:when test="$includeidenticals = 'true'">
    <p align="left">
      <strong>
	<xsl:value-of select="$Identical" />
      </strong>
      <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dataTable">
	<tr>
	  <td width="14%">
	    <strong>
              <xsl:value-of select="$Type" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="24%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="3%"></td>
	  <td width="27%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="8%">
	    <div align="center"></div>
	  </td>
	  </tr>
  	  <xsl:for-each select="differences/difference[@status='equal']">
	  <xsl:call-template name="nonSQLRows">
	    <xsl:with-param name="node" select="."/>
	    <xsl:with-param name="centerline"><xsl:text>=</xsl:text></xsl:with-param>
	  </xsl:call-template>
        </xsl:for-each>
      </table>
    </p>
    </xsl:when>
    </xsl:choose>
    <p align="left">
      <strong>
	<xsl:value-of select="$SQLScripts"/>
      </strong>
      <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dataTable">
	<tr>
	  <td width="14%">
	    <strong>
              <xsl:value-of select="$Type" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="24%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="3%"></td>
	  <td width="27%">
	    <strong>
              <xsl:value-of select="$Object" />		    
	    </strong>
	  </td>
	  <td width="12%">
	    <strong>
              <xsl:value-of select="$Owner" />		    
	    </strong>
	  </td>
	  <td width="8%">
	    <div align="center"></div>
	  </td>
	  </tr>
  	  <xsl:for-each select="differences/difference[@status='different']">
	  <xsl:call-template name="SQLRows">
	    <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
	</xsl:for-each>
	<xsl:for-each select="differences/difference[@status='onlyin1']">
	  <xsl:call-template name="SQLRows">
	    <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
	</xsl:for-each>
  	<xsl:for-each select="differences/difference[@status='onlyin2']">
	  <xsl:call-template name="SQLRows">
	    <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
	</xsl:for-each>	
        <xsl:choose>
        <xsl:when test="$includeidenticals = 'true'">
	<xsl:for-each select="differences/difference[@status='equal']">
	  <xsl:call-template name="SQLRows">
	    <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
        </xsl:for-each>
	</xsl:when>
	</xsl:choose>
      </table>
    </p>
  </body>
</html>
</xsl:template>

<xsl:template name="nonSQLRows">
  <xsl:param name="node" select="."/>
  <xsl:param name="centerline"><xsl:text> </xsl:text></xsl:param>
  <xsl:variable name="anchor">
    <xsl:text></xsl:text>
    <xsl:choose>
      <xsl:when test="object[@id='1']/@owner = ''">
	<xsl:value-of select="object[@id='2']/@owner"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="object[@id='1']/@owner"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.</xsl:text>
    <xsl:choose>
      <xsl:when test="object[@id='1'] = ''">
	<xsl:value-of select="object[@id='2']"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="object[@id='1']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tr bgcolor="#FFFFFF">
    <td width="14%">
      <xsl:call-template name="objectTypeToString">
	<xsl:with-param name="node" select="." />
      </xsl:call-template>
    </td>
    <td width="12%"><xsl:value-of select="object[@id='1']/@owner"/></td>
    <td width="24%"><xsl:value-of select="object[@id='1']"/></td>
    <td width="3%" ><xsl:value-of select="$centerline"/></td>
    <td width="27%"><xsl:value-of select="object[@id='2']"/></td>
    <td width="12%"><xsl:value-of select="object[@id='2']/@owner"/></td>
    <td width="8%"><a name="{$anchor}" href="#{$anchor}.sql"><xsl:value-of select="$viewSQL"/>
    </a></td>
  </tr>
</xsl:template>

<xsl:template name="SQLRows">
  <xsl:param name="node" select="."/>
  <xsl:variable name="anchor">
    <xsl:text></xsl:text>
    <xsl:choose>
      <xsl:when test="object[@id='1']/@owner = ''">
	<xsl:value-of select="object[@id='2']/@owner"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="object[@id='1']/@owner"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.</xsl:text>
    <xsl:choose>
      <xsl:when test="object[@id='1'] = ''">
	<xsl:value-of select="object[@id='2']"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="object[@id='1']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tr bgcolor="#EEEEEE">
    <td width="8%">
      <xsl:call-template name="objectTypeToString">
	<xsl:with-param name="node" select="." />
      </xsl:call-template>
    </td>
    <td width="12%"><xsl:value-of select="object[@id='1']/@owner"/></td>
    <td width="27%"><xsl:value-of select="object[@id='1']"/></td>
    <td width="27%"><xsl:value-of select="object[@id='2']"/></td>
    <td width="12%"><xsl:value-of select="object[@id='2']/@owner"/></td>
    <td width="8%"><a name="{$anchor}.sql" href="#{$anchor}"><xsl:value-of select="$summary"/></a></td>
  </tr>
  <tr bgcolor="#FFFFFF">
    <td colspan ="6">
      <table width="100%">
	<xsl:for-each select="comparisonstrings/line">
	  <xsl:call-template name="doSQLLine">
	    <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
	</xsl:for-each>
      </table>
    </td>
  </tr>
</xsl:template>

<xsl:template name="doSQLLine">
  <xsl:param name="node" select="."/>
  <tr>
  <td width="45%"><xsl:value-of select="left" /></td>
    <td width="10%">
      <xsl:choose>
	<xsl:when test="@type='same'">
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>&lt;&gt;</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </td>
    <td width="45%"><xsl:value-of select="right" /></td>
  </tr>
</xsl:template>
    
</xsl:stylesheet>

