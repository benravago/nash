// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.1_A4_T1.1;
 * @section: 11.5.1;
 * @assertion: The result of a floating-point multiplication is governed by the rules of IEEE 754 double-precision arithmetics;
 * @description: If left operand is NaN, the result is NaN;
 */

//CHECK#1
if (isNaN(Number.NaN * Number.NaN) !== true) {
  warn('#1: NaN * NaN === Not-a-Number. Actual: ' + (NaN * NaN));
}  

//CHECK#2
if (isNaN(Number.NaN * +0) !== true) {
  warn('#2: NaN * +0 === Not-a-Number. Actual: ' + (NaN * +0)); 
} 

//CHECK#3
if (isNaN(Number.NaN * -0) !== true) {
  warn('#3: NaN * -0 === Not-a-Number. Actual: ' + (NaN * -0)); 
} 

//CHECK#4
if (isNaN(Number.NaN * Number.POSITIVE_INFINITY) !== true) {
  warn('#4: NaN * Infinity === Not-a-Number. Actual: ' + (NaN * Infinity));
} 

//CHECK#5
if (isNaN(Number.NaN * Number.NEGATIVE_INFINITY) !== true) {
  warn('#5: NaN * -Infinity === Not-a-Number. Actual: ' + (NaN * -Infinity)); 
} 

//CHECK#6
if (isNaN(Number.NaN * Number.MAX_VALUE) !== true) {
  warn('#6: NaN * Number.MAX_VALUE === Not-a-Number. Actual: ' + (NaN * Number.MAX_VALUE));
} 

//CHECK#7
if (isNaN(Number.NaN * Number.MIN_VALUE) !== true) {
  warn('#7: NaN * Number.MIN_VALUE === Not-a-Number. Actual: ' + (NaN * Number.MIN_VALUE)); 
}

//CHECK#8
if (isNaN(Number.NaN * 1) !== true) {
  warn('#8: NaN * 1 === Not-a-Number. Actual: ' + (NaN * 1));  
} 
