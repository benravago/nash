// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A2_T1;
 * @section: 15.1.2.3;
 * @assertion: Operator remove leading StrWhiteSpaceChar;
 * @description: StrWhiteSpaceChar :: TAB (U+0009);  
*/

//CHECK#1
if (parseFloat("\u00091.1") !== parseFloat("1.1")) {
  warn('#1: parseFloat("\\u00091.1") === parseFloat("1.1"). Actual: ' + (parseFloat("\u00091.1")));
}

//CHECK#2
if (parseFloat("\u0009\u0009-1.1") !== parseFloat("-1.1")) {
  warn('#2: parseFloat("\\u0009\\u0009-1.1") === parseFloat("-1.1"). Actual: ' + (parseFloat("\u0009\u0009-1.1")));
}

//CHECK#3
if (parseFloat("	1.1") !== parseFloat("1.1")) {
  warn('#3: parseFloat("	1.1") === parseFloat("1.1"). Actual: ' + (parseFloat("	1.1")));
}

//CHECK#4
if (parseFloat("			1.1") !== parseFloat("1.1")) {
  warn('#4: parseFloat("			1.1") === parseFloat("1.1"). Actual: ' + (parseFloat("			1.1")));
}

//CHECK#5
if (parseFloat("			\u0009			\u0009-1.1") !== parseFloat("-1.1")) {
  warn('#5: parseFloat("			\\u0009			\\u0009-1.1") === parseFloat("-1.1"). Actual: ' + (parseFloat("			\u0009			\u0009-1.1")));
}

//CHECK#6
if (isNaN(parseFloat("\u0009")) !== true) {
  warn('#6: parseFloat("\\u0009") === Not-a-Number. Actual: ' + (parseFloat("\u0009")));
}
