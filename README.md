# fndgrep

Fndgrep is a parallelized grep tool that combines the power of find and grep into one command. It allows for searching in multiple files quickly as all greps are done in parallel on a per-file basis.


Features
* Search by extension
* Search recursively
* Filter out directories with a global .fndgrepignore to increase search speed
* Replace text (uses sed)

Examples
* Find all instances of string in xml and mk files
  * fndgrep -e xml -e mk string
  * fndgrep -s replacement search_string    # Replaces search_string with replacement

Example $HOME/.fndgrepignore
Using the following commands will create a .fndgrepignore that will ignore dist, build, tmp, node_modules, and .git directories under the search directory.
```
dist
build
tmp
node_modules
.git
```
