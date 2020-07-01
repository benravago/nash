// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S12.5_A12_T1;
* @section: 12.5;
* @assertion: Embedded "if/else" constructions are allowed;
* @description: Using embedded "if/else" into "if/else" constructions;
*/

//CHECK# 1
if(true)
  if (false)
    warn('#1.1: At embedded "if/else" constructions engine must select right branches');
  else
    ;
else 
  if (true)
    warn('#1.2: At embedded "if/else" constructions engine must select right branches');
  else
    warn('#1.3: At embedded "if/else" constructions engine must select right branches');

//CHECK# 2
if(true)
  if (true)
    ;
  else
    warn('#2.1: At embedded "if/else" constructions engine must select right branches');
else 
  if (true)
    warn('#2.2: At embedded "if/else" constructions engine must select right branches');
  else
    warn('#2.3: At embedded "if/else" constructions engine must select right branches');

//CHECK# 3
if(false)
  if (true)
    warn('#3.1: At embedded "if/else" constructions engine must select right branches');
  else
    warn('#3.2: At embedded "if/else" constructions engine must select right branches');
else 
  if (true)
    ;
  else
    warn('#3.3: At embedded "if/else" constructions engine must select right branches');

//CHECK# 4
if(false)
  if (true)
    warn('#4.1: At embedded "if/else" constructions engine must select right branches');
  else
    warn('#4.2: At embedded "if/else" constructions engine must select right branches');
else 
  if (false)
    warn('#4.3: At embedded "if/else" constructions engine must select right branches');
  else
    ;
