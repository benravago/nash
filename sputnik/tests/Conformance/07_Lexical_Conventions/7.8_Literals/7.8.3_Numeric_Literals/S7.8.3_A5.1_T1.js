// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A5.1_T1;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: HexIntegerLiteral;  
 * @description: HexIntegerLiteral :: 0x Digit;
*/

//CHECK#0
if (0x0 !== 0) {
  warn('#0: 0x0 === 0');
}

//CHECK#1
if (0x1 !== 1) {
  warn('#1: 0x1 === 1');
}

//CHECK#2
if (0x2 !== 2) {
  warn('#2: 0x2 === 2');
}

//CHECK#3
if (0x3 !== 3) {
  warn('#3: 0x3 === 3');
}

//CHECK#4
if (0x4 !== 4) {
  warn('#4: 0x4 === 4');
}

//CHECK#5
if (0x5 !== 5) {
  warn('#5: 0x5 === 5');
}

//CHECK#6
if (0x6 !== 6) {
  warn('#6: 0x6 === 6');
}

//CHECK#7
if (0x7 !== 7) {
  warn('#7: 0x7 === 7');
}

//CHECK#8
if (0x8 !== 8) {
  warn('#8: 0x8 === 8');
}

//CHECK#9
if (0x9 !== 9) {
  warn('#9: 0x9 === 9');
}

//CHECK#A
if (0xA !== 10) {
  warn('#A: 0xA === 10');
}

//CHECK#B
if (0xB !== 11) {
  warn('#B: 0xB === 11');
}

//CHECK#C
if (0xC !== 12) {
  warn('#C: 0xC === 12');
}

//CHECK#D
if (0xD !== 13) {
  warn('#D: 0xD === 13');
}

//CHECK#E
if (0xE !== 14) {
  warn('#E: 0xE === 14');
}

//CHECK#F
if (0xF !== 15) {
  warn('#F: 0xF === 15');
}
