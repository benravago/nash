// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.2_A6_T2;
 * @section: 9.2, 11.4.9;
 * @assertion: Result of boolean conversion from object is true;
 * @description: Different objects convert to Boolean by implicit transformation;
*/

// CHECK#1
if (!(new Object()) !== false) {
  warn('#1: !(new Object()) === false. Actual: ' + (!(new Object())));	
}

// CHECK#2
if (!(new String("")) !== false) {
  warn('#2: !(new String("")) === false. Actual: ' + (!(new String(""))));	
}

// CHECK#3
if (!(new String()) !== false) {
  warn('#3: !(new String()) === false. Actual: ' + (!(new String())));	
}

// CHECK#4
if (!(new Boolean(true)) !== false) {
  warn('#4: !(new Boolean(true)) === false. Actual: ' + (!(new Boolean(true))));	
}

// CHECK#5
if (!(new Boolean(false)) !== false) {
  warn('#5: !(new Boolean(false)) === false. Actual: ' + (!(new Boolean(false))));	
}

// CHECK#6
if (!(new Boolean()) !== false) {
  warn('#6: !(new Boolean()) === false. Actual: ' + (!(new Boolean())));	
}

// CHECK#7
if (!(new Array()) !== false) {
  warn('#7: !(new Array()) === false. Actual: ' + (!(new Array())));	
}

// CHECK#8
if (!(new Number()) !== false) {
  warn('#8: !(new Number()) === false. Actual: ' + (!(new Number())));	
}

// CHECK#9
if (!(new Number(-0)) !== false) {
  warn('#9: !(new Number(-0)) === false. Actual: ' + (!(new Number(-0))));	
}

// CHECK#10
if (!(new Number(0)) !== false) {
  warn('#10: !(new Number(0)) === false. Actual: ' + (!(new Number(0))));	
}

// CHECK#11
if (!(new Number()) !== false) {
  warn('#11: !(new Number()) === false. Actual: ' + (!(new Number())));	
}

// CHECK#12
if (!(new Number(Number.NaN)) !== false) {
  warn('#12: !(new Number(Number.NaN)) === false. Actual: ' + (!(new Number(Number.NaN))));	
}

// CHECK#13
if (!(new Number(-1)) !== false) {
  warn('#13: !(new Number(-1)) === false. Actual: ' + (!(new Number(-1))));	
}

// CHECK#14
if (!(new Number(1)) !== false) {
  warn('#14: !(new Number(1)) === false. Actual: ' + (!(new Number(1))));	
}

// CHECK#15
if (!(new Number(Number.POSITIVE_INFINITY)) !== false) {
  warn('#15: !(new Number(Number.POSITIVE_INFINITY)) === false. Actual: ' + (!(new Number(Number.POSITIVE_INFINITY))));	
}

// CHECK#16
if (!(new Number(Number.NEGATIVE_INFINITY)) !== false) {
  warn('#16: !(new Number(Number.NEGATIVE_INFINITY)) === false. Actual: ' + (!(new Number(Number.NEGATIVE_INFINITY))));	
}

// CHECK#17
if (!(new Function()) !== false) {
  warn('#17: !(new Function()) === false. Actual: ' + (!(new Function())));	
}

// CHECK#18
if (!(new Date()) !== false) {
  warn('#18: !(new Date()) === false. Actual: ' + (!(new Date())));	
}

// CHECK#19
if (!(new Date(0)) !== false) {
  warn('#19: !(new Date(0)) === false. Actual: ' + (!(new Date(0))));	
}
