// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.17_A1_T10;
* @section: 15.5.4.17;
* @assertion: String.prototype.toLocaleLowerCase();
* @description: Call toLocaleLowerCase() function of object with overrode toString function;
*/

var __obj = {toString:function(){return "\u0041B";}}
__obj.toLocaleLowerCase = String.prototype.toLocaleLowerCase;

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (__obj.toLocaleLowerCase() !=="ab") {
  warn('#1: var __obj = {toString:function(){return "\u0041B";}}; __obj.toLocaleLowerCase = String.prototype.toLocaleLowerCase; __obj.toLocaleLowerCase() ==="ab". Actual: '+__obj.toLocaleLowerCase() );
}
//
//////////////////////////////////////////////////////////////////////////////
