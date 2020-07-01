// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A1.2_T6;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: DecimalIntegerLiteral ExponentPart;  
 * @description: ExponentPart :: E +DecimalDigits;
*/

//CHECK#0
if (0E+1 !== 0) {
  warn('#0: 0E+1 === 0');
}

//CHE+CK#1
if (1E+1 !== 10) {
  warn('#1: 1E+1 === 10');
}

//CHE+CK#2
if (2E+1 !== 20) {
  warn('#2: 2E+1 === 20');
}

//CHE+CK#3
if (3E+1 !== 30) {
  warn('#3: 3E+1 === 30');
}

//CHE+CK#4
if (4E+1 !== 40) {
  warn('#4: 4E+1 === 40');
}

//CHE+CK#5
if (5E+1 !== 50) {
  warn('#5: 5E+1 === 50');
}

//CHE+CK#6
if (6E+1 !== 60) {
  warn('#6: 6E+1 === 60');
}

//CHE+CK#7
if (7E+1 !== 70) {
  warn('#7: 7E+1 === 70');
}

//CHE+CK#8
if (8E+1 !== 80) {
  warn('#8: 8E+1 === 80');
}

//CHE+CK#9
if (9E+1 !== 90) {
  warn('#9: 9E+1 === 90');
}
