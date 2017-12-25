# temporarily-change-file-extensions
Bash script to temporarily rename files with specific file extensions, and revert to the original ones later.


## Description ##

This is a bash script which allows you to change the file extension of all files with a specific file extension
in a certain directory (including sub directories). And, more importantly, it allows you to restore the 
changed files (and only these -- even if other files with the temporal extension already existed before you
started) to their original file extensions later.

## Motivation ##

This is a hack to allow you to run tools which require a certain file extension to run on your files.

(I used it to use a javascript tool which would only accept .js files, but my source files were React.js files using the .jsx file extension. I also had test files in there which had the .js file extension already, and I wanted to keep that extension.)


## Installation ##

Download or clone the script from github, make sure it is executable.

    git clone https://github.com/dfsp-spirit/tmp_change_file_ext.git
    cd tmp_change_file_ext
    chmod +x ./tmp_change_file_ext.sh


## Usage ##

Make a backup of the directory you want to change (or make a new, clean branch to work in if using version control like git).

Then run the script like this to get help:

    ./tmp_change_file_ext.sh -h
    [TMPEXTCH] USAGE: ./tmp_change_file_ext.sh -c <options> [-f]
    [TMPEXTCH] USAGE: ./tmp_change_file_ext.sh -r <options>
    [TMPEXTCH] USAGE: ./tmp_change_file_ext.sh -h
    [TMPEXTCH] valid options are:
    [TMPEXTCH]   -c         : change mode (rename files according to settings and create mapping file)
    [TMPEXTCH]   -r         : restore mode (restore previsously renamed files to their original file extensions)
    [TMPEXTCH]   -s <ext>   : set source or original file extension to <ext>. Defaults to 'jsx' if omitted.
    [TMPEXTCH]   -t <ext>   : set temporary file extension to <ext>. Defaults to 'js' if omitted.
    [TMPEXTCH]   -d <dir>   : set directory to work on to <dir>. Defaults to '.' if omitted.
    [TMPEXTCH]   -f         : force action, even if this means overwriting an existing file extension mapping file (only applies to change mode).
    [TMPEXTCH]   -m <file>  : set mapping file location to <file>. Defaults to '~/.renamed_files.lst' if omitted.
    [TMPEXTCH]   -h         : show this help and exit
    [TMPEXTCH] EXAMPLES:
    [TMPEXTCH] * Rename all jsx files to js in ~/my_project/:
    [TMPEXTCH]    ./tmp_change_file_ext.sh -c -d ~/my_project/
    [TMPEXTCH]   Restore the file names from the last action:
    [TMPEXTCH]    ./tmp_change_file_ext.sh -r -d ~/develop/my_project/
    [TMPEXTCH] * Rename all txt files to lst in /tmp/doc/:
    [TMPEXTCH]    ./tmp_change_file_ext.sh -c -s txt -t lst -d /tmp/doc/
    [TMPEXTCH]   Restore the file names from the last action:
    [TMPEXTCH]    ./tmp_change_file_ext.sh -r -s txt -t lst -d /tmp/doc/

This will print the usage info, which currently looks like this:



### Limitations ###

This version of the script only considers the file extension as the part behind the last dot. Thus, it cannot be used to rename .tar.gz files to .tgz.

## Usage example / Test it before using it ##

You can try it in the test/ directory, which contains a number of js and jsx files in sub directories. 

Let's first inspect the directory structure and files we have in here, e.g., by running the `tree` command if you have it installed:

    cd <repo>/test/
    tree
    
Now let's rename the files:
    
    ../tmp_change_file_ext.sh -c

Note that renaming from jsx to js is the default, so we do not need the -s and -t options in this special case. (It would not hurt to add them of course, and
express that command as `../tmp_change_file_ext.sh -c -s jsx -t js -d .` instead.)
    
Now inspect the directory structure again.

    tree
    
You could make changes or run a tool now. But we will simply restore the original file extensions now:

    ../tmp_change_file_ext.sh -r

And inspect the directory structure again.

    tree


    
## License ##

This is released under the WTFPL, see http://www.wtfpl.net/ or the LICENSE file for details.

