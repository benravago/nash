// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.8.4_A4.1_T2;
 * @section: 7.8.4;
 * @assertion: CharacterEscapeSequnce :: SingleEscapeSequence;  
 * @description: SingleEscapeSequence :: one of ' " \;
*/

//CHECK#1
if (String.fromCharCode(0x0027) !== "\'") {
  warn('#1: String.fromCharCode(0x0027) === "\\\'"');
}

//CHECK#2
if (String.fromCharCode(0x0022) !== '\"') {
  warn('#2: String.fromCharCode(0x0027) === \'\\\"\'');
}

//CHECK#3
if (String.fromCharCode(0x005C) !== "\\") {
  warn('#3: String.fromCharCode(0x005C) === "\\\"');
}

//CHECK#4
if ("\'" !== "'") {
  warn('#4: "\'" === "\\\'"');
}

//CHECK#5
if ('\"' !== '"') {
  warn('#5: \'\"\' === \'\\\"\'');
}
