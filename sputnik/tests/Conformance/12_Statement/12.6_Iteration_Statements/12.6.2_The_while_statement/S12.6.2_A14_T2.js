// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S12.6.2_A14_T2;
* @section: 12.6.2;
* @assertion: FunctionExpression within a "while" Expression is allowed;
* @description: Using function call as an Expression;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#
while(function __func(){return 1;}()){
    var __reached = 1;
   break;
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__reached !== 1) {
	warn('#2: function expression inside of while expression is allowed');
}
//
//////////////////////////////////////////////////////////////////////////////
