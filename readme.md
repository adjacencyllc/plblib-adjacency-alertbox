

# PL/B Starter Project

The purpose of this repository is to create an empty project with a directory structure and utility scripts to aid in developing structured PL/B programs compatible with GitHub or other version control systems.

## Directory Structure
The directory structure is as follows:

- **/bin** - binary files - includes object code, debug files, and compiler listings (*.plc, *.sdb, *.lst)
- **/dat** - directory for data files, including TXT, ISI, AAM, and SQLite databases
- **/doc** - documentation folder
- **/log** - log files should be written to this folder
- **/src** - the main source code directory
- **/src/inc** - source code subdirectory for include files
- **/src/plf** - source code subdirectory for Form Designer files (*.plf, *.xplf, *.pwf, *.xpwf)
- **/tmp** - temporary directory for storing transient data

## Command Line Utilities

All of the below command line utilities can be found the the root folder of the project. They are intended to be run from this directory. Running them from other directories may result in the script failing/providing unexpected results.

### compile.bat ###
This script will compile a PL/B source file into object code. Compiler status/errors are will displayed in a terminal. Usage: ```compile SOURCENAME``` where SOURCENAME is a PL/B program with a *.pls extension in the /src directory. The compiler's output will have the same base file name as the source code, but with the *.plc extension, and will created in the /bin directory. Two additional files will be created by the compiler: SOURCENAME.sdb and SOURCENAME.lst, both also in the /bin directory

### compileall.bat ###
This script will compile all of the source code (*.pls files) found in the /src directory. *.plc, *.sdb, and *.lst files will be created for all sources (in the /bin directory). If a source does not compile cleanly, the filesize of the *.plc file will be 0 bytes, and a warning on all 0 byte *.plc files will be displayed at the end of the compilation process.

### debug.bat ###
This script executes a PL/B program in interactive debug mode using the legacy character debugger. Usage: ```debug PROGRAMNAME```, where PROGRAMNAME is the name of a *.plc file in the /bin directory.

### debuggui.bat ###
This script executes a PL/B program in interactive debug mode using the GUI debugger. Usage: ```debuggui PROGRAMNAME```, where PROGRAMNAME is the name of a *.plc file in the /bin directory.

### debuglisten.bat ###
This script executes the PL/B debugging daemon in listen mode. This is required in order to use the GUI debugger. The listening daemon only needs to be initialized once per session.

### designer.bat ###
This script launches the Sunbelt PL/B Form Designer. Usage is ```execute FORMNAME```, where FORMNAME is a valid *.plf, *.xplf, *.pwf, *.xpwf file in the /src/plf directory. If FORMNAME is omitted, the designer will be launched without opening a form.

### execute.bat ###
This script executes a compiled PL/B program. Usage: ```execute PROGRAMNAME```, where PROGRAMNAME is a compiled PL/B program which exists in the /bin directory. The extension may be omitted if it is *.plc.

## VS Code Integration
This starter project has been set up to work with VS Code. For best results, install the "Sunbelt PL/B Language" extension from Sunbelt in VS Code. (To install an extension for VS Code from the marketplace, open the Extensions view by clicking on the Extensions icon on the left-hand side of the editor, search for the extension you want to install, and click the Install button.) This will provide syntax highlighting for the PL/B language.

There are also predefined tasks accessible the Run Tasks menu. These tasks may be linked to hotkeys if desired. To assign a hotkey to a task in VS Code, open the Command Palette (press `Ctrl+Shift+P` or `Cmd+Shift+P` on Mac), search for "Tasks: Manage Automatic Tasks in Folder", and select the task you want to assign a hotkey to. Then, click the ellipsis button to the right of the task and select "Configure Task". In the task file that opens, add the `keyTrigger` property to the task and set it to the desired key combination, for example: `"keyTrigger": "ctrl+shift+b"`. Save the file and the hotkey will now trigger the task.

### PLB Compile ###
Executes the compile.bat script against the currently active document in the code editor.

### PLB Execute ###
Executes the execute.bat script against the currently active document in the code editor.

### PLB Debug (Character) ###
Executes the debug.bat script against the currently active document in the code editor.

### PLB Debug (GUI) ###
Executes the debuggui.bat script against the currently active document in the code editor.

### PLB Designer ###
Executes the designer.bat script

### PLB Language Reference ###
Executes the PL/B language reference help file (requires the PLB_SYSTEM environment variable to be set)

### PLB Runtime Reference ###
Executes the PL/B runtime reference help file (requires the PLB_SYSTEM environment variable to be set)

### PLB Utilities Reference ##
Executes the PL/B utilities reference help file (requires the PLB_SYSTEM environment variable to be set)

## Git Integration
This starter project has been designed to work with Git, or with other similar version control systems. A .gitignore file has been created in the project root to ignore compiler files, data files/indexes, temporary and log files, and other miscellaneous files created by Sunbelt PL/B.

Note that plbwin.ini and designer.ini are ignored by Git. This is done so that each developer working on a project can maintain ini files specific to their development environment, without affecting other users. When creating a copy of this project, there are no plbwin.ini or designer.ini files. There are plbwin-sample.ini and designer-sample.ini files, which can be copied and modified by each developer when they initialize their project folder.
