// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A3.3_T2;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral. ExponentPart;
 * @description: ExponentPart :: E DecimalDigits;
*/

//CHECK#0
if (0.E1 !== 0) {
  warn('#0: 0.E1 === 0');
}

//CHECK#1
if (1.E1 !== 10) {
  warn('#1: 1.E1 === 10');
}

//CHECK#2
if (2.E1 !== 20) {
  warn('#2: 2.E1 === 20');
}

//CHECK#3
if (3.E1 !== 30) {
  warn('#3: 3.E1 === 30');
}

//CHECK#4
if (4.E1 !== 40) {
  warn('#4: 4.E1 === 40');
}

//CHECK#5
if (5.E1 !== 50) {
  warn('#5: 5.E1 === 50');
}

//CHECK#6
if (6.E1 !== 60) {
  warn('#6: 6.E1 === 60');
}

//CHECK#7
if (7.E1 !== 70) {
  warn('#7: 7.E1 === 70');
}

//CHECK#8
if (8.E1 !== 80) {
  warn('#8: 8.E1 === 80');
}

//CHECK#9
if (9.E1 !== 90) {
  warn('#9: 9.E1 === 90');
}
