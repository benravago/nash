// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.4.2_A2_T15;
 * @section: 15.7.4.2;
 * @assertion: toString: If radix is an integer from 2 to 36, but not 10, 
 * the result is a string, the choice of which is implementation-dependent;
 * @description: radix is 17;
*/

//CHECK#1
if(Number.prototype.toString(17) !== "0"){
  warn('#1: Number.prototype.toString(17) === "0"');
}

//CHECK#2
if((new Number()).toString(17) !== "0"){
  warn('#2: (new Number()).toString(17) === "0"');
}

//CHECK#3
if((new Number(0)).toString(17) !== "0"){
  warn('#3: (new Number(0)).toString(17) === "0"');
}

//CHECK#4
if((new Number(-1)).toString(17) !== "-1"){
  warn('#4: (new Number(-1)).toString(17) === "-1"');
}

//CHECK#5
if((new Number(1)).toString(17) !== "1"){
  warn('#5: (new Number(1)).toString(17) === "1"');
}

//CHECK#6
if((new Number(Number.NaN)).toString(17) !== "NaN"){
  warn('#6: (new Number(Number.NaN)).toString(17) === "NaN"');
}

//CHECK#7
if((new Number(Number.POSITIVE_INFINITY)).toString(17) !== "Infinity"){
  warn('#7: (new Number(Number.POSITIVE_INFINITY)).toString(17) === "Infinity"');
}

//CHECK#8
if((new Number(Number.NEGATIVE_INFINITY)).toString(17) !== "-Infinity"){
  warn('#8: (new Number(Number.NEGATIVE_INFINITY)).toString(17) === "-Infinity"');
}
