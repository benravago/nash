// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A3.2_T2;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral. DecimalDigits;
 * @description: After DecimalIntegerLiteral. used ZeroDigits;
*/

//CHECK#0
if (0.00 !== 0) {
  warn('#0: 0.00 === 0');
}

//CHECK#1
if (1.00 !== 1) {
  warn('#1: 1.00 === 1');
}

//CHECK#2
if (2.00 !== 2) {
  warn('#2: 2.00 === 2');
}

//CHECK#3
if (3.00 !== 3) {
  warn('#3: 3.00 === 3');
}

//CHECK#4
if (4.00 !== 4) {
  warn('#4: 4.00 === 4');
}

//CHECK#5
if (5.00 !== 5) {
  warn('#5: 5.00 === 5');
}

//CHECK#6
if (6.00 !== 6) {
  warn('#6: 6.00 === 6');
}

//CHECK#7
if (7.00 !== 7) {
  warn('#7: 7.00 === 7');
}

//CHECK#8
if (8.00 !== 8) {
  warn('#8: 8.00 === 8');
}

//CHECK#9
if (9.00 !== 9) {
  warn('#9: 9.00 === 9');
}
