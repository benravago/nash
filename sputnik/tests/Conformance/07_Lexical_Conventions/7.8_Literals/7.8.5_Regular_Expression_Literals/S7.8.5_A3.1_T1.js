// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.5_A3.1_T1;
 * @section: 7.8.5, 15.10.4.1;
 * @assertion: RegularExpressionFlags :: IdentifierPart;
 * @description: IdentifierPart :: g;  
*/

//CHECK#1
var regexp = /(?:)/g; 
if (regexp.global !== true) {
  warn('#1: var regexp = /(?:)/g; regexp.global === true. Actual: ' + (regexp.global));
}

//CHECK#2 
if (regexp.ignoreCase !== false) {
  warn('#2: var regexp = /(?:)/g; regexp.ignoreCase === false. Actual: ' + (regexp.ignoreCase));
}

//CHECK#3
if (regexp.multiline !== false) {
  warn('#3: var regexp = /(?:)/g; regexp.multiline === false. Actual: ' + (regexp.multiline));
}                            
