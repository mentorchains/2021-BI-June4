// (C) Wolfgang Huber 2010-2011

// Script parameters - these are set up by R in the function 'writeReport' when copying the 
//   template for this script from arrayQualityMetrics/inst/scripts into the report.

var highlightInitial = [ false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, true, false, true, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, true, false, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false ];
var arrayMetadata    = [ [ "1", "GSM494556.CEL.gz", "1", "11/02/07 13:37:50" ], [ "2", "GSM494557.CEL.gz", "2", "11/02/07 14:00:03" ], [ "3", "GSM494558.CEL.gz", "3", "11/15/07 12:33:54" ], [ "4", "GSM494559.CEL.gz", "4", "06/06/08 13:39:18" ], [ "5", "GSM494560.CEL.gz", "5", "03/07/08 12:32:16" ], [ "6", "GSM494561.CEL.gz", "6", "06/18/08 12:41:51" ], [ "7", "GSM494562.CEL.gz", "7", "03/19/08 14:39:34" ], [ "8", "GSM494563.CEL.gz", "8", "03/07/08 12:54:33" ], [ "9", "GSM494564.CEL.gz", "9", "03/07/08 13:17:09" ], [ "10", "GSM494565.CEL.gz", "10", "10/25/07 13:04:39" ], [ "11", "GSM494566.CEL.gz", "11", "11/15/07 12:56:20" ], [ "12", "GSM494567.CEL.gz", "12", "11/22/07 12:16:37" ], [ "13", "GSM494568.CEL.gz", "13", "11/28/07 13:00:30" ], [ "14", "GSM494569.CEL.gz", "14", "11/22/07 12:38:57" ], [ "15", "GSM494570.CEL.gz", "15", "03/14/08 14:02:34" ], [ "16", "GSM494571.CEL.gz", "16", "03/19/08 15:01:46" ], [ "17", "GSM494572.CEL.gz", "17", "04/18/08 12:24:23" ], [ "18", "GSM494573.CEL.gz", "18", "03/14/08 14:16:26" ], [ "19", "GSM494574.CEL.gz", "19", "06/18/09 13:49:40" ], [ "20", "GSM494575.CEL.gz", "20", "07/10/09 13:38:26" ], [ "21", "GSM494576.CEL.gz", "21", "04/18/08 12:46:36" ], [ "22", "GSM494577.CEL.gz", "22", "04/18/08 13:08:55" ], [ "23", "GSM494578.CEL.gz", "23", "04/25/08 14:09:58" ], [ "24", "GSM494579.CEL.gz", "24", "04/25/08 14:32:20" ], [ "25", "GSM494580.CEL.gz", "25", "05/22/08 13:20:27" ], [ "26", "GSM494581.CEL.gz", "26", "05/01/09 13:47:16" ], [ "27", "GSM494582.CEL.gz", "27", "05/27/09 13:35:03" ], [ "28", "GSM494583.CEL.gz", "28", "05/14/08 13:39:12" ], [ "29", "GSM494584.CEL.gz", "29", "05/14/08 14:01:38" ], [ "30", "GSM494585.CEL.gz", "30", "05/22/08 13:42:47" ], [ "31", "GSM494586.CEL.gz", "31", "05/22/08 14:05:18" ], [ "32", "GSM494587.CEL.gz", "32", "03/19/08 15:37:53" ], [ "33", "GSM494588.CEL.gz", "33", "05/01/08 13:46:06" ], [ "34", "GSM494589.CEL.gz", "34", "07/10/08 12:45:00" ], [ "35", "GSM494590.CEL.gz", "35", "07/22/08 13:39:28" ], [ "36", "GSM494591.CEL.gz", "36", "07/22/08 14:13:07" ], [ "37", "GSM494592.CEL.gz", "37", "05/13/09 13:57:42" ], [ "38", "GSM494593.CEL.gz", "38", "05/13/09 14:41:38" ], [ "39", "GSM494594.CEL.gz", "39", "07/31/08 13:48:20" ], [ "40", "GSM494595.CEL.gz", "40", "05/08/09 12:40:29" ], [ "41", "GSM494596.CEL.gz", "41", "07/31/08 13:36:55" ], [ "42", "GSM494597.CEL.gz", "42", "07/31/08 14:21:43" ], [ "43", "GSM494598.CEL.gz", "43", "05/13/09 14:19:40" ], [ "44", "GSM494599.CEL.gz", "44", "05/27/09 13:57:25" ], [ "45", "GSM494600.CEL.gz", "45", "07/10/08 13:07:24" ], [ "46", "GSM494601.CEL.gz", "46", "12/12/08 13:29:18" ], [ "47", "GSM494602.CEL.gz", "47", "02/19/09 14:29:24" ], [ "48", "GSM494603.CEL.gz", "48", "02/19/09 14:51:32" ], [ "49", "GSM494604.CEL.gz", "49", "02/06/09 13:48:09" ], [ "50", "GSM494605.CEL.gz", "50", "02/19/09 15:13:59" ], [ "51", "GSM494606.CEL.gz", "51", "02/06/09 14:10:09" ], [ "52", "GSM494607.CEL.gz", "52", "02/19/09 15:36:00" ], [ "53", "GSM494608.CEL.gz", "53", "03/18/09 13:01:30" ], [ "54", "GSM494609.CEL.gz", "54", "03/18/09 13:23:39" ], [ "55", "GSM494610.CEL.gz", "55", "05/01/09 13:25:15" ], [ "56", "GSM494611.CEL.gz", "56", "06/11/09 13:32:50" ], [ "57", "GSM494612.CEL.gz", "57", "06/11/09 13:55:16" ], [ "58", "GSM494613.CEL.gz", "58", "06/18/09 14:11:57" ], [ "59", "GSM494614.CEL.gz", "59", "07/03/09 13:03:27" ], [ "60", "GSM494615.CEL.gz", "60", "07/10/09 14:00:39" ], [ "61", "GSM494616.CEL.gz", "61", "11/02/07 13:26:32" ], [ "62", "GSM494617.CEL.gz", "62", "11/02/07 13:48:55" ], [ "63", "GSM494618.CEL.gz", "63", "11/15/07 12:22:43" ], [ "64", "GSM494619.CEL.gz", "64", "06/06/08 13:27:57" ], [ "65", "GSM494620.CEL.gz", "65", "03/07/08 12:20:59" ], [ "66", "GSM494621.CEL.gz", "66", "06/18/08 12:30:37" ], [ "67", "GSM494622.CEL.gz", "67", "03/19/08 14:28:05" ], [ "68", "GSM494623.CEL.gz", "68", "03/07/08 12:43:27" ], [ "69", "GSM494624.CEL.gz", "69", "03/07/08 13:05:53" ], [ "70", "GSM494625.CEL.gz", "70", "10/25/07 13:23:03" ], [ "71", "GSM494626.CEL.gz", "71", "11/15/07 12:45:12" ], [ "72", "GSM494627.CEL.gz", "72", "11/22/07 12:05:25" ], [ "73", "GSM494628.CEL.gz", "73", "11/28/07 12:49:31" ], [ "74", "GSM494629.CEL.gz", "74", "11/22/07 12:27:44" ], [ "75", "GSM494630.CEL.gz", "75", "03/14/08 13:51:19" ], [ "76", "GSM494631.CEL.gz", "76", "03/19/08 14:50:44" ], [ "77", "GSM494632.CEL.gz", "77", "04/18/08 12:13:18" ], [ "78", "GSM494633.CEL.gz", "78", "03/14/08 14:44:25" ], [ "79", "GSM494634.CEL.gz", "79", "06/18/09 13:38:31" ], [ "80", "GSM494635.CEL.gz", "80", "07/10/09 13:27:28" ], [ "81", "GSM494636.CEL.gz", "81", "04/18/08 12:35:29" ], [ "82", "GSM494637.CEL.gz", "82", "04/18/08 12:57:49" ], [ "83", "GSM494638.CEL.gz", "83", "04/25/08 13:58:44" ], [ "84", "GSM494639.CEL.gz", "84", "04/25/08 14:21:13" ], [ "85", "GSM494640.CEL.gz", "85", "05/22/08 14:23:25" ], [ "86", "GSM494641.CEL.gz", "86", "05/01/09 13:36:17" ], [ "87", "GSM494642.CEL.gz", "87", "05/27/09 13:24:03" ], [ "88", "GSM494643.CEL.gz", "88", "05/14/08 13:27:51" ], [ "89", "GSM494644.CEL.gz", "89", "05/14/08 13:50:25" ], [ "90", "GSM494645.CEL.gz", "90", "05/22/08 13:31:42" ], [ "91", "GSM494646.CEL.gz", "91", "05/22/08 13:54:01" ], [ "92", "GSM494647.CEL.gz", "92", "03/19/08 16:09:49" ], [ "93", "GSM494648.CEL.gz", "93", "05/01/08 13:34:55" ], [ "94", "GSM494649.CEL.gz", "94", "07/10/08 12:20:53" ], [ "95", "GSM494650.CEL.gz", "95", "07/22/08 13:50:42" ], [ "96", "GSM494651.CEL.gz", "96", "07/22/08 14:01:50" ], [ "97", "GSM494652.CEL.gz", "97", "05/13/09 13:46:32" ], [ "98", "GSM494653.CEL.gz", "98", "05/13/09 14:30:40" ], [ "99", "GSM494654.CEL.gz", "99", "07/31/08 13:59:26" ], [ "100", "GSM494655.CEL.gz", "100", "05/08/09 12:29:31" ], [ "101", "GSM494656.CEL.gz", "101", "07/31/08 14:10:38" ], [ "102", "GSM494657.CEL.gz", "102", "07/31/08 14:32:53" ], [ "103", "GSM494658.CEL.gz", "103", "05/13/09 14:08:41" ], [ "104", "GSM494659.CEL.gz", "104", "05/27/09 13:46:13" ], [ "105", "GSM494660.CEL.gz", "105", "07/10/08 12:56:07" ], [ "106", "GSM494661.CEL.gz", "106", "12/12/08 13:18:12" ], [ "107", "GSM494662.CEL.gz", "107", "02/19/09 14:18:19" ], [ "108", "GSM494663.CEL.gz", "108", "02/19/09 14:40:23" ], [ "109", "GSM494664.CEL.gz", "109", "02/06/09 13:37:07" ], [ "110", "GSM494665.CEL.gz", "110", "02/19/09 15:02:42" ], [ "111", "GSM494666.CEL.gz", "111", "02/06/09 13:59:01" ], [ "112", "GSM494667.CEL.gz", "112", "02/19/09 15:24:56" ], [ "113", "GSM494668.CEL.gz", "113", "03/18/09 12:50:25" ], [ "114", "GSM494669.CEL.gz", "114", "03/18/09 13:12:32" ], [ "115", "GSM494670.CEL.gz", "115", "05/01/09 13:14:07" ], [ "116", "GSM494671.CEL.gz", "116", "06/11/09 13:21:49" ], [ "117", "GSM494672.CEL.gz", "117", "06/11/09 13:44:03" ], [ "118", "GSM494673.CEL.gz", "118", "06/18/09 14:00:48" ], [ "119", "GSM494674.CEL.gz", "119", "07/03/09 12:52:16" ], [ "120", "GSM494675.CEL.gz", "120", "07/10/09 13:49:31" ] ];
var svgObjectNames   = [ "pca", "dens", "dig" ];

