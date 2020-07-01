// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A2.3_T3;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object properties have attributes { DontEnum };
 * @description: Global execution context - Constructor Properties;
*/

var evalStr = 
'//CHECK#1\n'+
'for (var x in this) {\n'+
'  if ( x === \'Object\' ) {\n'+
'    warn("#1: \'Object\' have attribute DontEnum");\n'+
'  } else if ( x === \'Function\') {\n'+
'    warn("#1: \'Function\' have attribute DontEnum");\n'+
'  } else if ( x === \'String\' ) {\n'+
'    warn("#1: \'String\' have attribute DontEnum");\n'+
'  } else if ( x === \'Number\' ) {\n'+
'    warn("#1: \'Number\' have attribute DontEnum");\n'+
'  } else if ( x === \'Array\' ) {\n'+
'    warn("#1: \'Array\' have attribute DontEnum");\n'+
'  } else if ( x === \'Boolean\' ) {\n'+
'    warn("#1: \'Boolean\' have attribute DontEnum");\n'+
'  } else if ( x === \'Date\' ) {\n'+
'    warn("#1: \'Date\' have attribute DontEnum");\n'+
'  } else if ( x === \'RegExp\' ) {\n'+
'    warn("#1: \'RegExp\' have attribute DontEnum");\n'+
'  } else if ( x === \'Error\' ) {\n'+
'    warn("#1: \'Error\' have attribute DontEnum");\n'+
'  } else if ( x === \'EvalError\' ) {\n'+
'    warn("#1: \'EvalError\' have attribute DontEnum");\n'+
'  } else if ( x === \'RangeError\' ) {\n'+
'    warn("#1: \'RangeError\' have attribute DontEnum");\n'+
'  } else if ( x === \'ReferenceError\' ) {\n'+
'    warn("#1: \'ReferenceError\' have attribute DontEnum");\n'+
'  } else if ( x === \'SyntaxError\' ) {\n'+
'    warn("#1: \'SyntaxError\' have attribute DontEnum");\n'+
'  } else if ( x === \'TypeError\' ) {\n'+
'    warn("#1: \'TypeError\' have attribute DontEnum");\n'+
'  } else if ( x === \'URIError\' ) {\n'+
'    warn("#1: \'URIError\' have attribute DontEnum");\n'+
'  }\n'+
'}\n';

eval(evalStr);
