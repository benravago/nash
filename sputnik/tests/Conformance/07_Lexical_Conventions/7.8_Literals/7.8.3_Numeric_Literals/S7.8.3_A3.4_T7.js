// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A3.4_T7;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral. DecimalDigigts ExponentPart;
 * @description: ExponentPart :: e 0;
*/

//CHECK#0
if (0.0e0 !== 0.0) {
  warn('#0: 0.0e0 === 0.0');
}

//CHECK#1
if (1.1e0 !== 1.1) {
  warn('#1: 1.1e0 === 1.1');
}

//CHECK#2
if (2.2e0 !== 2.2) {
  warn('#2: 2.2e0 === 2.2');
}

//CHECK#3
if (3.3e0 !== 3.3) {
  warn('#3: 3.3e0 === 3.3');
}

//CHECK#4
if (4.4e0 !== 4.4) {
  warn('#4: 4.4e0 === 4.4');
}

//CHECK#5
if (5.5e0 !== 5.5) {
  warn('#5: 5.5e0 === 5.5');
}

//CHECK#6
if (6.6e0 !== 6.6) {
  warn('#6: 6.e0 === 6.6');
}

//CHECK#7
if (7.7e0 !== 7.7) {
  warn('#7: 7.7e0 === 7.7');
}

//CHECK#8
if (8.8e0 !== 8.8) {
  warn('#8: 8.8e0 === 8.8');
}

//CHECK#9
if (9.9e0 !== 9.9) {
  warn('#9: 9.9e0 === 9.9');
}
