// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S7.4_A1_T1;
 * @section: 7.4;
 * @assertion: Correct interpretation of single line comments;
 * @description: Create comments with any code;  
*/

//CHECK#1
// warn('#1: Correct interpretation single line comments');

//CHECK#2
var x = 0;
// x = 1;
if (x !== 0) {
  warn('#2: var x = 0; // x = 1; x === 0. Actual: ' + (x));
}

//CHECK#3
var // y = 1; 
y;
if (y !== undefined) {
  warn('#3: var // y = 1; \\n y; y === undefined. Actual: ' + (y));
}  

//CHECK#4
//warn('#4: Correct interpretation single line comments') //$ERROR('#4: Correct interpretation single line comments'); //

////CHECK#5
//var x = 1;
//if (x === 1) {
//  warn('#5: Correct interpretation single line comments');
//}

//CHECK#6
//var this.y = 1; 
this.y++;
if (isNaN(y) !== true) {
  warn('#6: //var this.y = 1; \\n this.y++; y === Not-a-Number. Actual: ' + (y));
}

