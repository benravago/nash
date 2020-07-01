// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.2.1_A1;
 * @section: 15.9.2.1;
 * @assertion: When Date is called as a function rather than as a constructor, 
 * it should be "string" representing the current time (UTC);
 * @description: Checking type of returned value;
*/

//CHECK#1
if( typeof Date() !== "string" ) {
  warn('#1: typeof Date() should be "string", actual is '+(typeof Date()));
}

//CHECK#2
if( typeof Date(1) !== "string"  ) {
  warn('#2: typeof Date(1) should be "string", actual is '+(typeof Date(1)));
}

//CHECK#3
if( typeof Date(1970, 1) !== "string"  ) {
  warn('#3: typeof Date(1970, 1) should be "string", actual is '+(typeof Date(1970, 1)));
}

//CHECK#4
if( typeof Date(1970, 1, 1) !== "string"  ) {
  warn('#4: typeof Date(1970, 1, 1) should be "string", actual is '+(typeof Date(1970, 1, 1)));
}

//CHECK#5
if( typeof Date(1970, 1, 1, 1) !== "string"  ) {
  warn('#5: typeof Date(1970, 1, 1, 1) should be "string", actual is '+(typeof Date(1970, 1, 1, 1)));
}

//CHECK#6
if( typeof Date(1970, 1, 1, 1) !== "string"  ) {
  warn('#7: typeof Date(1970, 1, 1, 1) should be "string", actual is '+(typeof Date(1970, 1, 1, 1)));
}

//CHECK#8
if( typeof Date(1970, 1, 1, 1, 0) !== "string"  ) {
  warn('#8: typeof Date(1970, 1, 1, 1, 0) should be "string", actual is '+(typeof Date(1970, 1, 1, 1, 0)));
}

//CHECK#9
if( typeof Date(1970, 1, 1, 1, 0, 0) !== "string"  ) {
  warn('#9: typeof Date(1970, 1, 1, 1, 0, 0) should be "string", actual is '+(typeof Date(1970, 1, 1, 1, 0, 0)));
}

//CHECK#10
if( typeof Date(1970, 1, 1, 1, 0, 0, 0) !== "string"  ) {
  warn('#10: typeof Date(1970, 1, 1, 1, 0, 0, 0) should be "string", actual is '+(typeof Date(1970, 1, 1, 1, 0, 0, 0)));
}

//CHECK#11
if( typeof Date(Number.NaN) !== "string"  ) {
  warn('#11: typeof Date(Number.NaN) should be "string", actual is '+(typeof Date(Number.NaN)));
}

//CHECK#12
if( typeof Date(Number.POSITIVE_INFINITY) !== "string"  ) {
  warn('#12: typeof Date(Number.POSITIVE_INFINITY) should be "string", actual is '+(typeof Date(Number.POSITIVE_INFINITY)));
}

//CHECK#13
if( typeof Date(Number.NEGATIVE_INFINITY) !== "string"  ) {
  warn('#13: typeof Date(Number.NEGATIVE_INFINITY) should be "string", actual is '+(typeof Date(Number.NEGATIVE_INFINITY)));
}

//CHECK#14
if( typeof Date(undefined) !== "string"  ) {
  warn('#14: typeof Date(undefined) should be "string", actual is '+(typeof Date(undefined)));
}

//CHECK#15
if( typeof Date(null) !== "string"  ) {
  warn('#15: typeof Date(null) should be "string", actual is '+(typeof Date(null)));
}
