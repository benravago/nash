// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.3.1_A3_T1;
 * @section: 15.1.3.1;
 * @assertion: Let reservedURISet be a string containing one instance of each character valid 
 * in uriReserved plus "#";
 * @description: Checking all character in reservedURISet. HexDigit in [0..9, A..F];
*/

//CHECK#1
if (decodeURI("%3B") !== "%3B") {
  warn('#1: decodeURI("%3B") equal "%3B", not ";"');
}

//CHECK#2
if (decodeURI("%2F") !== "%2F") {
  warn('#2: decodeURI("%2F") equal "%2F", not "/"');
}

//CHECK#3
if (decodeURI("%3F") !== "%3F") {
  warn('#3: decodeURI("%3F") equal "%3F", not "?"');
}

//CHECK#4
if (decodeURI("%3A") !== "%3A") {
  warn('#4: decodeURI("%3A") equal "%3A", not ":"');
}

//CHECK#5
if (decodeURI("%40") !== "%40") {
  warn('#5: decodeURI("%40") equal "%40", not "@"');
}

//CHECK#6
if (decodeURI("%26") !== "%26") {
  warn('#6: decodeURI("%26") equal "%26", not "&"');
}

//CHECK#7
if (decodeURI("%3D") !== "%3D") {
  warn('#7.1: decodeURI("%3D") equal "%3D", not "="');
}

//CHECK#8
if (decodeURI("%2B") !== "%2B") {
  warn('#8.1: decodeURI("%2B") equal "%2B", not "+"');
}

//CHECK#9
if (decodeURI("%24") !== "%24") {
  warn('#9: decodeURI("%24") equal "%24", not "$"');
}

//CHECK#10
if (decodeURI("%2C") !== "%2C") {
  warn('#10: decodeURI("%2C") equal "%2C", not ","');
}

//CHECK#11
if (decodeURI("%23") !== "%23") {
  warn('#11: decodeURI("%23") equal "%23", not "#"');
}
