// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A3.4_T8;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral. DecimalDigigts ExponentPart;
 * @description: ExponentPart :: E 0;
*/

//CHECK#0
if (0.0E0 !== 0.0) {
  warn('#0: 0.0E0 === 0.0');
}

//CHECK#1
if (1.1E0 !== 1.1) {
  warn('#1: 1.1E0 === 1.1');
}

//CHECK#2
if (2.2E0 !== 2.2) {
  warn('#2: 2.2E0 === 2.2');
}

//CHECK#3
if (3.3E0 !== 3.3) {
  warn('#3: 3.3E0 === 3.3');
}

//CHECK#4
if (4.4E0 !== 4.4) {
  warn('#4: 4.4E0 === 4.4');
}

//CHECK#5
if (5.5E0 !== 5.5) {
  warn('#5: 5.5E0 === 5.5');
}

//CHECK#6
if (6.6E0 !== 6.6) {
  warn('#6: 6.E0 === 6.6');
}

//CHECK#7
if (7.7E0 !== 7.7) {
  warn('#7: 7.7E0 === 7.7');
}

//CHECK#8
if (8.8E0 !== 8.8) {
  warn('#8: 8.8E0 === 8.8');
}

//CHECK#9
if (9.9E0 !== 9.9) {
  warn('#9: 9.9E0 === 9.9');
}
