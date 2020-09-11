# Tikz cleaner
Tikz take too much time to be compiled each time. We can put the code in other file and enable or disable the compilation but it's not the best solution. 

The plan is to have a script (which can clean a actual project) but the script is not mandatory to have to compile the project (so mostly macro). We will compile each tikzpicture in a .tex file which will be compiled on its own and output a pdf (we could add an option to output png but the script become mandatory) which will be used in the main file.

The main workflow should be:
1) Parse all the files recursively to find all .tex (except tikz directory). It should be possible to do it from bash or vim
2) For each .tex file, we find the tikzpicture
3) For each tikzpicture, we create a new file in the `tikz/` directory (See if we keep only one directory or for each layer a tikz directory). There is also the question of the name of the file (maybe default + using comment to be able to add name + parsing figure to get label). It will also create a template for the preambule (here only one is better).
4) Produce output and resize: we don't want a full page output but only the tikzpicture (+ png ?)
5) Replace in the main .tex file the tikzpicture by a \includegraphix
6) Clean the tikzs directory (to remove all the .aux ...)

Another use of the script should be to compile all tikzpicture

