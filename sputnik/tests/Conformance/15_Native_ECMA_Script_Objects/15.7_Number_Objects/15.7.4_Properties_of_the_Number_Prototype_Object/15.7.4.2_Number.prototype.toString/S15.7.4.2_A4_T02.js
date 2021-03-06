// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.4.2_A4_T02;
 * @section: 15.7.4.2;
 * @assertion: The toString function is not generic, it cannot be transferred 
 * to other kinds of objects for use as a method and there is should be 
 * a TypeError exception if its this value is not a Number object;
 * @description: transferring to the Boolean objects;
*/

//CHECK#1
try{
  var s1 = new Boolean();
  s1.toString = Number.prototype.toString;
  var v1 = s1.toString(); 
  warn('#1: Number.prototype.toString on not a Number object should throw TypeError');
}
catch(e){
  if(!(e instanceof TypeError)){
    warn('#1: Number.prototype.toString on not a Number object should throw TypeError, not '+e);
  }
}

//CHECK#2
try{
  var s2 = new Boolean();
  s2.myToString = Number.prototype.toString;
  var v2 = s2.myToString(); 
  warn('#2: Number.prototype.toString on not a Number object should throw TypeError');
}
catch(e){
  if(!(e instanceof TypeError)){
    warn('#2: Number.prototype.toString on not a Number object should throw TypeError, not '+e);
  }
}

