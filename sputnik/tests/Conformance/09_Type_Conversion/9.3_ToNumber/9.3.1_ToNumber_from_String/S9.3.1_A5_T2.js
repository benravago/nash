// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.3.1_A5_T2;
 * @section: 9.3.1, 15.7.1;
 * @assertion: The MV of StrDecimalLiteral::: - StrUnsignedDecimalLiteral is the negative 
 * of the MV of StrUnsignedDecimalLiteral. (the negative of this 0 is also 0);
 * @description: Compare Number('-[or +]any_number') with -[or without -]any_number);
*/

// CHECK#1
if (Number("1") !== 1) {
  warn('#1: Number("1") === 1');
}

// CHECK#2
if (Number("+1") !== 1) {
  warn('#3: Number("+1") === 1');
}

// CHECK#3
if (Number("-1") !== -1) {
  warn('#3: Number("-1") === -1');
}

// CHECK#4
if (Number("2") !== 2) {
  warn('#4: Number("2") === 2');
}

// CHECK#5
if (Number("+2") !== 2) {
  warn('#5: Number("+2") === 2');
}

// CHECK#6
if (Number("-2") !== -2) {
  warn('#6: Number("-2") === -2');
}

// CHECK#7
if (Number("3") !== 3) {
  warn('#7: Number("3") === 3');
}

// CHECK#8
if (Number("+3") !== 3) {
  warn('#8: Number("+3") === 3');
}

// CHECK#9
if (Number("-3") !== -3) {
  warn('#9: Number("-3") === -3');
}

// CHECK#10
if (Number("4") !== 4) {
  warn('#10: Number("4") === 4');
}

// CHECK#11
if (Number("+4") !== 4) {
  warn('#11: Number("+4") === 4');
}

// CHECK#12
if (Number("-4") !== -4) {
  warn('#12: Number("-4") === -4');
}

// CHECK#13
if (Number("5") !== 5) {
  warn('#13: Number("5") === 5');
}

// CHECK#14
if (Number("+5") !== 5) {
  warn('#14: Number("+5") === 5');
}

// CHECK#15
if (Number("-5") !== -5) {
  warn('#15: Number("-5") === -5');
}

// CHECK#16
if (Number("6") !== 6) {
  warn('#16: Number("6") === 6');
}

// CHECK#17
if (Number("+6") !== 6) {
  warn('#17: Number("+6") === 6');
}

// CHECK#18
if (Number("-6") !== -6) {
  warn('#18: Number("-6") === -6');
}

// CHECK#19
if (Number("7") !== 7) {
  warn('#19: Number("7") === 7');
}

// CHECK#20
if (Number("+7") !== 7) {
  warn('#20: Number("+7") === 7');
}

// CHECK#21
if (Number("-7") !== -7) {
  warn('#21: Number("-7") === -7');
}

// CHECK#22
if (Number("8") !== 8) {
  warn('#22: Number("8") === 8');
}

// CHECK#23
if (Number("+8") !== 8) {
  warn('#23: Number("+8") === 8');
}

// CHECK#24
if (Number("-8") !== -8) {
  warn('#24: Number("-8") === -8');
}

// CHECK#25
if (Number("9") !== 9) {
  warn('#25: Number("9") === 9');
}

// CHECK#26
if (Number("+9") !== 9) {
  warn('#26: Number("+9") === 9');
}

// CHECK#27
if (Number("-9") !== -9) {
  warn('#27: Number("-9") === -9');
}
