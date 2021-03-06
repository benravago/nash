// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.5_A3.1_T3;
 * @section: 7.8.5, 15.10.4.1;
 * @assertion: RegularExpressionFlags :: IdentifierPart;
 * @description: IdentifierPart :: m;  
*/

//CHECK#1
var regexp = /(?:)/m; 
if (regexp.global !== false) {
  warn('#1: var regexp = /(?:)/g; regexp.global === false. Actual: ' + (regexp.global));
}

//CHECK#2 
if (regexp.ignoreCase !== false) {
  warn('#2: var regexp = /(?:)/g; regexp.ignoreCase === false. Actual: ' + (regexp.ignoreCase));
}

//CHECK#3
if (regexp.multiline !== true) {
  warn('#3: var regexp = /(?:)/g; regexp.multiline === true. Actual: ' + (regexp.multiline));
}                            
