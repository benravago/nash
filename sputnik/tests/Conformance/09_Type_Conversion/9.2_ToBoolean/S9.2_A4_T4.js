// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.2_A4_T4;
 * @section: 9.2, 11.4.9;
 * @assertion: Result of boolean conversion from number value is false if the argument is +0, -0, or NaN; otherwise, is true;
 * @description: Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, 
 * Number.MAX_VALUE, Number.MIN_VALUE and some other numbers are converted to Boolean by implicit transformation;
 */

// CHECK#1
if (!(Number.POSITIVE_INFINITY) !== false) {
  warn('#1: !(+Infinity) === false. Actual: ' + (!(+Infinity))); 	
}

// CHECK#2;
if (!(Number.NEGATIVE_INFINITY) !== false) {
  warn('#2: !(-Infinity) === false. Actual: ' + (!(-Infinity))); 	
}

// CHECK#3
if (!(Number.MAX_VALUE) !== false) {
  warn('#3: !(Number.MAX_VALUE) === false. Actual: ' + (!(Number.MAX_VALUE))); 	
}

// CHECK#4
if (!(Number.MIN_VALUE) !== false) {
  warn('#4: !(Number.MIN_VALUE) === false. Actual: ' + (!(Number.MIN_VALUE))); 	
}

// CHECK#5
if (!(13) !== false) {
  warn('#5: !(13) === false. Actual: ' + (!(13)));	
}

// CHECK#6
if (!(-13) !== false) {
  warn('#6: !(-13) === false. Actual: ' + (!(-13)));	
}

// CHECK#7
if (!(1.3) !== false) {
  warn('#7: !(1.3) === false. Actual: ' + (!(1.3)));	
}

// CHECK#8
if (!(-1.3) !== false) {
  warn('#8: !(-1.3) === false. Actual: ' + (!(-1.3)));	
}	
