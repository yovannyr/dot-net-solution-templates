<?xml version='1.0'?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:redgate="http://red-gate.com/"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  exclude-result-prefixes="doc"
  version='1.0'>

<msxsl:script language="CSharp" implements-prefix="redgate">
<![CDATA[public string replacequotes(string str)
   {
	str = str.Replace("\\", "\\\\");
	str = str.Replace("\"", "\\\"");
	str = str.Replace("'", "\\'");

       return str;    
   }]]>
</msxsl:script>

<xsl:param name="SQLComparePath"><xsl:text>http://www.red-gate.com/scimages/</xsl:text></xsl:param>
<xsl:param name="includeidenticals"><xsl:text>true</xsl:text></xsl:param>

<xsl:param name="PageTitle"><xsl:text>SQL Compare Report:</xsl:text></xsl:param>
<xsl:param name="Type"><xsl:text>Type</xsl:text></xsl:param>
<xsl:param name="Owner"><xsl:text>Owner</xsl:text></xsl:param>
<xsl:param name="Object"><xsl:text>Object</xsl:text></xsl:param>
<xsl:param name="ObjectName"><xsl:text>Object Name</xsl:text></xsl:param>
<xsl:param name="Create"><xsl:text>&amp;nbsp;Create</xsl:text></xsl:param>
<xsl:param name="Drop"><xsl:text>&amp;nbsp;Drop</xsl:text></xsl:param>
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

<xsl:output method="html"
encoding="UTF-8"
indent="no"/>

