// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.5_A1.3_T2;
 * @section: 7.8.5;
 * @assertion: RegularExpressionFirstChar :: LineTerminator is incorrect;  
 * @description: Line Feed, with eval;  
*/

//CHECK#1
try {
   eval("/\u000A/").source;
   warn('#1.1: RegularExpressionFirstChar :: Line Feed is incorrect. Actual: ' + (eval("/\u000A/").source)); 
}
catch (e) {
  if ((e instanceof SyntaxError) !== true) {
     warn('#1.2: RegularExpressionFirstChar :: Line Feed is incorrect. Actual: ' + (e));
  }
}     
