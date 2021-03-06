// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A2_T3;
 * @section: 15.1.2.3;
 * @assertion: Operator remove leading StrWhiteSpaceChar;
 * @description: StrWhiteSpaceChar :: NBSB (U+00A0);  
*/

//CHECK#1
if (parseFloat("\u00A01.1") !== parseFloat("1.1")) {
  warn('#1: parseFloat("\\u00A01.1") === parseFloat("1.1"). Actual: ' + (parseFloat("\u00A01.1")));
}

//CHECK#2
if (parseFloat("\u00A0\u00A0-1.1") !== parseFloat("-1.1")) {
  warn('#2: parseFloat("\\u00A0\\u00A0-1.1") === parseFloat("-1.1"). Actual: ' + (parseFloat("\u00A0\u00A0-1.1")));
}

//CHECK#3
if (isNaN(parseFloat("\u00A0")) !== true) {
  warn('#3: parseFloat("\\u00A0") === Not-a-Number. Actual: ' + (parseFloat("\u00A0")));
}