<!-- ROOT ELEMENT -->
<xsl:template match="comparison">
  <html>
    <head>
	    <title><xsl:value-of select="$PageTitle"/></title>
      <style type="text/css">
      <![CDATA[
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.HeaderLeftCell {
}
.DatabaseNameText {
	font-family: Tahoma, Arial, sans-serif;
	font-size: 15px;
	font-weight: normal;
}
.ArrowImage {
position:absolute;
background-color:#f0f0f0;
top:0px; 
left:0;
width:64px;
height:64px;
z-index:2
}

.DBBack
{
position:absolute;
background-color:#f0f0f0;
top:0px; 
left:0px;
width:10px; 
height:50px;
}

.DatabaseImage {
position:absolute; 
top:12px; 
left:0px;
width:32px;
height:32px;
z-index:2;
}

.TitleBar {
	position:absolute;
	top:50px;
	left:0px;
	width:100%;
	height:20px;
	background-color:#ebeadb;
	z-index:3;
	font-family: Tahoma, Arial, sans-serif;
	font-size: 6pt;
}

.TitleBarTable
{
	background-color:#ebeadb;
	border: thin solid #dcdac0;
	font-family: Tahoma, Arial, sans-serif;
	font-size: 8.25pt;
}

.DifferenceBar
{
position:relative;
width:100%;
height:50px;
left:0;
top:70px;
}

.OnlyHereBar
{
position:absolute;
width:100%;
height:50px;
left:0;
top:120px;
}

.icon
{
width:32;
height:32;
top:79;
left:20;
position:absolute;
}

.OnlyHereIcon
{
width:32;
height:32;
top:129;
left:20;
position:absolute;
}

.dataRow
{
height:18px;
}

.DifferenceTable
{
position:absolute;
left:0;
top:100px;
}

.DifferentNum {
	font-family: Tahoma, Arial, sans-serif;
	font-size: 8.25pt;
	font-weight:bold;
	position:absolute;
	z-index:8;
}

.DifferentText {
	font-family: Tahoma, Arial, sans-serif;
	font-size: 8.25pt;
	font-weight:bold;
	position:absolute;
	z-index:1;
}

.SQL
{
	font-family: Tahoma, Arial, sans-serif;
	font-size: 8.25pt;
	font-weight:bold;
}

.SQLDiv{
	position:absolute;
	border: none;	
}
.dataTable{
	font-family: Tahoma, Arial, sans-serif;
	font-size: 8.25pt;
}

.TypeDataRow{
	text-align:right;
	vertical-align:top;
	border-top: 1px solid #ebeadb;
	border-right: 1px none #ebeadb;
	border-bottom: 1px solid #ebeadb;
	border-left: 1px solid #ebeadb;
	}


.MidDiffCell{
	text-align:center;
	vertical-align:top;
}

.TypeImageDataRow{
	text-align:left;
	vertical-align:top;
	border-top: 1px solid #ebeadb;
	border-right: 1px solid #ebeadb;
	border-bottom: 1px solid #ebeadb;
	border-left: 1px none #ebeadb;
}
.OwnerDataRow{	
	border: 1px solid #ebeadb;
	text-align:right;
}
.LObjNameDataRow{	
	border: 1px solid #ebeadb;
	text-align:right;
}
.IncDataRow{	
	border: 1px solid #ebeadb;
	text-align:center;
}

.RObjNameDataRow{	
	border: 1px solid #ebeadb;
}
.ROwnerDataRow{	
	border: 1px solid #ebeadb;
}
.SQLViewTitleBar{
	position:relative;
	width:100%;
	height:20px;
	background:#7a96df;
	font-family: Tahoma, Arial, sans-serif;
	font-size: 8.25pt;
	font-weight:bold;
	color: #FFFFFF;
}
-->
]]>
      </style>
      <script type="text/javascript">
	      <xsl:text>
  var includeidenticals = &quot;</xsl:text>
  <xsl:value-of select="$includeidenticals"/>
  <xsl:text>&quot;;
  </xsl:text>
	      <xsl:text>
  var imagesdir = &quot;http://www.red-gate.com/scimages/&quot;;
  </xsl:text>
  <!-- GET DIRECTION -->
  <xsl:text>
  var direction = &quot;</xsl:text>
  <xsl:value-of select="@direction"/>
  <xsl:text>&quot;;
  </xsl:text>
  <!-- GET TIMESTAMP -->
  <xsl:text>var timestamp = &quot;</xsl:text>
  <xsl:value-of select="@timestamp"/>
  <xsl:text>&quot;;</xsl:text>
  <xsl:apply-templates/>

  	<![CDATA[
// Program Segment

var Cache = new Array(
		new Array(), // DIfference Cache
		new Array(), // Left Hand only Cache
		new Array(), // Right Hand only Cache
		new Array());

var CurrentSelectedRow;

function getPageWidth()
{
	return document.body.clientWidth;
}

function IsImageOk(img)
{
    if (!img.complete)
        return false;

    if (typeof img.naturalWidth != "undefined" && img.naturalWidth == 0)
        return false;

    return true;
}


var ReservedWords = Array(
"ADD",
"ALL",
"ALTER",
"AND",
"ANY",
"AS",
"ASC",
"AUTHORIZATION",
"AVG",
"BACKUP",
"BEGIN",
"BETWEEN",
"BREAK",
"BROWSE",
"BULK",
"BY",
"CASCADE",
"CASE",
"CHECK",
"CHECKPOINT",
"CLOSE",
"CLUSTERED",
"COALESCE",
"COLUMN",
"COLLATE",
"COMMIT",
"COMMITTED",
"COMPUTE",
"CONFIRM",
"CONSTRAINT",
"CONTAINS",
"CONTAINSTABLE",
"CONTINUE",
"CONTROLROW",
"CONVERT",
"COUNT",
"CREATE",
"CROSS",
"CURRENT",
"CURRENT_DATE",
"CURRENT_TIME",
"CURRENT_TIMESTAMP",
"CURRENT_USER",
"CURSOR",
"DATABASE",
"DBCC",
"DEALLOCATE",
"DECLARE",
"DEFAULT",
"DELETE",
"DENY",
"DESC",
"DISK",
"DISTINCT",
"DISTRIBUTED",
"DOUBLE",
"DROP",
"DUMMY",
"DUMP",
"ELSE",
"END",
"ERRLVL",
"ERROREXIT",
"ESCAPE",
"EXCEPT",
"EXEC",
"EXECUTE",
"EXISTS",
"EXIT",
"FETCH",
"FILE",
"FILLFACTOR",
"FLOPPY",
"FOR",
"FOREIGN",
"FREETEXT",
"FREETEXTTABLE",
"FROM",
"FULL",
"GO",	
"GOTO",
"GRANT",
"GROUP",
"HAVING",
"HOLDLOCK",
"IDENTITY",
"IDENTITY_INSERT",
"IDENTITYCOL",
"IF",
"IN",
"INDEX",
"INNER",
"INSERT",
"INTERSECT",
"INTO",
"IS",
"ISOLATION",
"JOIN",
"KEY",
"KILL",
"LEFT",
"LEVEL",
"LIKE",
"LINENO",
"LOAD",
"MAX",
"MIN",
"MIRROREXIT",
"NATIONAL",
"NOCHECK",
"NONCLUSTERED",
"NOT",
"NULL",
"NULLIF",
"OF",
"OFF",
"OFFSETS",
"ON",
"ONCE",
"ONLY",
"OPEN",
"OPENDATASOURCE",
"OPENQUERY",
"OPENROWSET",
"OPTION",
"OR",
"ORDER",
"OUTER",
"OVER",
"PERCENT",
"PERM",
"PERMANENT",
"PIPE",
"PLAN",
"PRECISION",
"PREPARE",
"PRIMARY",
"PRINT",
"PRIVILEGES",
"PROC",
"PROCEDURE",
"PROCESSEXIT",
"PUBLIC",
"RAISERROR",
"READ",
"READTEXT",
"RECONFIGURE",
"REFERENCES",
"REPEATABLE",
"REPLICATION",
"RESTORE",
"RESTRICT",
"RETURN",
"REVOKE",
"RIGHT",
"ROLLBACK",
"ROWCOUNT",
"ROWGUIDCOL",
"RULE",
"SAVE",
"SCHEMA",
"SELECT",
"SERIALIZABLE",
"SESSION_USER",
"SET",
"SETUSER",
"SHUTDOWN",
"SOME",
"STATISTICS",
"SUM",
"SYSTEM_USER",
"TABLE",
"TAPE",
"TEMP",
"TEMPORARY",
"TEXTSIZE",
"THEN",
"TO",
"TOP",
"TRAN",
"TRANSACTION",
"TRIGGER",
"TRUNCATE",
"TSEQUAL",
"UNCOMMITTED",
"UNION",
"UNIQUE",
"UPDATE",
"UPDATETEXT",
"USE",
"USER",
"VALUES",
"VARYING",
"VIEW",
"WAITFOR",
"WHEN",
"WHERE",
"WHILE",
"WITH",
"WORK",
"WRITETEXT");

function isReservedWord(word)
{
	if(word.indexOf(",") > 0)
	{
		word = word.split(",")[0];
	}

	for(var i = 0; i < ReservedWords.length; i++)	
	{
	if(word == ReservedWords[i])
			return true;
	}

	return false;
}

function deleteRow(parent, child)
{
	parent.removeChild(child);
}
var wait;

function loadSQL(type, index)
{
	if(wait == true)
		return;

	if(type == 0)
	{
		sqlar = differencesql;
	}
	else if(type == 1)
	{
		sqlar = createsql;
	}
	else if(type == 2)
	{
		sqlar = dropsql;
	}
	else if(type == 3)
	{
		sqlar = identsql;
	}

	wait = true;
	var textArray;
	try
	{
		CurrentSelectedRow.style.background = "#FFFFFF";
	}
	catch(x)
	{}

	if(index > sqlar.length - 2)
	{
		textArray = sqlar[0];
	}
	else
	{
		textArray = sqlar[index + 1];
	}

	// Clear current comparison
	try
	{
		if(trsql.hasChildNodes() == true)
		{
			for(var p = trsql.childNodes.length - 1; p >= 0; p--)
			{	

				if (navigator.appName == "Microsoft Internet Explorer")
   				{
					trsql.childNodes[p].style.display = "none";
				}
				else
				{
					trsql.removeChild(trsql.childNodes[p]);
				}
			}
		}
	}
	catch(x)
	{
	}

	if(type == 0)
	{
		CurrentSelectedRow = difftable.rows[index];
		CurrentSelectedRow.style.background = "#fbef6b";
	}
	else if(type == 1)
	{
		CurrentSelectedRow = createtable.rows[index];
		CurrentSelectedRow.style.background = "#fbef6b";
	}
	else if(type == 2)
	{
		CurrentSelectedRow = droptable.rows[index];
		CurrentSelectedRow.style.background = "#fbef6b";
	}
	else if(type == 3)
	{
		CurrentSelectedRow = identtable.rows[index];
		CurrentSelectedRow.style.background = "#fbef6b";
	}


	if (navigator.appName == "Microsoft Internet Explorer")
	{
		if(Cache[type][index] != null )
		{
			Cache[type][index].style.display = "inline";
			Cache[type][index].top = 0;
			Cache[type][index].left = 0;
			wait = false;
			return;
		}
	}
	
	tablebod = document.createElement("TBODY");

	if (navigator.appName == "Microsoft Internet Explorer")
	{

		Cache[type][index] = tablebod;
	}

	// Iterate over lines of text
	for(var j = 0; j < textArray.length; j++)
	{
		currentRow = document.createElement("TR");
		currentLine = textArray[j];
	
		if(currentLine[0] == 0)
		{
			// Lines are the same
			var tokens = currentLine[1].split(" ");
			currentCell = document.createElement("TD");
			
			for(var k = 0; k < tokens.length; k++)
			{
				word = tokens[k];

				if(isReservedWord(word) == true)
				{
					fontnode = document.createElement("FONT");
					fontnode.color = "#0000FF";
					textnode = document.createTextNode(word + " ");
					fontnode.appendChild(textnode);
					currentCell.appendChild(fontnode);
				}
				else
				{
					childnode = document.createTextNode(word + " ");
					currentCell.appendChild(childnode);
				}
			}
			currentRow.appendChild(currentCell);

			currentCell = document.createElement("TD");
			currentCell.className = "MidDiffCell";
			childnode = document.createTextNode("&nbsp;");
			currentRow.appendChild(currentCell);
	

			currentCell = document.createElement("TD");

			
			for(var k = 0; k < tokens.length; k++)
			{
				word = tokens[k];

				if(isReservedWord(word) == true)
				{
					fontnode = document.createElement("FONT");
					fontnode.color = "#0000FF";
					textnode = document.createTextNode(word + " ");
					fontnode.appendChild(textnode);
					currentCell.appendChild(fontnode);
				}
				else
				{
					childnode = document.createTextNode(word + " ");
					currentCell.appendChild(childnode);
				}
			}
			currentRow.appendChild(currentCell);
	
			
		}
		else if(currentLine[0] == 1)
		{
			// Lines are the same
			var tokens = currentLine[1].split(" ");
			var othertokens = currentLine[2].split(" ");
			
			currentCell = document.createElement("TD");
	
			for(var k = 0; k < tokens.length; k++)
			{
				word = tokens[k];
				otherword = othertokens[k];
				if(word == otherword)
				{
					if(isReservedWord(word) == true)
					{
						fontnode = document.createElement("SPAN");
						fontnode.style.color = "#0000FF";
						textnode = document.createTextNode(word + " ");
						fontnode.appendChild(textnode);
						currentCell.appendChild(fontnode);
					}
					else
					{
						childnode = document.createTextNode(word + " ");
						currentCell.appendChild(childnode);
					}
				}
				else
				{
					if(isReservedWord(word) == true)
					{
						fontnode = document.createElement("SPAN");
						fontnode.style.color = "#0000FF";
						fontnode.style.background = "#99FF99";
						textnode = document.createTextNode(word + " ");
						fontnode.appendChild(textnode);
						currentCell.appendChild(fontnode);
					}
					else
					{
						fontnode = document.createElement("SPAN");
						fontnode.style.background = "#99FF99";
						textnode = document.createTextNode(word + " ");
						fontnode.appendChild(textnode);
						currentCell.appendChild(fontnode);
					}
					
				}
			}
			currentRow.appendChild(currentCell);

			currentCell = document.createElement("TD");
			currentCell.className = "MidDiffCell";
			imageNode = document.createElement("IMG");
			imageNode.src = imagesdir + "NotEquals16.gif";
			currentCell.appendChild(imageNode);
			currentRow.appendChild(currentCell);
	

			var tokens = currentLine[2].split(" ");
			var othertokens = currentLine[1].split(" ");

			currentCell = document.createElement("TD");
			
			for(var k = 0; k < tokens.length; k++)
			{
				word = tokens[k];
				otherword = othertokens[k];
				if(word == otherword)
				{
					if(isReservedWord(word) == true)
					{
						fontnode = document.createElement("SPAN");
						fontnode.style.color = "#0000FF";
						textnode = document.createTextNode(word + " ");
						fontnode.appendChild(textnode);
						currentCell.appendChild(fontnode);
					}
					else
					{
						childnode = document.createTextNode(word + " ");
						currentCell.appendChild(childnode);
					}
				}
				else
				{
					if(isReservedWord(word) == true)
					{
						fontnode = document.createElement("SPAN");
						fontnode.style.color = "#0000FF";
						fontnode.style.background = "#99FF99";
						textnode = document.createTextNode(word + " ");
						fontnode.appendChild(textnode);
						currentCell.appendChild(fontnode);
					}
					else
					{
						fontnode = document.createElement("SPAN");
						fontnode.style.background = "#99FF99";
						textnode = document.createTextNode(word + " ");
						fontnode.appendChild(textnode);
						currentCell.appendChild(fontnode);
					}
					
				}
			}
			currentRow.appendChild(currentCell);

		}

		tablebod.appendChild(currentRow);
	}

	trsql.appendChild(tablebod);

	doLayout();
	wait = false;
}

function swapImage(barname)
{
	if(barname == "diff")
	{
		if(difftable.style.display == 'none')
		{
			differenceexpandbuttonimage.src = imagesdir + "Contract32.gif";
			difftable.style.display = 'block';
		}
		else
		{
			differenceexpandbuttonimage.src = imagesdir + "Expand32.gif";
			difftable.style.display = 'none';		
		}
		
		
		doLayout();
	}
	else if(barname == "create")
	{
		
		if(createtable.style.display == 'none')
		{
			onlyhereexpandbuttonimage.src = imagesdir + "Contract32.gif";
			createtable.style.display = 'block';
		}
		else
		{
			onlyhereexpandbuttonimage.src = imagesdir + "Expand32.gif";
			createtable.style.display = 'none';		
		}
		
		
		doLayout();
	}
	else if(barname == "drop")
	{
		
		if(droptable.style.display == 'none')
		{
			dropexpandbuttonimage.src = imagesdir + "Contract32.gif";
			droptable.style.display = 'block';
		}
		else
		{
			dropexpandbuttonimage.src = imagesdir + "Expand32.gif";
			droptable.style.display = 'none';		
		}
		
		
		doLayout();
	}
	else if(barname == "ident")
	{
		
		if(identtable.style.display == 'none')
		{
			identexpandbuttonimage.src = imagesdir + "Contract32.gif";
			identtable.style.display = 'block';
		}
		else
		{
			identexpandbuttonimage.src = imagesdir + "Expand32.gif";
			identtable.style.display = 'none';		
		}
		
		
		doLayout();
	}

	doLayout();


}

function getPageHeight()
{
	return document.body.clientHeight;
}

function createTables()
{
	arrimg.src = imagesdir+"RightArrow48.gif";
	dbimgimg.src = imagesdir + "LeftDatabase32.gif";
	dbrimgimg.src = imagesdir + "RightDatabase32.gif";
	difftitleimg.src = imagesdir + "wbgrad.gif";
	differenceexpandbuttonimage.src = imagesdir + "Expand32.gif";
	onlyhereexpandbuttonimage.src = imagesdir + "Expand32.gif";
	dropexpandbuttonimage.src = imagesdir + "Expand32.gif";
	identexpandbuttonimage.src = imagesdir + "Expand32.gif";

	datetimetext = document.createTextNode("]]><xsl:value-of select="$PageTitle"/><![CDATA[" + timestamp);
	datetime.appendChild(datetimetext);

	if(includeidenticals != "true")
	{
		identtext.style.display = "none";
		identnum.style.display = "none";
		identtab.style.display = "none";
		identtitlebar.style.display = "none";
		identexpandbutton.style.display = "none";
	}

	dbsvr.appendChild(document.createTextNode(datasource1server+" ( "+datasource1type+" ) "));
	dbname.appendChild(document.createTextNode(datasource1database));
	dbrsvr.appendChild(document.createTextNode(datasource2server+" ( "+datasource2type+" ) "));
	dbrname.appendChild(document.createTextNode(datasource2database));

	if(direction == "2to1")
	{
		// Swap colors of create a drop
		onlyheretitlebarimg.src = imagesdir + "wpgradient.gif";
		droptitlebarimg.src = imagesdir + "wggrad.gif";
		createTxt = document.createTextNode("]]><xsl:value-of select="$Create"/><![CDATA[");
		dropTxt= document.createTextNode("]]><xsl:value-of select="$Drop"/><![CDATA[");
		createtext.appendChild(dropTxt);
		droptext.appendChild(createTxt);
		arrimg.src = imagesdir + "LeftArrow48.gif";	
	}
	else
	{
		onlyheretitlebarimg.src = imagesdir + "wggrad.gif";
		droptitlebarimg.src = imagesdir + "wpgradient.gif";
		createTxt = document.createTextNode("]]><xsl:value-of select="$Create"/><![CDATA[");
		dropTxt= document.createTextNode("]]><xsl:value-of select="$Drop"/><![CDATA[");
		createtext.appendChild(createTxt);
		droptext.appendChild(dropTxt);
	}
	
	// Creates the drop down tables from the data segment
	// DIFFERENCE TABLE VARIABLE IS difftable

	differentcounttext = document.createTextNode(differenceRows.length);
	differentnum.appendChild(differentcounttext);

	// Difference TABLE 
	mytablebody = document.createElement("TBODY");
	for(j=0; j < differenceRows.length; j++) 
	{
	    	row=document.createElement("TR");

		row.index = j;
		row.onmouseover = function()
		{ 	
			var numDiffRows = difftable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(difftable.rows[i] != CurrentSelectedRow)
					difftable.rows[i].style.background="#FFFFFF";			
			}

			if(difftable.rows[this.index] != CurrentSelectedRow)
				difftable.rows[this.index].style.background="#fff9c5";
		};

		row.onmouseout = function()
		{
			var numDiffRows = difftable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(difftable.rows[i] != CurrentSelectedRow)
					difftable.rows[i].style.background="#FFFFFF";			
			}

		};

		row.onclick = function(){loadSQL(0, this.index);};
		row.className = "dataRow";

		typecell = document.createElement("TD");
		typecell.className = "TypeDataRow";

		typetext = getTextFromObjectID(differenceRows[j][0]);

		typetextnode = document.createTextNode(typetext);
		typecell.appendChild(typetextnode);
		row.appendChild(typecell);

		typeimagecell = document.createElement("TD");
		typeimagecell.className =  "TypeImageDataRow";
		typeimageimage = document.createElement("IMG");
		tableimgsrc = imagesdir + getImageFromObjectID(differenceRows[j][0]);
		typeimageimage.setAttribute("src", tableimgsrc);
		typeimagecell.appendChild(typeimageimage);
		row.appendChild(typeimagecell);

	        lownerdatarowcell = document.createElement("TD");
		lownerdatarowcell.className =  "OwnerDataRow";
		lownerdatarowtext = document.createTextNode(differenceRows[j][1]);
		lownerdatarowcell.appendChild(lownerdatarowtext);
		row.appendChild(lownerdatarowcell);

		lobjnamecell = document.createElement("TD");
		lobjnamecell.className = "LObjNameDataRow";
		lobjnamecell.style["text-align"]="right";
		lobjnametext = document.createTextNode(differenceRows[j][2]);
		lobjnamecell.appendChild(lobjnametext);
		row.appendChild(lobjnamecell);

		inccell = document.createElement("TD");
		inccell.className =  "IncDataRow";
		inccell.style["text-align"]="center";
		inccellimg = document.createElement("IMG");
		inccellimg.setAttribute("src", imagesdir + "NotEquals16.gif");
		inccell.appendChild(inccellimg);
		row.appendChild(inccell);

		robjnamecell = document.createElement("TD");
		robjnamecell.className =  "RObjNameDataRow";
		robjnametext = document.createTextNode(differenceRows[j][3]);
		robjnamecell.appendChild(robjnametext);
		row.appendChild(robjnamecell);

	        rownerdatarowcell = document.createElement("TD");
		rownerdatarowcell.className = "ROwnerDataRow";
		rownerdatarowtext = document.createTextNode(differenceRows[j][4]);
		rownerdatarowcell.appendChild(rownerdatarowtext);
		row.appendChild(rownerdatarowcell);

		mytablebody.appendChild(row);
	}
						
	difftable.appendChild(mytablebody);


	createcounttext = document.createTextNode(onlyInOneRows.length);
	createnum.appendChild(createcounttext);

	mytablebody = document.createElement("TBODY");
	for(j=0; j < onlyInOneRows.length; j++) 
	{
	    	row=document.createElement("TR");

		row.index = j;
		row.onmouseover = function()
		{ 	
			var numDiffRows = createtable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(createtable.rows[i] != CurrentSelectedRow)
					createtable.rows[i].style.background="#FFFFFF";			
			}

			if(createtable.rows[this.index] != CurrentSelectedRow)
				createtable.rows[this.index].style.background="#fff9c5";
		};

		row.onmouseout = function()
		{
			var numDiffRows = createtable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(createtable.rows[i] != CurrentSelectedRow)
					createtable.rows[i].style.background="#FFFFFF";			
			}

		};

		row.onclick = function(){loadSQL(1, this.index);};
		row.className = "dataRow";

		typecell = document.createElement("TD");
		typecell.className = "TypeDataRow";

		typetext = getTextFromObjectID(onlyInOneRows[j][0]);

		typetextnode = document.createTextNode(typetext);
		typecell.appendChild(typetextnode);
		row.appendChild(typecell);

		typeimagecell = document.createElement("TD");
		typeimagecell.className =  "TypeImageDataRow";
		typeimageimage = document.createElement("IMG");
		typeimageimage.setAttribute("src", imagesdir + getImageFromObjectID(onlyInOneRows[j][0]));
		typeimagecell.appendChild(typeimageimage);
		row.appendChild(typeimagecell);

	        lownerdatarowcell = document.createElement("TD");
		lownerdatarowcell.className =  "OwnerDataRow";
		lownerdatarowtext = document.createTextNode(onlyInOneRows[j][1]);
		lownerdatarowcell.appendChild(lownerdatarowtext);
		row.appendChild(lownerdatarowcell);

		lobjnamecell = document.createElement("TD");
		lobjnamecell.className = "LObjNameDataRow";
		lobjnamecell.style["text-align"]="right";
		lobjnametext = document.createTextNode(onlyInOneRows[j][2]);
		lobjnamecell.appendChild(lobjnametext);
		row.appendChild(lobjnamecell);

		inccell = document.createElement("TD");
		inccell.className =  "IncDataRow";
		inccell.style["text-align"]="center";
		inccellimg = document.createElement("IMG");
		if(direction == "2to1")
		{
			inccellimg.setAttribute("src", imagesdir + "drop.gif");
		}
		else
		{
			inccellimg.setAttribute("src", imagesdir + "RightArrow16.gif");
		}
		inccell.appendChild(inccellimg);
		row.appendChild(inccell);

		robjnamecell = document.createElement("TD");
		robjnamecell.className =  "RObjNameDataRow";
		robjnametext = document.createTextNode(onlyInOneRows[j][4]);
		robjnamecell.appendChild(robjnametext);
		row.appendChild(robjnamecell);

	        rownerdatarowcell = document.createElement("TD");
		rownerdatarowcell.className = "ROwnerDataRow";
		rownerdatarowtext = document.createTextNode(onlyInOneRows[j][4]);
		rownerdatarowcell.appendChild(rownerdatarowtext);
		row.appendChild(rownerdatarowcell);

		mytablebody.appendChild(row);
	}

	createtable.appendChild(mytablebody);

	dropcounttext = document.createTextNode(onlyInTwoRows.length);
	dropnum.appendChild(dropcounttext);

	mytablebody = document.createElement("TBODY");
	for(j=0; j < onlyInTwoRows.length; j++) 
	{
	    	row=document.createElement("TR");

		row.index = j;
		row.onmouseover = function()
		{ 	
			var numDiffRows = droptable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(droptable.rows[i] != CurrentSelectedRow)
					droptable.rows[i].style.background="#FFFFFF";			
			}

			if(droptable.rows[this.index] != CurrentSelectedRow)
				droptable.rows[this.index].style.background="#fff9c5";
		};

		row.onmouseout = function()
		{
			var numDiffRows = droptable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(droptable.rows[i] != CurrentSelectedRow)
					droptable.rows[i].style.background="#FFFFFF";			
			}

		};

		row.onclick = function(){loadSQL(2, this.index);};
		row.className = "dataRow";

		typecell = document.createElement("TD");
		typecell.className = "TypeDataRow";

		typetext = getTextFromObjectID(onlyInTwoRows[j][0]);
		

		typetextnode = document.createTextNode(typetext);
		typecell.appendChild(typetextnode);
		row.appendChild(typecell);

		typeimagecell = document.createElement("TD");
		typeimagecell.className =  "TypeImageDataRow";
		typeimageimage = document.createElement("IMG");
		typeimageimage.setAttribute("src", imagesdir + getImageFromObjectID(onlyInTwoRows[j][0]));
		typeimagecell.appendChild(typeimageimage);
		row.appendChild(typeimagecell);

	        lownerdatarowcell = document.createElement("TD");
		lownerdatarowcell.className =  "OwnerDataRow";
		lownerdatarowtext = document.createTextNode(onlyInTwoRows[j][1]);
		lownerdatarowcell.appendChild(lownerdatarowtext);
		row.appendChild(lownerdatarowcell);

		lobjnamecell = document.createElement("TD");
		lobjnamecell.className = "LObjNameDataRow";
		lobjnamecell.style["text-align"]="right";
		lobjnametext = document.createTextNode(onlyInTwoRows[j][2]);
		lobjnamecell.appendChild(lobjnametext);
		row.appendChild(lobjnamecell);

		inccell = document.createElement("TD");
		inccell.className =  "IncDataRow";
		inccell.style["text-align"]="center";
		inccellimg = document.createElement("IMG");
		if(direction == "2to1")
		{
			inccellimg.setAttribute("src", imagesdir + "LeftArrow16.gif");
		}
		else
		{
			inccellimg.setAttribute("src", imagesdir + "drop.gif");
		}
		
		inccell.appendChild(inccellimg);
		row.appendChild(inccell);

		robjnamecell = document.createElement("TD");
		robjnamecell.className =  "RObjNameDataRow";
		robjnametext = document.createTextNode(onlyInTwoRows[j][3]);
		robjnamecell.appendChild(robjnametext);
		row.appendChild(robjnamecell);

	        rownerdatarowcell = document.createElement("TD");
		rownerdatarowcell.className = "ROwnerDataRow";
		rownerdatarowtext = document.createTextNode(onlyInTwoRows[j][4]);
		rownerdatarowcell.appendChild(rownerdatarowtext);
		row.appendChild(rownerdatarowcell);

		mytablebody.appendChild(row);
	}

	droptable.appendChild(mytablebody);

	identcounttext = document.createTextNode(identRows.length);
	identnum.appendChild(identcounttext);

	mytablebody = document.createElement("TBODY");
	for(j=0; j < identRows.length; j++) 
	{
	    	row=document.createElement("TR");

		row.index = j;
		row.onmouseover = function()
		{ 	
			var numDiffRows = identtable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(identtable.rows[i] != CurrentSelectedRow)
					identtable.rows[i].style.background="#FFFFFF";			
			}

			if(identtable.rows[this.index] != CurrentSelectedRow)
				identtable.rows[this.index].style.background="#fff9c5";
		};

		row.onmouseout = function()
		{
			var numDiffRows = identtable.rows.length;
			for(var i = 0; i < numDiffRows; i++)
			{
				if(identtable.rows[i] != CurrentSelectedRow)
					identtable.rows[i].style.background="#FFFFFF";			
			}

		};

		row.onclick = function(){loadSQL(3, this.index);};
		row.className = "dataRow";

		typecell = document.createElement("TD");
		typecell.className = "TypeDataRow";

		typetext = getTextFromObjectID(identRows[j][0]);

		typetextnode = document.createTextNode(typetext);
		typecell.appendChild(typetextnode);
		row.appendChild(typecell);

		typeimagecell = document.createElement("TD");
		typeimagecell.className =  "TypeImageDataRow";
		typeimageimage = document.createElement("IMG");
		typeimageimage.setAttribute("src", imagesdir + getImageFromObjectID(identRows[j][0]));
		typeimagecell.appendChild(typeimageimage);
		row.appendChild(typeimagecell);

	        lownerdatarowcell = document.createElement("TD");
		lownerdatarowcell.className =  "OwnerDataRow";
		lownerdatarowtext = document.createTextNode(identRows[j][1]);
		lownerdatarowcell.appendChild(lownerdatarowtext);
		row.appendChild(lownerdatarowcell);

		lobjnamecell = document.createElement("TD");
		lobjnamecell.className = "LObjNameDataRow";
		lobjnamecell.style["text-align"]="right";
		lobjnametext = document.createTextNode(identRows[j][2]);
		lobjnamecell.appendChild(lobjnametext);
		row.appendChild(lobjnamecell);

		inccell = document.createElement("TD");
		inccell.className =  "IncDataRow";
		inccell.style["text-align"]="center";
		inccellimg = document.createElement("IMG");
		inccellimg.setAttribute("src", imagesdir + "Equals.gif");
		inccell.appendChild(inccellimg);
		row.appendChild(inccell);

		robjnamecell = document.createElement("TD");
		robjnamecell.className =  "RObjNameDataRow";
		robjnametext = document.createTextNode(identRows[j][3]);
		robjnamecell.appendChild(robjnametext);
		row.appendChild(robjnamecell);

	        rownerdatarowcell = document.createElement("TD");
		rownerdatarowcell.className = "ROwnerDataRow";
		rownerdatarowtext = document.createTextNode(identRows[j][4]);
		rownerdatarowcell.appendChild(rownerdatarowtext);
		row.appendChild(rownerdatarowcell);

		mytablebody.appendChild(row);
	}

	identtable.appendChild(mytablebody);

	difftitleimg.src = imagesdir + "wbgrad.gif";
	onlyheretitlebarimg.src = imagesdir + "wggrad.gif";
	droptitlebarimg.src = imagesdir + "wpgradient.gif";
	identtitlebarimg.src = imagesdir + "wggradient.gif";

	
}

