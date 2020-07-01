// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A2.3_T2;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object properties have attributes { DontEnum };
 * @description: Global execution context - Function Properties;
*/

var evalStr = 
'//CHECK#1\n'+
'for (var x in this) {\n'+
'  if ( x === \'eval\' ) {\n'+
'    warn("#1: \'eval\' have attribute DontEnum");\n'+
'  } else if ( x === \'parseInt\' ) {\n'+
'    warn("#1: \'parseInt\' have attribute DontEnum");\n'+
'  } else if ( x === \'parseFloat\' ) {\n'+
'    warn("#1: \'parseFloat\' have attribute DontEnum");\n'+
'  } else if ( x === \'isNaN\' ) {\n'+
'    warn("#1: \'isNaN\' have attribute DontEnum");\n'+
'  } else if ( x === \'isFinite\' ) {\n'+
'    warn("#1: \'isFinite\' have attribute DontEnum");\n'+
'  } else if ( x === \'decodeURI\' ) {\n'+
'    warn("#1: \'decodeURI\' have attribute DontEnum");\n'+
'  } else if ( x === \'decodeURIComponent\' ) {\n'+
'    warn("#1: \'decodeURIComponent\' have attribute DontEnum");\n'+
'  } else if ( x === \'encodeURI\' ) {\n'+
'    warn("#1: \'encodeURI\' have attribute DontEnum");\n'+
'  } else if ( x === \'encodeURIComponent\' ) {\n'+
'    warn("#1: \'encodeURIComponent\' have attribute DontEnum");\n'+
'  }\n'+
'}\n';

eval(evalStr);
