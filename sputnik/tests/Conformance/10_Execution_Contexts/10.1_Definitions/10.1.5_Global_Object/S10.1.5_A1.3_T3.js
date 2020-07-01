// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A1.3_T3;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object has properties such as built-in objects such as 
 * Math, String, Date, parseInt, etc; 
 * @description: Eval execution context - Constructor Properties;
*/

var evalStr = 
'//CHECK#13\n'+
'if ( Object === null ) {\n'+
'  warn("#13: Object === null");\n'+
'}\n'+

'//CHECK#14\n'+
'if ( Function === null ) {\n'+
'  warn("#14: Function === null");\n'+
'}\n'+

'//CHECK#15\n'+
'if ( String === null ) {\n'+
'  warn("#15: String === null");\n'+
'}\n'+

'//CHECK#16\n'+
'if ( Number === null ) {\n'+
'  warn("#16: Function === null");\n'+
'}\n'+

'//CHECK#17\n'+
'if ( Array === null ) {\n'+
'  warn("#17: Array === null");\n'+
'}\n'+

'//CHECK#18\n'+
'if ( Boolean === null ) {\n'+
'  warn("#20: Boolean === null");\n'+
'}\n'+

'//CHECK#18\n'+
'if ( Date === null ) {\n'+
'  warn("#18: Date === null");\n'+
'}\n'+

'//CHECK#19\n'+
'if ( RegExp === null ) {\n'+
'  warn("#19: RegExp === null");\n'+
'}\n'+

'//CHECK#20\n'+
'if ( Error === null ) {\n'+
'  warn("#20: Error === null");\n'+
'}\n'+

'//CHECK#21\n'+
'if ( EvalError === null ) {\n'+
'  warn("#21: EvalError === null");\n'+
'}\n'+

'//CHECK#22\n'+
'if ( RangeError === null ) {\n'+
'  warn("#22: RangeError === null");\n'+
'}\n'+

'//CHECK#23\n'+
'if ( ReferenceError === null ) {\n'+
'  warn("#23: ReferenceError === null");\n'+
'}\n'+

'//CHECK#24\n'+
'if ( SyntaxError === null ) {\n'+
'  warn("#24: SyntaxError === null");\n'+
'}\n'+

'//CHECK#25\n'+
'if ( TypeError === null ) {\n'+
'  warn("#25: TypeError === null");\n'+
'}\n'+

'//CHECK#26\n'+
'if ( URIError === null ) {\n'+
'  warn("#26: URIError === null");\n'+
'}\n'+
';\n';

eval(evalStr);
