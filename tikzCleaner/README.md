# Tikz cleaner
Tikz take too much time to be compiled each time. We can put the code in other file and enable or disable the compilation but it's not the best solution. 

The plan is to have a script (which can clean a actual project) but the script is not mandatory to have to compile the project (so mostly macro). We will compile each tikzpicture in a .tex file which will be compiled on its own and output a pdf (we could add an option to output png but the script become mandatory) which will be used in the main file.

The main workflow should be:
1) Parse all the files recursively to find all .tex (except tikz directory). It should be possible to do it from bash or vim
2) For each .tex file, we find the tikzpicture
3) For each tikzpicture, we create a new file in the `tikz/` directory (See if we keep only one directory or for each layer a tikz directory). There is also the question of the name of the file (maybe default + using comment to be able to add name + parsing figure to get label). It will also create a template for the preambule (here only one is better).
4) Produce output and resize: we don't want a full page output but only the tikzpicture (+ png ?)
5) Replace in the main .tex file the tikzpicture by a \includegraphics
6) Clean the tikzs directory (to remove all the .aux ...)

Another use of the script should be to compile all tikzpicture

## Improvement
* Watch for the commentary % (do not extract)
* Extract also circuitikz and gnuplot
* Precompiled preamble
* Auto crop with tikzexternalise / subfiles / doculementclass{tikz}

## Changelog
### V0
- Find all .tex recursively at the root of the project (where tikzCleaner is launched)
- In each .tex, find all `\begin{tikzpicture} ... \end{tikzpciture}` extract them and put them in a `tikz` folder and insert an `\includegraphics` in the .tex file.
- Launch compilation of each file in the tikz folder except the `preambule.tex` in the tikz directory of the root the project
- Clean aux files in the tikz folder
- Crop the pdfs

### V0.1
- Adding a option to also produce PNG
- Adding the flag `-p` or `--png` will produce a PNG with a DPI of 96
- Adding the flag `--dpi [value]` will produce a PNG with a DPI of `[value]`
- Now it will only compile .tex which have modification

## FAQ

- Getting error when converting pdf to png
```
convert-im6.q16: attempt to perform an operation not allowed by the security policy `PDF' @ error/constitute.c/IsCoderAuthorized/408
```
You should follow this [link](https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion)
