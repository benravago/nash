// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.6_A7_T2;
* @section: 11.8.6;
* @assertion: When "instanceof" returns true it means that GetValue(RelationalExpression) is constructed with ShiftExpression;
* @description: Checking Array object;
*/

var __arr=[];

//CHECK#1
if (!(__arr instanceof Array)) {
	warn('#1: If instanceof returns true then GetValue(RelationalExpression) was constructed with ShiftExpression');
}

//CHECK#2
if (__arr.constructor !== Array) {
	warn('#2: If instanceof returns true then GetValue(RelationalExpression) was constructed with ShiftExpression');
}
