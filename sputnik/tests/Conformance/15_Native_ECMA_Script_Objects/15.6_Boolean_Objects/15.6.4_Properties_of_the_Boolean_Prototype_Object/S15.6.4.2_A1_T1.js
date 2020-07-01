// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.6.4.2_A1_T1;
 * @section: 15.6.4.2;
 * @assertion: toString: If this boolean value is true, then the string "true" 
 * is returned, otherwise, this boolean value must be false, and the string 
 * "false" is returned;
 * @description: no arguments;
 */

//CHECK#1
if(Boolean.prototype.toString() !== "false"){
  warn('#1: Boolean.prototype.toString() === "false"');
}

//CHECK#2
if((new Boolean()).toString() !== "false"){
  warn('#2: (new Boolean()).toString() === "false"');
}

//CHECK#3
if((new Boolean(false)).toString() !== "false"){
  warn('#3: (new Boolean(false)).toString() === "false"');
}

//CHECK#4
if((new Boolean(true)).toString() !== "true"){
  warn('#4: (new Boolean(true)).toString() === "true"');
}

//CHECK#5
if((new Boolean(1)).toString() !== "true"){
  warn('#5: (new Boolean(1)).toString() === "true"');
}

//CHECK#6
if((new Boolean(0)).toString() !== "false"){
  warn('#6: (new Boolean(0)).toString() === "false"');
}

//CHECK#7
if((new Boolean(new Object())).toString() !== "true"){
  warn('#7: (new Boolean(new Object())).toString() === "true"');
}
