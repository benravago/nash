// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.2_A4_T7;
 * @section: 11.5.2;
 * @assertion: The result of division is determined by the specification of IEEE 754 arithmetics; 
 * @description: Division of a zero by a zero results in NaN;
 */

//CHECK#1
if (isNaN(+0 / +0) !== true) {
  warn('#1: +0 / +0 === Not-a-Number. Actual: ' + (+0 / +0));
}  

//CHECK#2
if (isNaN(-0 / +0) !== true) {
  warn('#2: -0 / +0 === Not-a-Number. Actual: ' + (-0 / +0)); 
} 

//CHECK#3
if (isNaN(+0 / -0) !== true) {
  warn('#3: +0 / -0 === Not-a-Number. Actual: ' + (+0 / -0)); 
} 

//CHECK#4
if (isNaN(-0 / -0) !== true) {
  warn('#4: -0 / -0 === Not-a-Number. Actual: ' + (-0 / -0));
} 