function pageInit()
{
	SetupImagesDir();
	createTables();
	doLayout();
}

function SetupImagesDir()
{
	var imageRootPath = "]]><xsl:value-of select="$SQLComparePath"/><![CDATA[";

	imagesdir = "file://"+imageRootPath+"/Reporting/images/";
	
	var img = new Image();
	img.src  = imagesdir + "wbgrad.gif";
	for(var i = 0; i < 10000; i++)
	{ ; } //Horrible busy wait	

	if (!IsImageOk(img))
	{
		imagesdir = "http://www.red-gate.com/scimages/";
	}
		
}
	

function doLayout()
{
	var pageHeight = getPageHeight();
	var pageWidth = getPageWidth();
	var centrePoint = pageWidth/2;

	// Arrow Image
	arimg.style.left = centrePoint - 32;
	
	// Blue to white background
	dbbg.style.width = centrePoint-20;
	
	// white to red background
	dbrbg.style.left = centrePoint + 20;
	dbrbg.style.width = centrePoint-20;
	
	// left hand server name
	dbsvr.style.left = 0;
	dbsvr.style.width = centrePoint - 74;
	
	// left hand name
	dbname.style.left = 0;
	dbname.style.width = centrePoint - 74;
	
	// left hand server image
	dbimg.style.left = centrePoint - 74;
	
	// Right hand server name
	dbrsvr.style.left = centrePoint + 72;
	dbrsvr.style.width = centrePoint - 72;
	
	// Right hand database name
	dbrname.style.left = centrePoint + 72;
	dbrname.style.width = centrePoint - 72;
	
	// Right hand image
	dbrimg.style.left = centrePoint + 32;
	
	// Header table row
	typehdr.style.width = 100;
	lownerhdr.style.width = 100;
	lobjnamehdr.style.width = centrePoint - 250;
	inchdr.style.width = 70;
	robjnamehdr.style.width = centrePoint - 230;
	rownerhdr.style.width = 200;

	differencetitlebar.style.top = 0;
	differenceexpandbutton.style.top = 9;
	
	// Text which appears in different header
	differenttext.style.top = 10;
	differenttext.style.left = centrePoint - 30;
	differenttext.style.width = 70;
	differenttext.style["text-align"] = 'center';
	differentnum.style.top = 30;
	differentnum.style.left = centrePoint - 10;
	
	// Position of top of different table
	difftab.style.top = 50;
	
	// Used to compute offsets for other tabs
	var offset = 0;

	if(difftable.style.display == 'block')
	{
		var numDiffRows = difftable.rows.length;

		offset = (22 * numDiffRows);

		for(var i = 0; i < numDiffRows; i++)
		{
			switch(differenceRows[i][0])
			{
				case 2:
				case 5:
				case 6:
				case 10:
				case 15:
				case 16:
				case 21:
				case 22:
				case 23:
				case 27:
					offset = offset + 10;			
			}
			difftable.rows[i].cells[0].style.width = 80;
			difftable.rows[i].cells[1].style.width = 16;
			difftable.rows[i].cells[2].style.width = 100;
			difftable.rows[i].cells[3].style.width = centrePoint - 250;
			difftable.rows[i].cells[4].style.width = 70;
			difftable.rows[i].cells[5].style.width = centrePoint - 230;
			difftable.rows[i].cells[6].style.width = 200;
		}
	}

	onlyheretitlebar.style.top = 50 + offset;
	onlyhereexpandbutton.style.top = 59 + offset;
	
	// Text which appears in different header
	createtext.style.top = 60 + offset;
	if(direction == "2to1")
	{
		createtext.style.left = centrePoint - 20;
	}
	else
	{
		createtext.style.left = centrePoint - 22;
	}
	createtext.style.width = 70;
	createtext.style.align = 'center';
	createtext.style["text-align"] = 'right';
	createnum.style.top = 80 + offset;
	createnum.style.left = centrePoint - 10;
	
	// Position of top of different table
	createtab.style.top = 100 + offset;
	
	// Used to compute offsets for other tabs

	if(createtable.style.display == 'block')
	{
		var numDiffRows = createtable.rows.length;

		offset = offset + (22 * numDiffRows);

		for(var i = 0; i < numDiffRows; i++)
		{
			switch(onlyInOneRows[i][0])
			{
				case 2:
				case 5:
				case 6:
				case 10:
				case 15:
				case 16:
				case 21:
				case 22:
				case 23:
				case 27:
					offset = offset + 10;			
			}
			createtable.rows[i].cells[0].style.width = 80;
			createtable.rows[i].cells[1].style.width = 16;
			createtable.rows[i].cells[2].style.width = 100;
			createtable.rows[i].cells[3].style.width = centrePoint - 250;
			createtable.rows[i].cells[4].style.width = 70;
			createtable.rows[i].cells[5].style.width = centrePoint - 230;
			createtable.rows[i].cells[6].style.width = 200;
		}
	}

	droptitlebar.style.top = 100 + offset;
	dropexpandbutton.style.top = 109 + offset;

	droptext.style.top = 110 + offset;
	droptext.style.left = centrePoint - 30;
	dropnum.style.top = 130 + offset;
	dropnum.style.left = centrePoint - 10;
	if(direction == "2to1")
	{
		droptext.style.left = centrePoint - 22;
	}
	else
	{
		droptext.style.left = centrePoint - 20;
	}

	droptab.style.top = 150 + offset;

	if(droptable.style.display == 'block')
	{
		var numDiffRows = droptable.rows.length;

		offset = offset + (22 * numDiffRows);

		for(var i = 0; i < numDiffRows; i++)
		{
			switch(onlyInTwoRows[i][0])
			{
				case 2:
				case 5:
				case 6:
				case 10:
				case 15:
				case 16:
				case 21:
				case 22:
				case 23:
				case 27:
					offset = offset + 10;			
			}
			droptable.rows[i].cells[0].style.width = 80;
			droptable.rows[i].cells[1].style.width = 16;
			droptable.rows[i].cells[2].style.width = 100;
			droptable.rows[i].cells[3].style.width = centrePoint - 250;
			droptable.rows[i].cells[4].style.width = 70;
			droptable.rows[i].cells[5].style.width = centrePoint - 230;
			droptable.rows[i].cells[6].style.width = 200;
		}
	}

	identtitlebar.style.top = 150 + offset;
	identexpandbutton.style.top = 159 + offset;

	identtext.style.top = 160 + offset;
	identtext.style.left = centrePoint - 30;
	
	identnum.style.top = 180 + offset;
	identnum.style.left = centrePoint - 10;
	
	identtab.style.top = 200 + offset;

	if(identtable.style.display == 'block')
	{
		var numDiffRows = identtable.rows.length;

		offset = offset + (22 * numDiffRows);

		for(var i = 0; i < numDiffRows; i++)
		{
			switch(identRows[i][0])
			{
				case 2:
				case 5:
				case 6:
				case 10:
				case 15:
				case 16:
				case 21:
				case 22:
				case 23:
				case 27:
					offset = offset + 10;
					break;
			}
			identtable.rows[i].cells[0].style.width = 80;
			identtable.rows[i].cells[1].style.width = 16;
			identtable.rows[i].cells[2].style.width = 100;
			identtable.rows[i].cells[3].style.width = centrePoint - 250;
			identtable.rows[i].cells[4].style.width = 70;
			identtable.rows[i].cells[5].style.width = centrePoint - 230;
			identtable.rows[i].cells[6].style.width = 200;
		}
	}
	
	
	for(var j = 0; j < trsql.rows.length; j++)
	{
		trsql.rows[j].cells[0].style.width = centrePoint - 10;
		trsql.rows[j].cells[1].style.width = 70;
		trsql.rows[j].cells[2].style.width = centrePoint - 35;
	}

	sqldiv.style.top = pageHeight - 250;
	sqldiv.style.height = 250;

	toppanel.style.height = pageHeight - 345;	
	

}

