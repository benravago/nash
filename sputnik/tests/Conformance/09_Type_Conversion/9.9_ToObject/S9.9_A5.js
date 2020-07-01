// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.9_A5;
 * @section: 9.9;
 * @assertion: ToObject conversion from String: create a new String object 
 * whose [[value]] property is set to the value of the string;
 * @description: Converting from various strings to Object; 
*/

// CHECK#1
if (Object("some string").valueOf() !== "some string"){
  warn('#1: Object("some string").valueOf() === "some string". Actual: ' + (Object("some string").valueOf()));
}

// CHECK#2
if (typeof Object("some string") !== "object"){
  warn('#2: typeof Object("some string") === "object". Actual: ' + (typeof Object("some string")));
}

// CHECK#3
if (Object("some string").constructor.prototype !== String.prototype){
  warn('#3: Object("some string").constructor.prototype === String.prototype. Actual: ' + (Object("some string").constructor.prototype));
}

// CHECK#4
if (Object("").valueOf() !== ""){
  warn('#4: Object("").valueOf() === false. Actual: ' + (Object("").valueOf()));
}

// CHECK#5
if (typeof Object("") !== "object"){
  warn('#5: typeof Object("") === "object". Actual: ' + (typeof Object("")));
}

// CHECK#6
if (Object("").constructor.prototype !== String.prototype){
  warn('#6: Object("").constructor.prototype === String.prototype. Actual: ' + (Object("").constructor.prototype));
}

// CHECK#7
if (Object("\r\t\b\n\v\f").valueOf() !== "\r\t\b\n\v\f"){
  warn('#7: Object("\\r\\t\\b\\n\\v\\f").valueOf() === false. Actual: ' + (Object("\r\t\b\n\v\f").valueOf()));
}

// CHECK#8
if (typeof Object("\r\t\b\n\v\f") !== "object"){
  warn('#8: typeof Object("\\r\\t\\b\\n\\v\\f") === "object". Actual: ' + (typeof Object("\r\t\b\n\v\f")));
}

// CHECK#9
if (Object("\r\t\b\n\v\f").constructor.prototype !== String.prototype){
  warn('#9: Object("\\r\\t\\b\\n\\v\\f").constructor.prototype === String.prototype. Actual: ' + (Object("\r\t\b\n\v\f").constructor.prototype));
}

// CHECK#10
if (Object(String(10)).valueOf() !== "10"){
  warn('#10: Object(String(10)).valueOf() === false. Actual: ' + (Object(String(10)).valueOf()));
}

// CHECK#11
if (typeof Object(String(10)) !== "object"){
  warn('#11: typeof Object(String(10)) === "object". Actual: ' + (typeof Object(String(10))));
}

// CHECK#12
if (Object(String(10)).constructor.prototype !== String.prototype){
  warn('#12: Object(String(10)).constructor.prototype === String.prototype. Actual: ' + (Object(String(10)).constructor.prototype));
}
