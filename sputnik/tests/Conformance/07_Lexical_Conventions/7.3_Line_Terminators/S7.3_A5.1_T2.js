// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.3_A5.1_T2;
 * @section: 7.3, 7.4;
 * @assertion: Multi line comment can contain LINE FEED (U+000A);
 * @description: Insert real LINE FEED into multi line comment;
 */

/*CHECK#1*/
var x = 0;
/*
multi
line
comment
x = 1;
*/
if (x !== 0) {
  warn('#1: var x = 0; /*\\nmulti\\nline\\ncomment\\nx = 1;\\n*/ x === 0. Actual: ' + (x));
}
