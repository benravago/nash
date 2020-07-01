// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A2.1_T2;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: .DecimalDigits;
 * @description: Use .DecimalDigits;
*/

//CHECK#0
if (.00 !== 0.00) {
  warn('#0: .00 === 0.00');
}

//CHECK#1
if (.11 !== 0.11) {
  warn('#1: .11 === 0.11');
}

//CHECK#2
if (.22 !== 0.22) {
  warn('#2: .22 === 0.22');
}

//CHECK#3
if (.33 !== 0.33) {
  warn('#3: .33 === 0.33');
}

//CHECK#4
if (.44 !== 0.44) {
  warn('#4: .44 === 0.44');
}

//CHECK#5
if (.55 !== 0.55) {
  warn('#5: .55 === 0.55');
}

//CHECK#6
if (.66 !== 0.66) {
  warn('#6: .66 === 0.66');
}

//CHECK#7
if (.77 !== 0.77) {
  warn('#7: .77 === 0.77');
}

//CHECK#8
if (.88 !== 0.88) {
  warn('#8: .88 === 0.88');
}

//CHECK#9
if (.99 !== 0.99) {
  warn('#9: .99 === 0.99');
}
