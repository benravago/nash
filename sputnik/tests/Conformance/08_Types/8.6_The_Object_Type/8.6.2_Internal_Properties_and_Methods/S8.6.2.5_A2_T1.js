// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S8.6.2.5_A2_T1;
* @section: 8.6.2.5, 11.4.1;
* @assertion: When the [[Delete]] method of O is called with property name P, 
* and if O doesn't have a property with name P, return true;
* @description: Try to delete not existent properties; 
*/

var __color__map = {};

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (delete __color__map.red !== true){
  warn('#1: var __color__map = {}; delete __color__map.red === true. Actual: ' + (delete __color__map.red));
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (delete __color__map["green"] !== true){
  warn('#2: var __color__map = {}; delete __color__map["green"] === true. Actual: ' + (delete __color__map["green"]));
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
var blue = 1;
if (delete __color__map[blue] !== true){
  warn('#3: var __color__map = {}; var blue = 1; delete __color__map[blue] === true. Actual: ' + (delete __color__map[blue]));
};
//
//////////////////////////////////////////////////////////////////////////////

