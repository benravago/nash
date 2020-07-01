// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A2.1_T3;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: .DecimalDigits;
 * @description: Use .DecimalDigits that have at the end zeros;
*/

//CHECK#0
if (.00 !== 0.0) {
  warn('#0: .0 === 0.0');
}

//CHECK#1
if (.10 !== 0.1) {
  warn('#1: .1 === 0.1');
}

//CHECK#2
if (.20 !== 0.2) {
  warn('#2: .2 === 0.2');
}

//CHECK#3
if (.30 !== 0.3) {
  warn('#3: .3 === 0.3');
}

//CHECK#4
if (.40 !== 0.4) {
  warn('#4: .4 === 0.4');
}

//CHECK#5
if (.50 !== 0.5) {
  warn('#5: .5 === 0.5');
}

//CHECK#6
if (.60 !== 0.6) {
  warn('#6: .6 === 0.6');
}

//CHECK#7
if (.70 !== 0.7) {
  warn('#7: .7 === 0.7');
}

//CHECK#8
if (.80 !== 0.8) {
  warn('#8: .8 === 0.8');
}

//CHECK#9
if (.90 !== 0.9) {
  warn('#9: .9 === 0.9');
}