function getTextFromObjectID(id)
{
	switch(id)
	{
		case 1:
		    return "]]><xsl:value-of select="$Table"/><![CDATA[";
		    break;
		case 2:
		    return "]]><xsl:value-of select="$StoredProcedure"/><![CDATA[";
		    break;
		case 3:
		    return "]]><xsl:value-of select="$View"/><![CDATA[";
		    break;
		case 4:
		    return "]]><xsl:value-of select="$Default"/><![CDATA[";
		    break;
		case 5:
		    return "]]><xsl:value-of select="$FTC"/><![CDATA[";
		    break;
		case 6:
		    return "]]><xsl:value-of select="$UDF"/><![CDATA[";
		    break;
		case 7:
		    return "]]><xsl:value-of select="$Role"/><![CDATA[";
		    break;
		case 8:
		    return "]]><xsl:value-of select="$Rule"/><![CDATA[";
		    break;
		case 9:
		    return "]]><xsl:value-of select="$User"/><![CDATA[";
		    break;
		case 10:
		    return "]]><xsl:value-of select="$UDT"/><![CDATA[";
		    break;
		case 12:
		    return "]]><xsl:value-of select="$DdlTrigger"/><![CDATA[";
		    break;
		case 13:
		    return "]]><xsl:value-of select="$Assembly"/><![CDATA[";
		    break;
		case 14:
		    return "]]><xsl:value-of select="$Synonym"/><![CDATA[";
		    break;		    
		case 15:
		    return "]]><xsl:value-of select="$XmlSchemaCollection"/><![CDATA[";
		    break;
		case 16:
		    return "]]><xsl:value-of select="$MessageType"/><![CDATA[";
		    break;
		case 17:
		    return "]]><xsl:value-of select="$Contract"/><![CDATA[";
		    break;
		case 18:
		    return "]]><xsl:value-of select="$Queue"/><![CDATA[";
		    break;
		case 19:
		    return "]]><xsl:value-of select="$Service"/><![CDATA[";
		    break;
		case 20:
		    return "]]><xsl:value-of select="$Route"/><![CDATA[";
		    break;
		case 21:
		    return "]]><xsl:value-of select="$EventNotification"/><![CDATA[";
		    break;
		case 22:
		    return "]]><xsl:value-of select="$PartitionScheme"/><![CDATA[";
		    break;
		case 23:
		    return "]]><xsl:value-of select="$PartitionFunction"/><![CDATA[";
		    break;
		case 26:
		    return "]]><xsl:value-of select="$Schema"/><![CDATA[";
		    break;
		case 27:
		    return "]]><xsl:value-of select="$ServiceBinding"/><![CDATA[";
		    break;
		case 28:
		    return "]]><xsl:value-of select="$Certificate"/><![CDATA[";
		    break;
		case 29:
		    return "]]><xsl:value-of select="$SymmetricKey"/><![CDATA[";
		    break;
		case 30:
		    return "]]><xsl:value-of select="$AsymmetricKey"/><![CDATA[";
		    break;
		case 31:
		    return "]]><xsl:value-of select="$FTS"/><![CDATA[";
		    break;
	}
}

