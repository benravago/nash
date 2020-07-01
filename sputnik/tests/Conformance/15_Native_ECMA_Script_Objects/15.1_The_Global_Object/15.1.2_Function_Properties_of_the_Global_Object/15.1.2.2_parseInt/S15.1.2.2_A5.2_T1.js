// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A5.2_T1;
 * @section: 15.1.2.2;
 * @assertion: If the length of S is at least 2 and the first two characters of S 
 * are either 0x or 0X, then remove the first two characters from S and let R = 16;
 * @description: : 0x;
*/

//CHECK#0
if (parseInt("0x0", 0)  !== parseInt("0", 16)) {
  warn('#0: parseInt("0x0", 0) === parseInt("0", 16). Actual: ' + (parseInt("0x0", 0)));
}

//CHECK#1
if (parseInt("0x1", 0)  !== parseInt("1", 16)) {
  warn('#1: parseInt("0x1", 0) === parseInt("1", 16). Actual: ' + (parseInt("0x1", 0)));
}

//CHECK#2
if (parseInt("0x2", 0)  !== parseInt("2", 16)) {
  warn('#2: parseInt("0x2", 0) === parseInt("2", 16). Actual: ' + (parseInt("0x2", 0)));
}

//CHECK#3
if (parseInt("0x3", 0)  !== parseInt("3", 16)) {
  warn('#3: parseInt("0x3", 0) === parseInt("3", 16). Actual: ' + (parseInt("0x3", 0)));
}

//CHECK#4
if (parseInt("0x4", 0)  !== parseInt("4", 16)) {
  warn('#4: parseInt("0x4", 0) === parseInt("4", 16). Actual: ' + (parseInt("0x4", 0)));
}

//CHECK#5
if (parseInt("0x5", 0)  !== parseInt("5", 16)) {
  warn('#5: parseInt("0x5", 0) === parseInt("5", 16). Actual: ' + (parseInt("0x5", 0)));
}

//CHECK#6
if (parseInt("0x6", 0)  !== parseInt("6", 16)) {
  warn('#6: parseInt("0x6", 0) === parseInt("6", 16). Actual: ' + (parseInt("0x6", 0)));
}

//CHECK#7
if (parseInt("0x7", 0)  !== parseInt("7", 16)) {
  warn('#7: parseInt("0x7", 0) === parseInt("7", 16). Actual: ' + (parseInt("0x7", 0)));
}

//CHECK#8
if (parseInt("0x8", 0)  !== parseInt("8", 16)) {
  warn('#8: parseInt("0x8", 0) === parseInt("8", 16). Actual: ' + (parseInt("0x8", 0)));
}

//CHECK#9
if (parseInt("0x9", 0)  !== parseInt("9", 16)) {
  warn('#9: parseInt("0x9", 0) === parseInt("9", 16). Actual: ' + (parseInt("0x9", 0)));
}

//CHECK#A
if (parseInt("0xA", 0)  !== parseInt("A", 16)) {
  warn('#A: parseInt("0xA", 0) === parseInt("A", 16). Actual: ' + (parseInt("0xA", 0)));
}

//CHECK#B
if (parseInt("0xB", 0)  !== parseInt("B", 16)) {
  warn('#B: parseInt("0xB", 0) === parseInt("B", 16). Actual: ' + (parseInt("0xB", 0)));
}

//CHECK#C
if (parseInt("0xC", 0)  !== parseInt("C", 16)) {
  warn('#C: parseInt("0xC", 0) === parseInt("C", 16). Actual: ' + (parseInt("0xC", 0)));
}

//CHECK#D
if (parseInt("0xD", 0)  !== parseInt("D", 16)) {
  warn('#D: parseInt("0xD", 0) === parseInt("D", 16). Actual: ' + (parseInt("0xD", 0)));
}

//CHECK#E
if (parseInt("0xE", 0)  !== parseInt("E", 16)) {
  warn('#E: parseInt("0xE", 0) === parseInt("E", 16). Actual: ' + (parseInt("0xE", 0)));
}

//CHECK#F
if (parseInt("0xF", 0)  !== parseInt("F", 16)) {
  warn('#F: parseInt("0xF", 0) === parseInt("F", 16). Actual: ' + (parseInt("0xF", 0)));
}

//CHECK#E
if (parseInt("0xE", 0)  !== parseInt("E", 16)) {
  warn('#E: parseInt("0xE", 0) === parseInt("E", 16). Actual: ' + (parseInt("0xE", 0)));
}

//CHECK#ABCDEF
if (parseInt("0xABCDEF", 0)  !== parseInt("ABCDEF", 16)) {
  warn('#ABCDEF: parseInt("0xABCDEF", 0) === parseInt("ABCDEF", 16). Actual: ' + (parseInt("0xABCDEF", 0)));
}     
