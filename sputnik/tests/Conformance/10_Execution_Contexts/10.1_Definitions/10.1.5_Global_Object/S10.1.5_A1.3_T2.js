// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A1.3_T2;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object has properties such as built-in objects such as 
 * Math, String, Date, parseInt, etc; 
 * @description: Eval execution context - Function Properties;
*/

var evalStr = 
'//CHECK#4\n'+
'if ( eval === null ) {\n'+
'  warn("#4: eval === null");\n'+
'}\n'+

'//CHECK#5\n'+
'if ( parseInt === null ) {\n'+
'  warn("#5: parseInt === null");\n'+
'}\n'+

'//CHECK#6\n'+
'if ( parseFloat === null ) {\n'+
'  warn("#6: parseFloat === null");\n'+
'}\n'+

'//CHECK#7\n'+
'if ( isNaN === null ) {\n'+
'  warn("#7: isNaN === null");\n'+
'}\n'+

'//CHECK#8\n'+
'if ( isFinite === null ) {\n'+
'  warn("#8: isFinite === null");\n'+
'}\n'+

'//CHECK#9\n'+
'if ( decodeURI === null ) {\n'+
'  warn("#9: decodeURI === null");\n'+
'}\n'+

'//CHECK#10\n'+
'if ( decodeURIComponent === null ) {\n'+
'  warn("#10: decodeURIComponent === null");\n'+
'}\n'+

'//CHECK#11\n'+
'if ( encodeURI === null ) {\n'+
'  warn("#11: encodeURI === null");\n'+
'}\n'+

'//CHECK#12\n'+
'if ( encodeURIComponent === null ) {\n'+
'  warn("#12: encodeURIComponent === null");\n'+
'}\n'+
';\n';

eval(evalStr);
