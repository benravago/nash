// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.3.2_A4_T4;
 * @section: 15.1.3.2;
 * @assertion: URI tests;
 * @description: Test some url;
*/

//CHECK#1
if (decodeURIComponent("") !== "") {
  warn('#1: ""');
}

//CHECK#2
if (decodeURIComponent("http://unipro.ru") !== "http://unipro.ru") {
  warn('#2: http://unipro.ru');
}

//CHECK#3
if (decodeURIComponent("http:%2f%2Fwww.google.ru/support/jobs/bin/static.py%3Fpage%3dwhy-ru.html%26sid%3Dliveandwork") !== "http://www.google.ru/support/jobs/bin/static.py?page=why-ru.html&sid=liveandwork") {
  warn('#3: http:%2f%2Fwww.google.ru/support/jobs/bin/static.py%3Fpage3dwhy-ru.html%26sid3Dliveandwork"');
}           

//CHECK#4
if (decodeURIComponent("http:%2F%2Fen.wikipedia.org/wiki/UTF-8%23Description") !== "http://en.wikipedia.org/wiki/UTF-8#Description") {
  warn('#4: http:%2F%2Fen.wikipedia.org/wiki/UTF-8%23Description');
}
