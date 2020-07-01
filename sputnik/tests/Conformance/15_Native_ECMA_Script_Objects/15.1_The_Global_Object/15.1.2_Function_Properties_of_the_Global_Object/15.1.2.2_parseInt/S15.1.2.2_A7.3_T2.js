// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A7.3_T2;
 * @section: 15.1.2.2;
 * @assertion: Return sign * Result(17);
 * @description: Checking algorithm for R = 2;
*/
  
//CHECK#1
if (parseInt("-1", 2)  !== -1) {
  warn('#1: parseInt("-1", 2) === -1. Actual: ' + (parseInt("-1", 2)));
}

//CHECK#2
if (parseInt("-11", 2)  !== -3) {
  warn('#2: parseInt("-11", 2) === -3. Actual: ' + (parseInt("-11", 2)));
}

//CHECK#3
if (parseInt("-111", 2)  !== -7) {
  warn('#3: parseInt("-111", 2) === -7. Actual: ' + (parseInt("-111", 2)));
}

//CHECK#4
if (parseInt("-1111", 2)  !== -15) {
  warn('#4: parseInt("-1111", 2) === -15. Actual: ' + (parseInt("-1111", 2)));
}

//CHECK#5
if (parseInt("-11111", 2)  !== -31) {
  warn('#5: parseInt("-11111", 2) === -31. Actual: ' + (parseInt("-11111", 2)));
}

//CHECK#6
if (parseInt("-111111", 2)  !== -63) {
  warn('#6: parseInt("-111111", 2) === -63. Actual: ' + (parseInt("-111111", 2)));
}

//CHECK#7
if (parseInt("-1111111", 2)  !== -127) {
  warn('#7: parseInt("-1111111", 2) === -127. Actual: ' + (parseInt("-1111111", 2)));
}

//CHECK#8
if (parseInt("-11111111", 2)  !== -255) {
  warn('#8: parseInt("-11111111", 2) === -255. Actual: ' + (parseInt("-11111111", 2)));
}

//CHECK#9
if (parseInt("-111111111", 2)  !== -511) {
  warn('#9: parseInt("-111111111", 2) === -511. Actual: ' + (parseInt("-111111111", 2)));
}

//CHECK#10
if (parseInt("-1111111111", 2)  !== -1023) {
  warn('#10: parseInt("-1111111111", 2) === -1023. Actual: ' + (parseInt("-1111111111", 2)));
}

//CHECK#11
if (parseInt("-11111111111", 2)  !== -2047) {
  warn('#11: parseInt("-11111111111", 2) === -2047. Actual: ' + (parseInt("-11111111111", 2)));
}

//CHECK#12
if (parseInt("-111111111111", 2)  !== -4095) {
  warn('#12: parseInt("-111111111111", 2) === -4095. Actual: ' + (parseInt("-111111111111", 2)));
}

//CHECK#13
if (parseInt("-1111111111111", 2)  !== -8191) {
  warn('#13: parseInt("-1111111111111", 2) === -8191. Actual: ' + (parseInt("-1111111111111", 2)));
}

//CHECK#14
if (parseInt("-11111111111111", 2)  !== -16383) {
  warn('#14: parseInt("-11111111111111", 2) === -16383. Actual: ' + (parseInt("-11111111111111", 2)));
}

//CHECK#15
if (parseInt("-111111111111111", 2)  !== -32767) {
  warn('#15: parseInt("-111111111111111", 2) === -32767. Actual: ' + (parseInt("-111111111111111", 2)));
}

//CHECK#16
if (parseInt("-1111111111111111", 2)  !== -65535) {
  warn('#16: parseInt("-1111111111111111", 2) === -65535. Actual: ' + (parseInt("-1111111111111111", 2)));
}

//CHECK#17
if (parseInt("-11111111111111111", 2)  !== -131071) {
  warn('#17: parseInt("-11111111111111111", 2) === -131071. Actual: ' + (parseInt("-11111111111111111", 2)));
}

//CHECK#18
if (parseInt("-111111111111111111", 2)  !== -262143) {
  warn('#18: parseInt("-111111111111111111", 2) === -262143. Actual: ' + (parseInt("-111111111111111111", 2)));
}

//CHECK#19
if (parseInt("-1111111111111111111", 2)  !== -524287) {
  warn('#19: parseInt("-1111111111111111111", 2) === -524287. Actual: ' + (parseInt("-1111111111111111111", 2)));
}

//CHECK#20
if (parseInt("-11111111111111111111", 2)  !== -1048575) {
  warn('#20: parseInt("-11111111111111111111", 2) === -1048575. Actual: ' + (parseInt("-11111111111111111111", 2)));
}
