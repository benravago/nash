// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S12.6.3_A14;
* @section: 12.6.3;
* @assertion: The production IterationStatement: "for (var VariableDeclarationListNoIn; Expression; Expression) Statement";
* @description: Using +,*,/, as the second Expression;
*/

//CHECK#1
for(var i=0;i<10;i++){}
if (i!==10)	warn('#1: i === 10. Actual:  i ==='+ i  );

//CHECK#2
var j=0;
for(var i=1;i<10;i*=2){
	j++;
}
if (i!==16)  warn('#2.1: i === 16. Actual:  i ==='+ i  );
if (j!==4)  warn('#2.2: j === 4. Actual:  j ==='+ j  );

//CHECK#3
var j=0;
for(var i=16;i>1;i=i/2){
  j++;
}
if (i!==1)  warn('#3.1: i === 1. Actual:  i ==='+ i  );
if (j!==4)  warn('#3.2: j === 4. Actual:  j ==='+ j  );

//CHECK#4
var j=0;
for(var i=10;i>1;i--){
  j++;
}
if (i!==1)  warn('#4.1: i === 1. Actual:  i ==='+ i  );
if (j!==9)  warn('#4.2: j === 9. Actual:  j ==='+ j  );

//CHECK#5
var j=0;
for(var i=2;i<10;i*=i){
  j++;
}
if (i!==16)  warn('#5.1: i === 16. Actual:  i ==='+ i  );
if (j!==2)  warn('#5.2: j === 2. Actual:  j ==='+ j  );
