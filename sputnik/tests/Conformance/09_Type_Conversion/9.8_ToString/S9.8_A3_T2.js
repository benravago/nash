// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.8_A3_T2;
 * @section: 9.8;
 * @assertion: Result of ToString conversion from boolean value is "true" if 
 * the argument is "true", else is "false";
 * @description: True and false convert to String by implicit transformation;
 */

// CHECK#1
if (false + "" !== "false") {
  warn('#1: false + "" === "false". Actual: ' + (false + ""));
}

// CHECK#2
if (true + "" !== "true") {
  warn('#2: true + "" === "true". Actual: ' + (true + ""));	
}