function getImageFromObjectID(id)
{
	switch(id)
	{
		case 1:
		    return "Tables.gif";
		    break;
		case 2:
		    return "StoredProcedures.gif";
		    break;
		case 3:
		    return "Views.gif";
		    break;
		case 4:
		    return "Defaults.gif";
		    break;
		case 5:
		    return "FullTextCatalogs.gif";
		    break;
		case 6:
		    return "UserDefinedFunctions.gif";
		    break;
		case 7:
		    return "Roles.gif";
		    break;
		case 8:
		    return "Rules.gif";
		    break;
		case 9:
		    return "Users.gif";
		    break;
		case 10:
		    return "UserDefinedTypes.gif";
		    break;
		case 11:
		    return "YukonDefault.gif";
		    break;
		case 12:
		    return "DdlTriggers.gif";
		    break;
		case 13:
		    return "Assemblies.gif";
		    break;
		case 14:
		    return "Synonyms.gif";
		    break;		    
		case 15:
		    return "XmlSchemaCollections.gif";
		    break;
		case 16:
		    return "MessageTypes.gif";
		    break;
		case 17:
		    return "Contracts.gif";
		    break;
		case 18:
		    return "Queues.gif";
		    break;
		case 19:
		    return "Services.gif";
		    break;
		case 20:
		    return "Routes.gif";
		    break;
		case 21:
		    return "EventNotifications.gif";
		    break;
		case 22:
		    return "PartitionSchemes.gif";
		    break;
		case 23:
		    return "PartitionFunctions.gif";
		    break;
		case 26:
		    return "Schemas.gif";
		    break;
		case 27:
		    return "ServiceBindings.gif";
		    break;
		case 28:
		    return "Certificates.gif";
		    break;
		case 29:
		    return "SymmetricKeys.gif";
		    break;
		case 30:
		    return "AsymmetricKeys.gif";
		    break;
		case 31:
		    return "FullTextStoplists.gif";
		    break;
		case 99:
		    return "YukonDefault.gif";
		break;
	}
}


