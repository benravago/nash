// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S13.2_A5;
* @section: 13.2, 15.3.3.1;
* @assertion: When Function object(F) is constructed 
* the [[Prototype]] property of F is set to the original Function prototype object as specified in 15.3.3.1;
* @description: Function.prototype.isPrototypeOf() is used;
*/

function __func(){};

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (!(Function.prototype.isPrototypeOf(__func))) {
	warn('#1: Function.prototype.isPrototypeOf(__func)');
}
//
//////////////////////////////////////////////////////////////////////////////


var __gunc = function(){};

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (!(Function.prototype.isPrototypeOf(__gunc))) {
	warn('#1: Function.prototype.isPrototypeOf(__gunc)');
}
//
//////////////////////////////////////////////////////////////////////////////


