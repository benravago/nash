// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.4.5_A1.3_T01;
 * @section: 15.7.4.5;
 * @assertion: Step 4: If this number value is NaN, return the string "NaN";
 * @description: NaN is computed by new Number("string");
*/

//CHECK#1
if((new Number("a")).toFixed() !== "NaN"){
  warn('#1: (new Number("a")).prototype.toFixed() === "NaN"');
}

//CHECK#2
if((new Number("a")).toFixed(0) !== "NaN"){
  warn('#2: (new Number("a")).prototype.toFixed(0) === "NaN"');
}

//CHECK#3
if((new Number("a")).toFixed(1) !== "NaN"){
  warn('#3: (new Number("a")).prototype.toFixed(1) === "NaN"');
}

//CHECK#4
if((new Number("a")).toFixed(1.1) !== "NaN"){
  warn('#4: (new Number("a")).toFixed(1.1) === "NaN"');
}

//CHECK#5
if((new Number("a")).toFixed(0.9) !== "NaN"){
  warn('#5: (new Number("a")).toFixed(0.9) === "NaN"');
}

//CHECK#6
if((new Number("a")).toFixed("1") !== "NaN"){
  warn('#6: (new Number("a")).toFixed("1") === "NaN"');
}

//CHECK#7
if((new Number("a")).toFixed("1.1") !== "NaN"){
  warn('#7: (new Number("a")).toFixed("1.1") === "NaN"');
}

//CHECK#8
if((new Number("a")).toFixed("0.9") !== "NaN"){
  warn('#8: (new Number("a")).toFixed("0.9") === "NaN"');
}

//CHECK#9
if((new Number("a")).toFixed(Number.NaN) !== "NaN"){
  warn('#9: (new Number("a")).toFixed(Number.NaN) === "NaN"');
}

//CHECK#10
if((new Number("a")).toFixed("some string") !== "NaN"){
  warn('#9: (new Number("a")).toFixed("some string") === "NaN"');
}

//CHECK#10
try{
  s = (new Number("a")).toFixed(Number.POSITIVE_INFINITY);
  warn('#10: (new Number("a")).toFixed(Number.POSITIVE_INFINITY) should throw RangeError, not return NaN');
}
catch(e){
  if(!(e instanceof RangeError)){
    warn('#10: (new Number("a")).toFixed(Number.POSITIVE_INFINITY) should throw RangeError, not '+e);
  }
}
