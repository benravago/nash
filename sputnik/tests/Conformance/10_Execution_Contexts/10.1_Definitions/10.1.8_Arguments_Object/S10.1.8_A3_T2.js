// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.8_A3_T2;
 * @section: 10.1.8;
 * @assertion: A property is created with name callee with property 
 * attributes { DontEnum } and no others;
 * @description: Checking if enumerating the arguments.callee property fails;  
*/

//CHECK#1
function f1(){
  for(var x in arguments){
    if (x === "callee"){
      return false;
    }
  }
  return true;
}

try{
  if(!f1()){
    warn("#1: A property callee don't have attribute { DontEnum }");
  }
}
catch(e){
  warn("#1: arguments object don't exists");
}

//CHECK#2
var f2 = function(){
  for(var x in arguments){
    if (x === "callee"){
      return false;
    }
  }
  return true;
}

try{
  if(!f2()){
    warn("#2: A property callee don't have attribute { DontEnum }");
  }
}
catch(e){
  warn("#2: arguments object don't exists");
}
