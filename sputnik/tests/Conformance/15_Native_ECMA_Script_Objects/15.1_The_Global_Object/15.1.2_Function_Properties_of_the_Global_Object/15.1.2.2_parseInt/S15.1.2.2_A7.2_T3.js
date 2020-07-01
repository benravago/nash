// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A7.2_T3;
 * @section: 15.1.2.2;
 * @assertion: Compute the mathematical integer value 
 * that is represented by Z in radix-R notation, using the
 * letters A-Z and a-z for digits with values 10 through 35. 
 * Compute the number value for Result(16);
 * @description: Checking algorithm for R = 16;
*/
  
//CHECK#1
if (parseInt("0x1", 16) !== 1) {
  warn('#1: parseInt("0x1", 16) === 1. Actual: ' + (parseInt("0x1", 16)));
}

//CHECK#2
if (parseInt("0X10", 16) !== 16) {
  warn('#2: parseInt("0X10", 16) === 16. Actual: ' + (parseInt("0X10", 16)));
}

//CHECK#3
if (parseInt("0x100", 16) !== 256) {
  warn('#3: parseInt("0x100", 16) === 256. Actual: ' + (parseInt("0x100", 16)));
}

//CHECK#4
if (parseInt("0X1000", 16) !== 4096) {
  warn('#4: parseInt("0X1000", 16) === 4096. Actual: ' + (parseInt("0X1000", 16)));
}

//CHECK#5
if (parseInt("0x10000", 16) !== 65536) {
  warn('#5: parseInt("0x10000", 16) === 65536. Actual: ' + (parseInt("0x10000", 16)));
}

//CHECK#6
if (parseInt("0X100000", 16) !== 1048576) {
  warn('#6: parseInt("x100000", 16) === 1048576. Actual: ' + (parseInt("x100000", 16)));
}

//CHECK#7
if (parseInt("0x1000000", 16) !== 16777216) {
  warn('#7: parseInt("0x1000000", 16) === 16777216. Actual: ' + (parseInt("0x1000000", 16)));
}

//CHECK#8
if (parseInt("0x10000000", 16) !== 268435456) {
  warn('#8: parseInt("0x10000000", 16) === 268435456. Actual: ' + (parseInt("0x10000000", 16)));
}

//CHECK#9
if (parseInt("0x100000000", 16) !== 4294967296) {
  warn('#9: parseInt("0x100000000", 16) === 4294967296. Actual: ' + (parseInt("0x100000000", 16)));
}

//CHECK#10
if (parseInt("0x1000000000", 16) !== 68719476736) {
  warn('#10: parseInt("0x1000000000", 16) === 68719476736. Actual: ' + (parseInt("0x1000000000", 16)));
}

//CHECK#10
if (parseInt("0x10000000000", 16) !== 1099511627776) {
  warn('#10: parseInt("0x10000000000", 16) === 1099511627776. Actual: ' + (parseInt("0x10000000000", 16)));
}

//CHECK#12
if (parseInt("0x100000000000", 16) !== 17592186044416) {
  warn('#12: parseInt("0x100000000000", 16) === 17592186044416. Actual: ' + (parseInt("0x100000000000", 16)));
}

//CHECK#13
if (parseInt("0x1000000000000", 16) !== 281474976710656) {
  warn('#13: parseInt("0x1000000000000", 16) === 281474976710656. Actual: ' + (parseInt("0x1000000000000", 16)));
}

//CHECK#14
if (parseInt("0x10000000000000", 16) !== 4503599627370496) {
  warn('#14: parseInt("0x10000000000000", 16) === 4503599627370496. Actual: ' + (parseInt("0x10000000000000", 16)));
}

//CHECK#15
if (parseInt("0x100000000000000", 16) !== 72057594037927936) {
  warn('#15: parseInt("0x100000000000000", 16) === 72057594037927936. Actual: ' + (parseInt("0x100000000000000", 16)));
}

//CHECK#16
if (parseInt("0x1000000000000000", 16) !== 1152921504606846976) {
  warn('#16: parseInt("0x1000000000000000", 16) === 1152921504606846976. Actual: ' + (parseInt("0x1000000000000000", 16)));
}

//CHECK#17
if (parseInt("0x10000000000000000", 16) !== 18446744073709551616) {
  warn('#17: parseInt("0x10000000000000000", 16) === 18446744073709551616. Actual: ' + (parseInt("0x10000000000000000", 16)));
}

//CHECK#18
if (parseInt("0x100000000000000000", 16) !== 295147905179352825856) {
  warn('#18: parseInt("0x100000000000000000", 16) === 295147905179352825856. Actual: ' + (parseInt("0x100000000000000000", 16)));
}

//CHECK#19
if (parseInt("0x1000000000000000000", 16) !== 4722366482869645213696) {
  warn('#19: parseInt("0x1000000000000000000", 16) === 4722366482869645213696. Actual: ' + (parseInt("0x1000000000000000000", 16)));
}

//CHECK#20
if (parseInt("0x10000000000000000000", 16) !== 75557863725914323419136) {
  warn('#20: parseInt("0x10000000000000000000", 16) === 75557863725914323419136. Actual: ' + (parseInt("0x10000000000000000000", 16)));
}
