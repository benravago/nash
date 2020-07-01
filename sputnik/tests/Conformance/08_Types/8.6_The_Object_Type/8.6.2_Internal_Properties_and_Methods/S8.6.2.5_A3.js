// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S8.6.2.5_A3;
* @section: 8.6.2.5, 11.4.1;
* @assertion: When the [[Delete]] method of O is called with property name P,
* removes the property with name P from O and return true;
* @description: Delete existent properties;
*/
var BLUE_NUM=1;
var BLUE_STR="1";
var YELLOW_NUM=2;
var YELLOW_STR="2";
var __color__map = {red:0xFF0000, BLUE_NUM:0x0000FF, green:0x00FF00, YELLOW_STR:0xFFFF00};

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (delete __color__map[YELLOW_NUM] !== true){
  warn('#1: var BLUE_NUM=1; var BLUE_STR="1"; var YELLOW_NUM=2; var YELLOW_STR="2"; var __color__map = {red:0xFF0000, BLUE_NUM:0x0000FF, green:0x00FF00, YELLOW_STR:0xFFFF00}; delete __color__map[YELLOW_NUM] === true;');
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__color__map[YELLOW_STR] !== undefined) {
  warn('#2: var BLUE_NUM=1; var BLUE_STR="1"; var YELLOW_NUM=2; var YELLOW_STR="2"; var __color__map = {red:0xFF0000, BLUE_NUM:0x0000FF, green:0x00FF00, YELLOW_STR:0xFFFF00}; delete __color__map[YELLOW_NUM]; __color__map[YELLOW_STR] === undefined. Actual: ' + (__color__map[YELLOW_STR]));
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (delete __color__map[BLUE_STR] !== true){
  warn('#3: var BLUE_NUM=1; var BLUE_STR="1"; var YELLOW_NUM=2; var YELLOW_STR="2"; var __color__map = {red:0xFF0000, BLUE_NUM:0x0000FF, green:0x00FF00, YELLOW_STR:0xFFFF00}; delete __color__map[BLUE_STR] === true. Actual: ' + (delete __color__map[BLUE_STR]));
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if (__color__map[BLUE_NUM] !== undefined) {
  warn('#4: var BLUE_NUM=1; var BLUE_STR="1"; var YELLOW_NUM=2; var YELLOW_STR="2"; var __color__map = {red:0xFF0000, BLUE_NUM:0x0000FF, green:0x00FF00, YELLOW_STR:0xFFFF00}; delete __color__map[BLUE_STR]; __color__map[BLUE_NUM] === undefined. Actual: ' + (__color__map[BLUE_NUM]));
}
//
//////////////////////////////////////////////////////////////////////////////