//-->
	
	]]>
      </script>
<noscript>
	<div style="position:absolute; left:0px; top:0px; width:100%; height:100%; z-index:20"><xsl:value-of select="$enablescript"/></div>
</noscript>

</head>
<body onLoad="pageInit()" onResize="doLayout()">
		<div id="datetime" class="DatabaseNameText" style="position:absolute; border-bottom: 1px solid #ebeadb;text-align:center; font-weight:bold; left:0px; top:0px; z-index:8; width:100%; height:24;">
		</div>
		<div style="position:absolute;top:25;width:100%">
      
  <div id="arimg" class="ArrowImage"><img id="arrimg" src="images/RightArrow48.gif" /></div>
  <div id="dbbg" class="DBBack"></div>
  <div id="dbrbg" class="DBBack"></div>
<div id="dbsvr" class="DatabaseNameText" style="position:absolute; top:8px; left:0px; width:44%; text-align:right"></div>
<div id="dbname" class="DatabaseNameText" style="position:absolute; font-weight:bold; top:30px; left:0px; width:44%; text-align:right"></div>
<div id="dbimg" class="DatabaseImage"><img id="dbimgimg" style="width:100%; height:100%" src="images/LeftDatabase32.gif" /></div>
<div id="dbrsvr" class="DatabaseNameText" style="position:absolute; top:8px; left:55%; width:44%; text-align:left"></div>
<div id="dbrname" class="DatabaseNameText" style="position:absolute; font-weight:bold; top:30px; left:55%; width:44%; text-align:left"></div>
<div id="dbrimg" class="DatabaseImage"><img id="dbrimgimg" style="height:34px; width:32px" src="images/RightDatabase32.gif" /></div>

