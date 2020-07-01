// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.4.5_A1.1_T01;
 * @section: 15.7.4.5;
 * @assertion: Step 1: Let f be ToInteger(fractionDigits). (If fractionDigits 
 * is undefined, this step produces the value 0);
 * @description: calling on Number prototype object;
*/

//CHECK#1
if(Number.prototype.toFixed() !== "0"){
  warn('#1: Number.prototype.toFixed() === "0"');
}

//CHECK#2
if(Number.prototype.toFixed(0) !== "0"){
  warn('#2: Number.prototype.toFixed(0) === "0"');
}

//CHECK#3
if(Number.prototype.toFixed(1) !== "0.0"){
  warn('#3: Number.prototype.toFixed(1) === "0.0"');
}

//CHECK#4
if(Number.prototype.toFixed(1.1) !== "0.0"){
  warn('#4: Number.prototype.toFixed(1.1) === "0.0"');
}

//CHECK#5
if(Number.prototype.toFixed(0.9) !== "0"){
  warn('#5: Number.prototype.toFixed(0.9) === "0"');
}

//CHECK#6
if(Number.prototype.toFixed("1") !== "0.0"){
  warn('#6: Number.prototype.toFixed("1") === "0.0"');
}

//CHECK#7
if(Number.prototype.toFixed("1.1") !== "0.0"){
  warn('#7: Number.prototype.toFixed("1.1") === "0.0"');
}

//CHECK#8
if(Number.prototype.toFixed("0.9") !== "0"){
  warn('#8: Number.prototype.toFixed("0.9") === "0"');
}

//CHECK#9
if(Number.prototype.toFixed(Number.NaN) !== "0"){
  warn('#9: Number.prototype.toFixed(Number.NaN) === "0"');
}

//CHECK#10
if(Number.prototype.toFixed("some string") !== "0"){
  warn('#9: Number.prototype.toFixed("some string") === "0"');
}

//CHECK#10
try{
  if(Number.prototype.toFixed(-0.1) !== "0"){
    warn('#10: Number.prototype.toFixed(-0.1) === "0"');
  }
}
catch(e){
  warn('#10: Number.prototype.toFixed(-0.1) should not throw '+e);
}
