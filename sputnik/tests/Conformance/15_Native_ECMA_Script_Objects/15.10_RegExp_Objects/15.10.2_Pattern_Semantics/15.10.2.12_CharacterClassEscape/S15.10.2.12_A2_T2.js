// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.10.2.12_A2_T2;
* @section: 15.10.2.12, 7.2, 7.3;
* @assertion: The production CharacterClassEscape :: S evaluates by returning 
* the set of all characters not included in the set returned by 
* CharacterClassEscape :: s;
* @description: LineTerminator; 
*/

//CHECK#1
var arr = /\S/.exec("\u000A");
if (arr !== null) {
  warn('#1: var arr = /\\S/.exec("\\u000A"); arr[0] === "\\u000A". Actual. ' + (arr && arr[0]));
}

//CHECK#2
var arr = /\S/.exec("\u000D");
if (arr !== null) {
  warn('#2: var arr = /\\S/.exec("\\u000D"); arr[0] === "\\u000D". Actual. ' + (arr && arr[0]));
}  

//CHECK#3
var arr = /\S/.exec("\u2028");
if (arr !== null) {
  warn('#3: var arr = /\\S/.exec("\\u2028"); arr[0] === "\\u2028". Actual. ' + (arr && arr[0]));
}    

//CHECK#4
var arr = /\S/.exec("\u2029");
if (arr !== null) {
  warn('#4: var arr = /\\S/.exec("\\u2029"); arr[0] === "\\u2029". Actual. ' + (arr && arr[0]));
}  
