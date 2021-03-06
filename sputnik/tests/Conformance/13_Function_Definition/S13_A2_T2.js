// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S13_A2_T2;
* @section: 13;
* @assertion: function must be evaluated inside the expression;
* @description: Defining function body with "return arg + arguments[1]";
*/

var x = (function __func(arg){return arg + arguments[1]})(1,"1");

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (x !== "11") {
	warn('#1: x === "11". Actual: x ==='+x);
}

//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (typeof __func !== 'undefined') {
	warn('#2: typeof __func === \'undefined\'. Actual: typeof __func ==='+typeof __func);
}
//
//////////////////////////////////////////////////////////////////////////////
