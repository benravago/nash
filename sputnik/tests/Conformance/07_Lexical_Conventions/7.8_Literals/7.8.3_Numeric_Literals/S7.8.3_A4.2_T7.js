// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A4.2_T7;
 * @section: 7.8.3;
 * @assertion: ExponentPart :: ExponentIndicator ( /+/-) 0 DecimalDigits is allowed;  
 * @description: ExponentIndicator :: e;
*/

//CHECK#0
if (0e00 !== 0) {
  warn('#0: 0e00 === 0');
}

//CHECK#1
if (1e00 !== 1) {
  warn('#1: 1e00 === 1');
}

//CHECK#2
if (2e00 !== 2) {
  warn('#2: 2e00 === 2');
}

//CHECK#3
if (3e00 !== 3) {
  warn('#3: 3e00 === 3');
}

//CHECK#4
if (4e00 !== 4) {
  warn('#4: 4e00 === 4');
}

//CHECK#5
if (5e00 !== 5) {
  warn('#5: 5e00 === 5');
}

//CHECK#6
if (6e00 !== 6) {
  warn('#6: 6e00 === 6');
}

//CHECK#7
if (7e00 !== 7) {
  warn('#7: 7e00 === 7');
}

//CHECK#8
if (8e00 !== 8) {
  warn('#8: 8e00 === 8');
}

//CHECK#9
if (9e00 !== 9) {
  warn('#9: 9e00 === 9');
}
