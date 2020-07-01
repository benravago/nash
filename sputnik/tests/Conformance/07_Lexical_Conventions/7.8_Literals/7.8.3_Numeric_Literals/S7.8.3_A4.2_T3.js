// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A4.2_T3;
 * @section: 7.8.3;
 * @assertion: ExponentPart :: ExponentIndicator ( /+/-) 0 DecimalDigits is allowed;  
 * @description: ExponentIndicator :: e;
*/

//CHECK#0
if (0e-01 !== 0) {
  warn('#0: 0e-01 === 0');
}

//CHECK#1
if (1e-01 !== 0.1) {
  warn('#1: 1e-01 === 0.1');
}

//CHECK#2
if (2e-01 !== 0.2) {
  warn('#2: 2e-01 === 0.2');
}

//CHECK#3
if (3e-01 !== 0.3) {
  warn('#3: 3e-01 === 0.3');
}

//CHECK#4
if (4e-01 !== 0.4) {
  warn('#4: 4e-01 === 0.4');
}

//CHECK#5
if (5e-01 !== 0.5) {
  warn('#5: 5e-01 === 0.5');
}

//CHECK#6
if (6e-01 !== 0.6) {
  warn('#6: 6e-01 === 0.6');
}

//CHECK#7
if (7e-01 !== 0.7) {
  warn('#7: 7e-01 === 0.7');
}

//CHECK#8
if (8e-01 !== 0.8) {
  warn('#8: 8e-01 === 0.8');
}

//CHECK#9
if (9e-01 !== 0.9) {
  warn('#9: 9e-01 === 0.9');
}
