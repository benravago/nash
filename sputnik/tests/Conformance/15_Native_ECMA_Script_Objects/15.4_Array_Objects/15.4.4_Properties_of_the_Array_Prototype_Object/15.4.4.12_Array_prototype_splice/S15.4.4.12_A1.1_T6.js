// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.12_A1.1_T6;
 * @section: 15.4.4.12;
 * @assertion: If start is positive, use min(start, length). 
 * If deleteCount is positive, use min(deleteCount, length - start);
 * @description: length = deleteCount > start > 0, itemCount > 0; 
*/

var x = [0,1,2,3];
var arr = x.splice(1,4,4,5);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 3) {
  warn('#2: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); arr.length === 3. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 1) {
  warn('#3: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); arr[0] === 1. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 2) {
  warn('#4: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); arr[1] === 2. Actual: ' + (arr[1]));
}      

//CHECK#5
if (arr[2] !== 3) {
  warn('#5: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); arr[2] === 3. Actual: ' + (arr[2]));
}   

//CHECK#6
if (x.length !== 3) {
  warn('#6: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); x.length === 3. Actual: ' + (x.length));
} 

//CHECK#7
if (x[0] !== 0) {
  warn('#7: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); x[0] === 0. Actual: ' + (x[0]));
}

//CHECK#8
if (x[1] !== 4) {
  warn('#8: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); x[1] === 4. Actual: ' + (x[1]));
} 

//CHECK#9
if (x[2] !== 5) {
  warn('#9: var x = [0,1,2,3]; var arr = x.splice(1,4,4,5); x[2] === 5. Actual: ' + (x[2]));
}  
