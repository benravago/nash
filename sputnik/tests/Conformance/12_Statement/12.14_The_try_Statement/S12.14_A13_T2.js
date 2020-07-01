// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S12.14_A13_T2;
 * @section: 12.14;
 * @assertion: Using "try" with "catch" or "finally" statement with a "return" statement;
 * @description: Using try/finally syntax construction;
 */

// CHECK#1
var c1=0;
function myFunction1(){
  try{
    return 1;
  }finally{
    c1=1;
  }
  return 2;
}
var x1=myFunction1();
if(x1!==1){
  warn('#1.1: x1===1. Actual: x1==='+x1);
}
if (c1!==1){
  warn('#1.2: "finally" block must be evaluated');
}

// CHECK#2
var c2=0;
function myFunction2(){
  try{
    throw "exc";
    return 1;
  }finally{
    c2=1;
  }
  return 2;
}
try{
  var x2=myFunction2();
  warn('#2.1: Throwing exception inside function lead to throwing exception outside this function');
}
catch(e){
  if (c2!==1){
    warn('#2.2: "finally" block must be evaluated');
  }
}

// CHECK#3
var c3=0;
function myFunction3(){
  try{
    return someValue;
  }finally{
    c3=1;
  }
  return 2;
}
try{
  var x3=myFunction3();
  warn('#3.1: Throwing exception inside function lead to throwing exception outside this function');
}
catch(e){
  if (c3!==1){
    warn('#3.2: "finally" block must be evaluated');
  }
}

// CHECK#4
var c4=0;
function myFunction4(){
  try{
    return 1;
  }finally{
    c4=1;
    throw "exc";
    return 0;
  }
  return 2;
}
try{
  var x4=myFunction4();
  warn('#4.2: Throwing exception inside function lead to throwing exception outside this function');
}
catch(e){
  if (c4!==1){
    warn('#4.3: "finally" block must be evaluated');
  }
}

// CHECK#5
var c5=0;
function myFunction5(){
  try{
    return 1;
  }finally{
    c5=1;
    return someValue;
    return 0;
  }
  return 2;
}
try{
  var x5=myFunction5();
  warn('#5.2: Throwing exception inside function lead to throwing exception outside this function');
}
catch(e){
  if (c5!==1){
    warn('#5.3: "finally" block must be evaluated');
  }
}

// CHECK#6
var c6=0;
function myFunction6(){
  try{
    throw "ex1";
    return 1;
  }finally{
    c6=1;
    throw "ex2";
    return 2;
  }
  return 3;
}
try{
  var x6=myFunction6();
  warn('#6.1: Throwing exception inside function lead to throwing exception outside this function');
}
catch(e){
  if(e==="ex1"){
    warn('#6.2: Exception !=="ex1". Actual: catch previous exception');
  }
  if(e!=="ex2"){
    warn('#6.3: Exception !=="ex1". Actual: '+e);
  }
  if (c6!==1){
    warn('#6.4: "finally" block must be evaluated');
  }
}

// CHECK#7
var c7=0;
function myFunction7(){
  try{
    return 1;
  }finally{
    c7=1;
    return 2;
  }
  return 3;
}
var x7=myFunction7();
if(x7!==2){
  warn('#7.1: "catch" block must be evaluated');
}
if (c7!==1){
  warn('#7.2: "finally" block must be evaluated');
}

// CHECK#8
var c8=0;
function myFunction8(){
  try{
    throw "ex1";
  }finally{
    c8=1;
    return 2;
  }
  return 3;
}
try{
  var x8=myFunction8();
}
catch(ex1){
  c8=10;
}
if (c8!==1){
  warn('#8: "finally" block must be evaluated');
}
