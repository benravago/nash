// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A5.1_T6;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: HexIntegerLiteral;  
 * @description: HexIntegerLiteral :: 0X0 Digits;
*/

//CHECK#0
if (0X00 !== 0) {
  warn('#0: 0X00 === 0');
}

//CHECK#1
if (0X01 !== 1) {
  warn('#1: 0X01 === 1');
}

//CHECK#2
if (0X010 !== 16) {
  warn('#2: 0X010 === 16');
}

//CHECK3
if (0X0100 !== 256) {
  warn('3: 0X0100 === 256');
}

//CHECK#4
if (0X01000 !== 4096) {
  warn('#4: 0X01000 === 4096');
}

//CHECK#5
if (0X010000 !== 65536) {
  warn('#5: 0X010000 === 65536');
}

//CHECK#6
if (0X0100000 !== 1048576) {
  warn('#6: 0X0100000 === 1048576');
}

//CHECK#7
if (0X01000000 !== 16777216) {
  warn('#7: 0X01000000 === 16777216');
}

//CHECK#8
if (0X010000000 !== 268435456) {
  warn('#8: 0X010000000 === 268435456');
}
