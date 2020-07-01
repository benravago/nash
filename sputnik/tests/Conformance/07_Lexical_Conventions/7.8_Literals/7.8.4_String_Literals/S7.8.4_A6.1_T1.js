// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.4_A6.1_T1;
 * @section: 7.8.4;
 * @assertion: EscapeSequence :: HexEscapeSequence :: x HexDigit HexDigit;
 * @description: HexEscapeSequence ::  HexDigit;
*/

//CHECK#0
if ("\x00" !== String.fromCharCode("0")) {
  warn('#0: "\\x00" === String.fromCharCode("0")');
}

//CHECK#1
if ("\x01" !== String.fromCharCode("1")) {
  warn('#1: "\\x01" === String.fromCharCode("1")');
}

//CHECK#2
if ("\x02" !== String.fromCharCode("2")) {
  warn('#2: "\\x02" === String.fromCharCode("2")');
}

//CHECK#3
if ("\x03" !== String.fromCharCode("3")) {
  warn('#3: "\\x03" === String.fromCharCode("3")');
}

//CHECK#4
if ("\x04" !== String.fromCharCode("4")) {
  warn('#4: "\\x04" === String.fromCharCode("4")');
}

//CHECK#5
if ("\x05" !== String.fromCharCode("5")) {
  warn('#5: "\\x05" === String.fromCharCode("5")');
}

//CHECK#6
if ("\x06" !== String.fromCharCode("6")) {
  warn('#6: "\\x06" === String.fromCharCode("6")');
}

//CHECK#7
if ("\x07" !== String.fromCharCode("7")) {
  warn('#7: "\\x07" === String.fromCharCode("7")');
}

//CHECK#8
if ("\x08" !== String.fromCharCode("8")) {
  warn('#8: "\\x08" === String.fromCharCode("8")');
}

//CHECK#9
if ("\x09" !== String.fromCharCode("9")) {
  warn('#9: "\\x09" === String.fromCharCode("9")');
}

//CHECK#A
if ("\x0A" !== String.fromCharCode("10")) {
  warn('#A: "\\x0A" === String.fromCharCode("10")');
}

//CHECK#B
if ("\x0B" !== String.fromCharCode("11")) {
  warn('#B: "\\x0B" === String.fromCharCode("11")');
}

//CHECK#C
if ("\x0C" !== String.fromCharCode("12")) {
  warn('#C: "\\x0C" === String.fromCharCode("12")');
}

//CHECK#D
if ("\x0D" !== String.fromCharCode("13")) {
  warn('#D: "\\x0D" === String.fromCharCode("13")');
}

//CHECK#E
if ("\x0E" !== String.fromCharCode("14")) {
  warn('#E: "\\x0E" === String.fromCharCode("14")');
}

//CHECK#F
if ("\x0F" !== String.fromCharCode("15")) {
  warn('#F: "\\x0F" === String.fromCharCode("15")');
}