var cssText = ["stroke-width:1; stroke-opacity:0.4",
               "stroke-width:3; stroke-opacity:1" ];

// Global variables - these are set up below by 'reportinit'
var tables;             // array of all the associated ('tooltips') tables on the page
var checkboxes;         // the checkboxes
var ssrules;


function reportinit() 
{
 
    var a, i, status;

    /*--------find checkboxes and set them to start values------*/
    checkboxes = document.getElementsByName("ReportObjectCheckBoxes");
    if(checkboxes.length != highlightInitial.length)
	throw new Error("checkboxes.length=" + checkboxes.length + "  !=  "
                        + " highlightInitial.length="+ highlightInitial.length);
    
    /*--------find associated tables and cache their locations------*/
    tables = new Array(svgObjectNames.length);
    for(i=0; i<tables.length; i++) 
    {
        tables[i] = safeGetElementById("Tab:"+svgObjectNames[i]);
    }

    /*------- style sheet rules ---------*/
    var ss = document.styleSheets[0];
    ssrules = ss.cssRules ? ss.cssRules : ss.rules; 

    /*------- checkboxes[a] is (expected to be) of class HTMLInputElement ---*/
    for(a=0; a<checkboxes.length; a++)
    {
	checkboxes[a].checked = highlightInitial[a];
        status = checkboxes[a].checked; 
        setReportObj(a+1, status, false);
    }

}


