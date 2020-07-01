// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A4.2_T4;
 * @section: 7.8.3;
 * @assertion: ExponentPart :: ExponentIndicator ( /+/-) 0 DecimalDigits is allowed;  
 * @description: ExponentIndicator :: E;
*/

//CHECK#0
if (0E-01 !== 0) {
  warn('#0: 0E-01 === 0');
}

//CHECK#1
if (1E-01 !== 0.1) {
  warn('#1: 1E-01 === 0.1');
}

//CHECK#2
if (2E-01 !== 0.2) {
  warn('#2: 2E-01 === 0.2');
}

//CHECK#3
if (3E-01 !== 0.3) {
  warn('#3: 3E-01 === 0.3');
}

//CHECK#4
if (4E-01 !== 0.4) {
  warn('#4: 4E-01 === 0.4');
}

//CHECK#5
if (5E-01 !== 0.5) {
  warn('#5: 5E-01 === 0.5');
}

//CHECK#6
if (6E-01 !== 0.6) {
  warn('#6: 6E-01 === 0.6');
}

//CHECK#7
if (7E-01 !== 0.7) {
  warn('#7: 7E-01 === 0.7');
}

//CHECK#8
if (8E-01 !== 0.8) {
  warn('#8: 8E-01 === 0.8');
}

//CHECK#9
if (9E-01 !== 0.9) {
  warn('#9: 9E-01 === 0.9');
}
