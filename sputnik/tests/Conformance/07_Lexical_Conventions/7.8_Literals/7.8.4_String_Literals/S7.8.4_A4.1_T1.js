// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.4_A4.1_T1;
 * @section: 7.8.4;
 * @assertion: CharacterEscapeSequnce :: SingleEscapeSequence;  
 * @description: SingleEscapeSequence :: one of b f n r t v;
*/

//CHECK#1
if (String.fromCharCode(0x0008) !== "\b") {
  warn('#1: String.fromCharCode(0x0008) === "\\b"');
}

//CHECK#2
if (String.fromCharCode(0x0009) !== "\t") {
  warn('#2: String.fromCharCode(0x0009) === "\\t"');
}

//CHECK#3
if (String.fromCharCode(0x000A) !== "\n") {
  warn('#3: String.fromCharCode(0x000A) === "\\n"');
}

//CHECK#4
if (String.fromCharCode(0x000B) !== "\v") {
  warn('#4: String.fromCharCode(0x000B) === "\\v"');
}

//CHECK#5
if (String.fromCharCode(0x000C) !== "\f") {
  warn('#5: String.fromCharCode(0x000C) === "\\f"');
}

//CHECK#6
if (String.fromCharCode(0x000D) !== "\r") {
  warn('#6: String.fromCharCode(0x000D) === "\\r"');
}