function safeGetElementById(id)
{
    res = document.getElementById(id);
    if(res == null)
        throw new Error("Id '"+ id + "' not found.");
    return(res)
}

/*------------------------------------------------------------
   Highlighting of Report Objects 
 ---------------------------------------------------------------*/
function setReportObj(reportObjId, status, doTable)
{
    var i, j, plotObjIds, selector;

    if(doTable) {
	for(i=0; i<svgObjectNames.length; i++) {
	    showTipTable(i, reportObjId);
	} 
    }

    /* This works in Chrome 10, ssrules will be null; we use getElementsByClassName and loop over them */
    if(ssrules == null) {
	elements = document.getElementsByClassName("aqm" + reportObjId); 
	for(i=0; i<elements.length; i++) {
	    elements[i].style.cssText = cssText[0+status];
	}
    } else {
    /* This works in Firefox 4 */
    for(i=0; i<ssrules.length; i++) {
        if (ssrules[i].selectorText == (".aqm" + reportObjId)) {
		ssrules[i].style.cssText = cssText[0+status];
		break;
	    }
	}
    }

}

/*------------------------------------------------------------
   Display of the Metadata Table
  ------------------------------------------------------------*/
function showTipTable(tableIndex, reportObjId)
{
    var rows = tables[tableIndex].rows;
    var a = reportObjId - 1;

    if(rows.length != arrayMetadata[a].length)
	throw new Error("rows.length=" + rows.length+"  !=  arrayMetadata[array].length=" + arrayMetadata[a].length);

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = arrayMetadata[a][i];
}

