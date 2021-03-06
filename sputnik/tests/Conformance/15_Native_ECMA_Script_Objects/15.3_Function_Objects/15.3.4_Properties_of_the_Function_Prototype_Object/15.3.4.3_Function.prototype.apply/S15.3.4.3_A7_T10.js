// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.3.4.3_A7_T10;
* @section: 15.3.4.3;
* @assertion: If argArray is either an array or an arguments object, 
* the function is passed the (ToUint32(argArray.length)) arguments argArray[0], argArray[1],...,argArray[ToUint32(argArray.length)-1];
* @description: argArray is (empty object, arguments), inside function call without declaration used;
*/

var obj={};

(function (){
  Function("a1,a2,a3","this.shifted=a1+a2+a3;").apply(obj,arguments);
})("",4,2);

//CHECK#1
if (obj["shifted"] !== "42") {
  warn('#1: If argArray is either an array or an arguments object, the function is passed the...');
}

//CHECK#2
if (typeof this["shifted"] !== "undefined") {
  warn('#2: If argArray is either an array or an arguments object, the function is passed the...');
}

