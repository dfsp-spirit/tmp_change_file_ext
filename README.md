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

Copy the bash script to the directory in which you want to use it.


## Usage ##

Make a backup of the directory you want to change (or make a new, clean branch to work in if using version control like git).

Configure the old and new file extensions you want in the script header.

Then run the script once like this to rename the files:

    ./tmp_change_file_ext.sh --rename
    
This will create a list with the original file names and rename the files as specified in the script.

Now do whatever you need to do with the renamed files (e.g., run a tool on them which requires a certain file extension).

When you are done, run the script again to restore the original file names:

    ./tmp_change_file_ext.sh --renamed

That's it.

## Test it before using it ##

You can try it in the test/ directory, which contains a number of js and jsx files in sub directories (the default settings are fine for this, so we do not change anything in this case):

    cp tmp_change_file_ext.sh test/
    cd test/
    
Let's inspect the directory structure and files we have in here, e.g., by running the `tree` command if you have it installed:

    tree
    
Now let's rename the files:
    
    ./tmp_change_file_ext.sh --rename
    
Now inspect the directory structure again.

    tree
    
You could make changes or run a tool now. But we will simply restore the original file extensions now:

    ./tmp_change_file_ext.sh --restore

And inspect the directory structure again.

    tree


## License ##

This is released under the WTFPL, see http://www.wtfpl.net/ or the LICENSE file for details.