function hideTipTable(tableIndex)
{
    var rows = tables[tableIndex].rows;

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = "";
}


/*------------------------------------------------------------
  From module 'name' (e.g. 'density'), find numeric index in the 
  'svgObjectNames' array.
  ------------------------------------------------------------*/
function getIndexFromName(name) 
{
    var i;
    for(i=0; i<svgObjectNames.length; i++)
        if(svgObjectNames[i] == name)
	    return i;

    throw new Error("Did not find '" + name + "'.");
}


/*------------------------------------------------------------
  SVG plot object callbacks
  ------------------------------------------------------------*/
function plotObjRespond(what, reportObjId, name)
{

    var a, i, status;

    switch(what) {
    case "show":
	i = getIndexFromName(name);
	showTipTable(i, reportObjId);
	break;
    case "hide":
	i = getIndexFromName(name);
	hideTipTable(i);
	break;
    case "click":
        a = reportObjId - 1;
	status = !checkboxes[a].checked;
	checkboxes[a].checked = status;
	setReportObj(reportObjId, status, true);
	break;
    default:
	throw new Error("Invalid 'what': "+what)
    }
}

/*------------------------------------------------------------
  checkboxes 'onchange' event
------------------------------------------------------------*/
function checkboxEvent(reportObjId)
{
    var a = reportObjId - 1;
    var status = checkboxes[a].checked;
    setReportObj(reportObjId, status, true);
}


/*------------------------------------------------------------
  toggle visibility
------------------------------------------------------------*/
function toggle(id){
  var head = safeGetElementById(id + "-h");
  var body = safeGetElementById(id + "-b");
  var hdtxt = head.innerHTML;
  var dsp;
  switch(body.style.display){
    case 'none':
      dsp = 'block';
      hdtxt = '-' + hdtxt.substr(1);
      break;
    case 'block':
      dsp = 'none';
      hdtxt = '+' + hdtxt.substr(1);
      break;
  }  
  body.style.display = dsp;
  head.innerHTML = hdtxt;
}
