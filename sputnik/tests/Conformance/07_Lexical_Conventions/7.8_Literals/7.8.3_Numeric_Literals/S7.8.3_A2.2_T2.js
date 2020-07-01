// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A2.2_T2;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: .DecimalDigits ExponentPart;
 * @description: ExponentPart :: E DecimalDigits;
*/

//CHECK#0
if (.0E1 !== 0) {
  warn('#0: .0E1 === 0');
}

//CHECK#1
if (.1E1 !== 1) {
  warn('#1: .1E1 === 1');
}

//CHECK#2
if (.2E1 !== 2) {
  warn('#2: .2E1 === 2');
}

//CHECK#3
if (.3E1 !== 3) {
  warn('#3: .3E1 === 3');
}

//CHECK#4
if (.4E1 !== 4) {
  warn('#4: .4E1 === 4');
}

//CHECK#5
if (.5E1 !== 5) {
  warn('#5: .5E1 === 5');
}

//CHECK#6
if (.6E1 !== 6) {
  warn('#6: .6E1 === 6');
}

//CHECK#7
if (.7E1 !== 7) {
  warn('#7: .7E1 === 7');
}

//CHECK#8
if (.8E1 !== 8) {
  warn('#8: .8E1 === 8');
}

//CHECK#9
if (.9E1 !== 9) {
  warn('#9: .9E1 === 9');
}
