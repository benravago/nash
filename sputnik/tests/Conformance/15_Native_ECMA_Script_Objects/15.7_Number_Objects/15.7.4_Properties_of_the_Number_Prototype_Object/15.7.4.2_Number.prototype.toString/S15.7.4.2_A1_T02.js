// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.4.2_A1_T02;
 * @section: 15.7.4.2;
 * @assertion: toString: If radix is the number 10 or undefined, then this 
 * number value is given as an argument to the ToString operator. 
 * the resulting string value is returned;
 * @description: radix is 10;
*/

//CHECK#1
if(Number.prototype.toString(10) !== "0"){
  warn('#1: Number.prototype.toString(10) === "0"');
}

//CHECK#2
if((new Number()).toString(10) !== "0"){
  warn('#2: (new Number()).toString(10) === "0"');
}

//CHECK#3
if((new Number(0)).toString(10) !== "0"){
  warn('#3: (new Number(0)).toString(10) === "0"');
}

//CHECK#4
if((new Number(-1)).toString(10) !== "-1"){
  warn('#4: (new Number(-1)).toString(10) === "-1"');
}

//CHECK#5
if((new Number(1)).toString(10) !== "1"){
  warn('#5: (new Number(1)).toString(10) === "1"');
}

//CHECK#6
if((new Number(Number.NaN)).toString(10) !== "NaN"){
  warn('#6: (new Number(Number.NaN)).toString(10) === "NaN"');
}

//CHECK#7
if((new Number(Number.POSITIVE_INFINITY)).toString(10) !== "Infinity"){
  warn('#7: (new Number(Number.POSITIVE_INFINITY)).toString(10) === "Infinity"');
}

//CHECK#8
if((new Number(Number.NEGATIVE_INFINITY)).toString(10) !== "-Infinity"){
  warn('#8: (new Number(Number.NEGATIVE_INFINITY)).toString(10) === "-Infinity"');
}
