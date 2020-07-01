// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.7.1_A5.1_T1;
 * @section: 11.7.1, 9.5;
 * @assertion: Operator x << y uses ToInt32(ShiftExpression);
 * @description: Checking boundary points;
 */

//CHECK#1
if (2147483648.1 << 0 !== -2147483648) { 
  warn('#1: 2147483648.1 << 0 === -2147483648. Actual: ' + (2147483648.1 << 0)); 
} 

//CHECK#2
if (4294967296.1 << 0 !== 0) { 
  warn('#2: 4294967296.1 << 0 === 0. Actual: ' + (4294967296.1 << 0)); 
} 

//CHECK#3
if (6442450944.1 << 0 !== -2147483648) { 
  warn('#3: 6442450944.1 << 0 === -2147483648. Actual: ' + (6442450944.1 << 0)); 
} 

//CHECK#4
if (4294967295.1 << 0 !== -1) { 
  warn('#4: 4294967295.1 << 0 === -1. Actual: ' + (4294967295.1 << 0)); 
} 

//CHECK#5
if (6442450943.1 << 0 !== 2147483647) { 
  warn('#5: 6442450943.1 << 0 === 2147483647. Actual: ' + (6442450943.1 << 0)); 
} 

//CHECK#6
if (-2147483649.1 << 0 !== 2147483647) { 
  warn('#6: -2147483649.1 << 0 === 2147483647. Actual: ' + (-2147483649.1 << 0)); 
} 

//CHECK#7
if (-4294967297.1 << 0 !== -1) { 
  warn('#7: -4294967297.1 << 0 === -1. Actual: ' + (-4294967297.1 << 0)); 
} 

//CHECK#8
if (-6442450945.1 << 0 !== 2147483647) { 
  warn('#8: -6442450945.1 << 0 === 2147483647. Actual: ' + (-6442450945.1 << 0)); 
} 

//CHECK#9
if (-4294967296.1 << 0 !== 0) { 
  warn('#9: -4294967296.1 << 0 === 0 . Actual: ' + (-4294967296.1 << 0)); 
} 

//CHECK#10
if (-6442450944.1 << 0 !== -2147483648) { 
  warn('#10: -6442450944.1 << 0 === -2147483648. Actual: ' + (-6442450944.1 << 0)); 
} 
