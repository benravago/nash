Starting over with a new goal:

A TypeScript ScriptEngine for the jvm

#### What's new ####

At this point, I've just been trying to reduce the code bulk by removing unused/unwanted parts (deprecated, dead code, etc) and using modern java idioms (e.g., rule switch).  I've also included a reduced ASM 7.0 codebase that provides what is required by nasgen and the nashorn engine.  As it is, the code can run a simple Hello-World javascript.

