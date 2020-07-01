// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A1.2_T5;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral ExponentPart;  
 * @description: ExponentPart :: e +DecimalDigits;
*/

//CHECK#0
if (0e+1 !== 0) {
  warn('#0: 0e+1 === 0');
}

//CHe+CK#1
if (1e+1 !== 10) {
  warn('#1: 1e+1 === 10');
}

//CHe+CK#2
if (2e+1 !== 20) {
  warn('#2: 2e+1 === 20');
}

//CHe+CK#3
if (3e+1 !== 30) {
  warn('#3: 3e+1 === 30');
}

//CHe+CK#4
if (4e+1 !== 40) {
  warn('#4: 4e+1 === 40');
}

//CHe+CK#5
if (5e+1 !== 50) {
  warn('#5: 5e+1 === 50');
}

//CHe+CK#6
if (6e+1 !== 60) {
  warn('#6: 6e+1 === 60');
}

//CHe+CK#7
if (7e+1 !== 70) {
  warn('#7: 7e+1 === 70');
}

//CHe+CK#8
if (8e+1 !== 80) {
  warn('#8: 8e+1 === 80');
}

//CHe+CK#9
if (9e+1 !== 90) {
  warn('#9: 9e+1 === 90');
}