<div id="titlebar" class="TitleBar"><table cellpadding="2" cellspacing="0" style="width:100%; height:20px;"><tr><td id="typehdr" class="TitleBarTable"><xsl:value-of select="$Type"/></td><td id="lownerhdr" class="TitleBarTable" style="text-align:right"><xsl:value-of select="$Owner"/></td><td id="lobjnamehdr" style="text-align:right" class="TitleBarTable"><xsl:value-of select="$ObjectName"/></td><td id="inchdr" style="text-align:center" class="TitleBarTable"><xsl:text disable-output-escaping="yes"><![CDATA[
	&nbsp;
	]]></xsl:text></td><td id="robjnamehdr" class="TitleBarTable"><xsl:value-of select="$ObjectName"/></td><td id="rownerhdr" class="TitleBarTable"><xsl:value-of select="$Owner"/></td></tr></table></div>
</div>
<div id="toppanel" style="overflow: auto; left:0; top:95; position:relative;">
  <div id="differencetitlebar" class="DifferenceBar"><img id="difftitleimg" style="width:100%; height:100%" src="images/wbgrad.gif" /></div>
  <div id="differenceexpandbutton" class="icon"><img id="differenceexpandbuttonimage" onClick="swapImage('diff')" style="width:100%;height:100%" src="images/Expand32.gif" /></div>

  <div id="onlyheretitlebar" class="OnlyHereBar"><img id="onlyheretitlebarimg" style="width:100%; height:100%" src="images/wggrad.gif" /></div>
  <div id="onlyhereexpandbutton" class="OnlyHereIcon"><img style="width:100%;height:100%" id="onlyhereexpandbuttonimage" onClick="swapImage('create')" src="images/Expand32.gif" /></div>

  <div id="droptitlebar" class="OnlyHereBar"><img id="droptitlebarimg" style="width:100%; height:100%" src="images/wpgradient.gif" /></div>
  <div id="dropexpandbutton" class="OnlyHereIcon"><img style="width:100%;height:100%" id="dropexpandbuttonimage" onClick="swapImage('drop')" src="images/Expand32.gif" /></div>

  <div id="identtitlebar" class="OnlyHereBar"><img id="identtitlebarimg" style="width:100%; height:100%" src="images/wggradient.gif" /></div>
  <div id="identexpandbutton" class="OnlyHereIcon"><img style="width:100%;height:100%" id="identexpandbuttonimage" onClick="swapImage('ident')" src="images/Expand32.gif"/></div>

<div id="differenttext" class="DifferentText"><xsl:value-of select="$Different"/></div>
<div id="differentnum" class="DifferentNum"></div>

<div id="createtext" class="DifferentText"></div>
<div id="createnum" class="DifferentNum"></div>

<div id="droptext" class="DifferentText"></div>
<div id="dropnum" class="DifferentNum"></div>

<div id="identtext" class="DifferentText"><xsl:value-of select="$Identical"/></div>
<div id="identnum" class="DifferentNum"></div>


<div id="difftab" class="DifferenceTable">
	<table class="dataTable" style="display:none;width:100%;" id="difftable" cellpadding="2" cellspacing="0" >
</table></div>

<div id="createtab" class="DifferenceTable">
	<table class="dataTable" style="display:none;width:100%;" id="createtable" cellpadding="2" cellspacing="0">
</table></div>

<div id="droptab" class="DifferenceTable">
	<table class="dataTable" style="display:none;width:100%;" id="droptable" cellpadding="2" cellspacing="0">
</table></div>

<div id="identtab" class="DifferenceTable">
	<table class="dataTable" style="display:none;width:100%;" id="identtable" cellpadding="2" cellspacing="0">
</table></div>
</div>

<div id="sqldiv" style="position:absolute;width:100%; height:250;overflow:auto;" class="SQLDiv">
<div id="sqldivtitlebar" class="SQLViewTitleBar" style="position:relative;width:100%;height:20px;background:#7a96df;font-family:Tahoma, Arial, sans-serif;	font-size: 8.25pt;	font-weight:bold;	color: #FFFFFF;"><xsl:value-of select="$SQLView"/></div>
<div id="content" style="position:relative; width:100%; height:230; overflow : auto;">
<div id="tr1sql" class="SQL" style="position:absolute; top:0; left:0;width:100%">
<table id="trsql" class="SQL" width="100%">
</table>
</div>
</div>
</div>

</body>
</html>
</xsl:template>	

<xsl:template match="datasources">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="datasource">
  <!-- Datasource Type -->
  <xsl:text>var datasource</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>type = &quot;</xsl:text>
  <xsl:value-of select="@type" />
  <xsl:text>&quot;;
  </xsl:text>  
  <!-- Datasource Server -->
  <xsl:text>var datasource</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>server = &quot;</xsl:text>
  <xsl:value-of select="server" />
  <xsl:text>&quot;;
  </xsl:text>
  <!-- Datasource Database -->
  <xsl:text>var datasource</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>database = &quot;</xsl:text>
  <xsl:value-of select="database" />
  <xsl:text>&quot;;
  </xsl:text>
</xsl:template>

<xsl:template match="server">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="database">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="differences">
  <!-- We need to create 8 javascript arrays these are 
       differenceRows, 
       onlyInOneRows, 
       onlyInTwoRows, 
       identRows, 
       differencesql, 
       onlyInOnesql, 
       onlyInTwosql, 
       indentsql -->
  <!-- start with *Rows arrays -->
  <xsl:apply-templates select="." mode="rows" />
  <xsl:apply-templates select="." mode="sql" />
</xsl:template>

