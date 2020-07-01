// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.3_A5.1_T7;
 * @section: 7.8.3;
 * @assertion: DecimalLiteral :: HexIntegerLiteral;  
 * @description: HexIntegerLiteral :: 0x one of a, b, c, d, e, f;
*/

//CHECK#a
if (0xa !== 10) {
  warn('#a: 0xa === 10');
}

//CHECK#b
if (0xb !== 11) {
  warn('#b: 0xb === 11');
}

//CHECK#c
if (0xc !== 12) {
  warn('#c: 0xc === 12');
}

//CHECK#d
if (0xd !== 13) {
  warn('#d: 0xd === 13');
}

//CHECK#e
if (0xe !== 14) {
  warn('#e: 0xe === 14');
}

//CHECK#f
if (0xf !== 15) {
  warn('#f: 0xf === 15');
}
