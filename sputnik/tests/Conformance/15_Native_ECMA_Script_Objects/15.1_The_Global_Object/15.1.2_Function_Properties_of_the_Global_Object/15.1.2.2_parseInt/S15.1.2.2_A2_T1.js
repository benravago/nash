// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A2_T1;
 * @section: 15.1.2.2;
 * @assertion: Operator remove leading StrWhiteSpaceChar;
 * @description: StrWhiteSpaceChar :: TAB (U+0009);  
*/

//CHECK#1
if (parseInt("\u00091") !== parseInt("1")) {
  warn('#1: parseInt("\\u00091") === parseInt("1"). Actual: ' + (parseInt("\u00091")));
}

//CHECK#2
if (parseInt("\u0009\u0009-1") !== parseInt("-1")) {
  warn('#2: parseInt("\\u0009\\u0009-1") === parseInt("-1"). Actual: ' + (parseInt("\u0009\u0009-1")));
}

//CHECK#3
if (parseInt("	1") !== parseInt("1")) {
  warn('#3: parseInt("	1") === parseInt("1"). Actual: ' + (parseInt("	1")));
}

//CHECK#4
if (parseInt("			1") !== parseInt("1")) {
  warn('#4: parseInt("			1") === parseInt("1"). Actual: ' + (parseInt("			1")));
}

//CHECK#5
if (parseInt("			\u0009			\u0009-1") !== parseInt("-1")) {
  warn('#5: parseInt("			\\u0009			\\u0009-1") === parseInt("-1"). Actual: ' + (parseInt("			\u0009			\u0009-1")));
}

//CHECK#6
if (isNaN(parseInt("\u0009")) !== true) {
  warn('#6: parseInt("\\u0009") === Not-a-Number. Actual: ' + (parseInt("\u0009")));
}