<xsl:template match="differences" mode="sql">
  <!-- DO DIFFERENCE SQL -->
  <xsl:text>var differencesql  = new Array(new Array(new Array(0, "</xsl:text>
  <xsl:value-of select="$noSQLError"/><xsl:text>"))
  </xsl:text>
  <xsl:choose>
	  <xsl:when test="count(./difference[@status='different']) > 0">
		  <xsl:text>,</xsl:text>
	  </xsl:when>
  </xsl:choose>
    <xsl:variable name="differentlastfqn" select="./difference[@status='different'][last()]/@fqn"/>
  <xsl:for-each select="./difference[@status='different']">
    <xsl:call-template name="processdifferenceforsql">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="lastfqn" select="$differentlastfqn"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>);</xsl:text>
  
  <xsl:text>var createsql  = new Array(new Array(new Array(0, "</xsl:text>
  <xsl:value-of select="$noSQLError"/><xsl:text>"))</xsl:text>    
	  <xsl:choose>
	  <xsl:when test="count(./difference[@status='onlyin1']) > 0">
		  <xsl:text>,</xsl:text>
	  </xsl:when>
  </xsl:choose>
    <xsl:variable name="createlastfqn" select="./difference[@status='onlyin1'][last()]/@fqn"/>
  <xsl:for-each select="./difference[@status='onlyin1']">
    <xsl:call-template name="processdifferenceforsql">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="lastfqn" select="$createlastfqn"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>);</xsl:text>
  
  <xsl:text>var dropsql  = new Array(new Array(new Array(0, "</xsl:text>
  <xsl:value-of select="$noSQLError"/><xsl:text>"))</xsl:text> 
      <xsl:choose>
	  <xsl:when test="count(./difference[@status='onlyin2']) > 0">
		  <xsl:text>,</xsl:text>
	  </xsl:when>
  </xsl:choose>
    <xsl:variable name="droplastfqn" select="./difference[@status='onlyin2'][last()]/@fqn"/>
  <xsl:for-each select="./difference[@status='onlyin2']">
    <xsl:call-template name="processdifferenceforsql">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="lastfqn" select="$droplastfqn"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>);</xsl:text>
  
  <xsl:text>var identsql  = new Array(new Array(new Array(0, "</xsl:text>
  <xsl:value-of select="$noSQLError"/><xsl:text>"))</xsl:text> 
      <xsl:choose>
	  <xsl:when test="count(./difference[@status='equal']) > 0">
		  <xsl:text>,</xsl:text>
	  </xsl:when>
  </xsl:choose>
  <xsl:variable name="identlastfqn" select="./difference[@status='equal'][last()]/@fqn"/>
  <xsl:choose>
    <xsl:when test="$includeidenticals='true'">
      <xsl:for-each select="./difference[@status='equal']">
        <xsl:call-template name="processdifferenceforsql">
          <xsl:with-param name="node" select="."/>
 	  <xsl:with-param name="lastfqn" select="$identlastfqn"/>
 	</xsl:call-template>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
	    <xsl:text>new Array(new Array(0, "", ""))</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>);</xsl:text>  
</xsl:template>

<xsl:template name="processdifferenceforsql">
  <xsl:param name="node" select="."/>
  <xsl:param name="lastfqn" select ="@fqn"/>
  <xsl:text>new Array (</xsl:text>
  <xsl:apply-templates select="./comparisonstrings/line"/>
  <xsl:choose>
    <xsl:when test="@fqn = $lastfqn">
      <xsl:text>new Array(0, "", ""))
      </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>new Array(0, "", "")),
      </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="line">
  <xsl:text>  new Array(</xsl:text>
  <xsl:choose>
    <xsl:when test="@type='same'">
      <xsl:text>0,</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>1,</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&quot;</xsl:text>
  <xsl:value-of select="redgate:replacequotes(left)"/>
  <xsl:text>&quot;, &quot;</xsl:text>
  <xsl:value-of select="redgate:replacequotes(right)"/>
  <xsl:text>&quot;),
  </xsl:text>  
</xsl:template>
  

<xsl:template match="differences" mode="rows">
  <!-- DO DIFFERENCE ROWS -->
  <xsl:text>var differenceRows  = new Array(
      </xsl:text>
  <xsl:variable name="differentlastfqn" select="./difference[@status='different'][last()]/@fqn"/>
  <xsl:for-each select="./difference[@status='different']">
    <xsl:call-template name="processdifference">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="lastfqn" select="$differentlastfqn"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>);
  </xsl:text>

  <!-- DO OnlyInOne ROWS -->
  <xsl:text>var onlyInOneRows  = new Array(
      </xsl:text>
  <xsl:variable name="onlyinonelastfqn" select="./difference[@status='onlyin1'][last()]/@fqn"/>
  <xsl:for-each select="./difference[@status='onlyin1']">
    <xsl:call-template name="processdifference">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="lastfqn" select="$onlyinonelastfqn"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>);
  </xsl:text>

  <!-- DO OnlyInTqo ROWS -->
  <xsl:text>var onlyInTwoRows  = new Array(
      </xsl:text>
  <xsl:variable name="onlyintwolastfqn" select="./difference[@status='onlyin2'][last()]/@fqn"/>
  <xsl:for-each select="./difference[@status='onlyin2']">
    <xsl:call-template name="processdifference">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="lastfqn" select="$onlyintwolastfqn"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>);
  </xsl:text>

  <!-- DO Ident ROWS -->
  <xsl:text>var identRows  = new Array(
      </xsl:text>
  <xsl:variable name="identlastfqn" select="./difference[@status='equal'][last()]/@fqn"/>
    <xsl:choose>
    <xsl:when test="$includeidenticals='true'">
      <xsl:for-each select="./difference[@status='equal']">
        <xsl:call-template name="processdifference">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="lastfqn" select="$identlastfqn"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
  <xsl:text>);
  </xsl:text>

</xsl:template>

<xsl:template name="processdifference">
  <xsl:param name="node" select="."/>
  <xsl:param name="lastfqn" select ="@fqn"/>
  
  <xsl:text>new Array(</xsl:text>
  <xsl:choose>
    <xsl:when test="$node/@objecttype='table'">
      <xsl:text>1</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='storedprocedure'">
      <xsl:text>2</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='view'">
      <xsl:text>3</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='default'">
      <xsl:text>4</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='fulltextcatalog'">
      <xsl:text>5</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='function'">
      <xsl:text>6</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='role'">
      <xsl:text>7</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='rule'">
      <xsl:text>8</xsl:text>
      </xsl:when>
    <xsl:when test="$node/@objecttype='user'">
      <xsl:text>9</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='userdefinedtype'">
      <xsl:text>10</xsl:text>
    </xsl:when>
    
    <xsl:when test="$node/@objecttype='ddltrigger'">
      <xsl:text>12</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='assembly'">
      <xsl:text>13</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='synonym'">
      <xsl:text>14</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='xmlschemacollection'">
      <xsl:text>15</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='messagetype'">
      <xsl:text>16</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='contract'">
      <xsl:text>17</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='queue'">
      <xsl:text>18</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='service'">
      <xsl:text>19</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='route'">
      <xsl:text>20</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='eventnotification'">
      <xsl:text>21</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='partitionscheme'">
      <xsl:text>22</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='partitionfunction'">
      <xsl:text>23</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='schema'">
      <xsl:text>26</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='servicebinding'">
      <xsl:text>27</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='certificate'">
      <xsl:text>28</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='symmetrickey'">
      <xsl:text>29</xsl:text>
    </xsl:when>
    <xsl:when test="$node/@objecttype='asymmetrickey'">
      <xsl:text>30</xsl:text>
    </xsl:when> 
    
    <xsl:otherwise>
      <xsl:text>99</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>, &quot;</xsl:text>
  <xsl:value-of select="$node/object[@id=1]/@owner"/>
  <xsl:text>&quot;, &quot;</xsl:text>
  <xsl:value-of select="$node/object[@id=1]"/>
  <xsl:text>&quot;</xsl:text>
  <xsl:text>, &quot;</xsl:text>
  <xsl:value-of select="$node/object[@id=2]"/>
  <xsl:text>&quot;, &quot;</xsl:text>
  <xsl:value-of select="$node/object[@id=2]/@owner"/>
  <xsl:choose>
    <xsl:when test="$node/@fqn = $lastfqn">
      <xsl:text>&quot;)
      </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&quot;),
      </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
