// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.4_A1_T1;
 * @section: 15.1.2.4;
 * @assertion: isNaN applies ToNumber to its argument, then return true if the result is NaN, and otherwise return false;
 * @description: Checking all primitive;
*/

// CHECK#1
if (!(isNaN(NaN) === true)) {
	warn('#1: NaN === Not-a-Number. Actual: ' + (NaN)); 
}

// CHECK#2
if (!(isNaN(Number.NaN) === true)) {
	warn('#2: Number.NaN === Not-a-Number. Actual: ' + (Number.NaN)); 
}

// CHECK#3
if (!(isNaN(Number(void 0)) === true)) {
	warn('#3: Number(void 0) === Not-a-Number. Actual: ' + (Number(void 0))); 
}

// CHECK#4
if (!(isNaN(void 0) === true)) {
	warn('#4: void 0 === Not-a-Number. Actual: ' + (void 0)); 
}

// CHECK#5
if (!(isNaN("string") === true)) {
	warn('#5: "string" === Not-a-Number. Actual: ' + ("string")); 
}

// CHECK#6
if (isNaN(Number.POSITIVE_INFINITY) === true) {
	warn('#6: Number.POSITIVE_INFINITY !== Not-a-Number'); 
}

// CHECK#7
if (isNaN(Number.NEGATIVE_INFINITY) === true) {
	warn('#7: Number.NEGATIVE_INFINITY !== Not-a-Number'); 
}

// CHECK#8
if (isNaN(Number.MAX_VALUE) === true) {
	warn('#8: Number.MAX_VALUE !== Not-a-Number'); 
}

// CHECK#9
if (isNaN(Number.MIN_VALUE) === true) {
	warn('#9: Number.MIN_VALUE !== Not-a-Number'); 
}

// CHECK#10
if (isNaN(-0) === true) {
	warn('#10: -0 !== Not-a-Number'); 
}

// CHECK#11
if (isNaN(true) === true) {
  warn('#11: true !== Not-a-Number'); 
}

// CHECK#12
if (isNaN("1") === true) {
  warn('#12: "1" !== Not-a-Number'); 
}




