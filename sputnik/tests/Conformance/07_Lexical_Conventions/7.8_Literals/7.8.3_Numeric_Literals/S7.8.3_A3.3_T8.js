// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A3.3_T8;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral. ExponentPart;
 * @description: ExponentPart :: E 0;
*/

//CHECK#0
if (0.E0 !== 0) {
  warn('#0: 0.E0 === 0');
}

//CHECK#1
if (1.E0 !== 1) {
  warn('#1: 1.E0 === 1');
}

//CHECK#2
if (2.E0 !== 2) {
  warn('#2: 2.E0 === 2');
}

//CHECK#3
if (3.E0 !== 3) {
  warn('#3: 3.E0 === 3');
}

//CHECK#4
if (4.E0 !== 4) {
  warn('#4: 4.E0 === 4');
}

//CHECK#5
if (5.E0 !== 5) {
  warn('#5: 5.E0 === 5');
}

//CHECK#6
if (6.E0 !== 6) {
  warn('#6: 6.E0 === 6');
}

//CHECK#7
if (7.E0 !== 7) {
  warn('#7: 7.E0 === 7');
}

//CHECK#8
if (8.E0 !== 8) {
  warn('#8: 8.E0 === 8');
}

//CHECK#9
if (9.E0 !== 9) {
  warn('#9: 9.E0 === 9');
}
