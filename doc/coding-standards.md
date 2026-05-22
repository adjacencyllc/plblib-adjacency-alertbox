# PLB Coding Standards

## Source Code Standards

### General Code Editor Settings
- Editor should be configured to convert and save all tabs as spaces
- Indentation for blocks of code should be 4 spaces

### Verb/Operand Spacing (columns 2 and 3)
Only one space is expected between a verb and its operands
```c
// improper old columnar style coding
        move        x to y      

// proper convention for modern PL/B code
    move x to y                 
```

### Blank Source Code Lines
Minimize blank lines. One blank line is acceptable for separating major blocks, such as loop/repeat, if/endif, switch/case/endswitch, record/recordend, filelist/filelistend, etc. Consecutive blank lines should not be used. Excessive whitespace makes code more difficult to follow, and limits the amount of code which can be seen on the screen at one time.

### Source Code File Extensions

#### PLS
This is for code which is intended to be compiled into a program. Generally it goes in the `/src` directory, unless some other sub-folder structure is being utilized.

#### IO
This is for code which contains file IO or SQL IO data definitions. These files should always be in the `/src/inc` directory.

#### INC
This is for include files which are not intended to be compiled as standalone programs. These files should always be in the `/src/inc` directory.

#### PLF, XPLF, PWF, XPWF
These extensions are used for form designer files intended to be loaded with a `PLFORM` directive. The exact extension will depend on the format of the file. 

#### EXT
This is for declarations of external function labels, or for `MACRO` or `VERB` directives. 

### Source Code Case

#### Variable Case
PL/B is generally case-insensitive, except when compiling programs for use with Systemaker. However, variable case should always be consistent, using a **camel case** convention
```c
numberOfDonuts                      integer         2
favoritePhrase                      init            "Hello, world!"
```

#### Compiler-Directive Case (Const, Equate, Define, etc.)
Compiler directives should utilize **upper snake case**
```c
MAX_NUMBER_OF_DONUTS                const           "65535"
LVIS_SELECTED_AND_FOCUSED           const           "3"
```

#### Verb/Method Case
Verbs should be coded using lower case
```c
    move x to y
    calc z = (x * y)
```
Object methods should be coded according to the system documentation, as though they were case-sensitive. For most PL/B methods, this would be Pascal case:
```c
    mainWinListview.GetItemCount giving itemCount
```

#### Preposition Case
Prepositions separating operands should always be in lower case
```c
    call concatenateString giving concatenatedName using lastName,", ",firstName
```

#### Property/Miscellaneous code cases
Property case should be coded according to the documentation standard (if available). Otherwise, Pascal case is preferred:
```c
    getprop mainWinLastNameET,Text=lastNameData
```

### Comment Characters

Even though PL/B utilizes five distinct comment indicators, only `//` is acceptable for modern PL/B programs. The use of `.`, `*`, `;`, and `.` in the first column should not be used. 

All source code comments must begin with `//`, even though the compiler allows end-of-line comments with no comment delimiter

> **Example: Disallowed Commenting Styles**
> ```c
> *
> * name variables
> *
> lastName                            dim             20    Last Name of the employee
> firstName                           dim             20    . First Name of the employee
> ```

> **Example: Proper Commenting Style**
> ```c
> // name variables
> lastName                            dim             20    // Last Name of the employee
> firstName                           dim             20    // First Name of the employee
> ```

### Variable Declarations, Formatting, and Scope

#### Indentation Consistency
Use consistent formatting for variable declarations. Declarations for variables, files, objects, constants, etc. should use a columnar format. The label is left aligned. The data/object type is aligned on column 37, and the data size/initial value, other properties are aligned on column 53. End of line comments can be used as appropriate, and should always be delimited with `//`. It generally makes variable declares easier to read when data definitions are aligned in this manner.

> **Example: Proper Alignment for Variable Declarations**
> ```c
> queryString                         init            "SELECT * FROM table"
> 
> tableColumns                        record
> lastName                            dim             20      // 001-020, last name column
> firstName                           dim             20      // 021-040, first name column
> emailAddress                        dim             260     // 041-300
>                                     recordend
> ```

#### Variable Scope

There isn't a standard nomenclature for variable scope in PL/B, so this is what we have settled on for conventions

- **Global** - a true PL/B global variable, declared with a `%` in front of the third column operand(s)
- **UDA** - the default PL/B scope, accessible to all includes, functions, subroutines, etc. (This would be called global scope in most languages)
- **Private** - a variable accessible only by the source file it is declared in, where the variable name is prefixed with a `#` sign.
- **Local** - a local variable with a function or lfunction. Not accessbile outside the (l)function/functionend block.

##### Global Scope
True global variables may only be declared in a special include file called `global.inc`, which must be included at the beginning of every program. 

##### UDA Scope
The use of the UDA scope is **highly** discouraged. Exceptions are where there is not a good alternative, such as:
- Objects declared in a PLFORM
- Constants and Equates
- Other compiler directives, such as DEFINE
- Filelists, so that files are not opened and closed at every change in scope

##### Private Scope
Privately scoped variables should be used sparingly, but are acceptable to use on an as-needed basis for storing state information. Privately scoped variables should never be used for work strings, temporary data, and never for more than one very narrow/specific purpose.

##### Local Scope
Local variables should be used almost exclusively. Properly written code will make use of functions for all program operations, so each function should be comperable to a mini-program, and should have no references to variables in the global, UDA, or private scope, except for the cases described above.

#### Variable Naming Conventions
Consistency is key to good variable names. 

Variable names should be descriptive. Consider the example below:

> **Example: Poor Variable Name Choice**
> ```c
> displayArrayContents lfunction      // poor choice for variable name
> pArrayData                          dim             ^[99]
>     entry
> i                                   integer         4
> 
>     for i from 1 to 99
>         display i,". ",*ll,pArrayData[i]
>     repeat
>     functionend
> ```
> The variable name `i` gives no indication how the variable is actually being used in the function, and using a generic name encourages future developers to re-use a variable for a secondary purpose, which is not ideal. 

> **Example: Better Variable Name Choice**
> ```c
> displayArrayContents lfunction      // better variable name
> pArrayData                          dim             ^[99]
>     entry
> arrayIndex                          integer         4
> 
>     for arrayIndex from 1 to 99
>         display arrayIndex,". ",*ll,pArrayData[arrayIndex]
>     repeat
>     functionend
> ```
> Changing the counter variable name to `arrayIndex` makes it clear what this value represents in the source code, and makes the display statement much more self-documenting.

#### Length of Variable Names
Longer variable names are generally desirable, with a minimal amount of abbreviations or assumptions built into the name. It's a good idea, but not a requirement, to limit variable names to 32 characters.

### Operand Separators/Prepositions
Wherever it is allowed, prepositions should be used in place of commas for separating operands. The choice of preposition can make the code much clearer, so that it is obvious even to a non programmer what a line of code does. The goal should be to make blocks of code as readable as possible. Consider the following examples:

> **Example: Worst Case - Lack of Prepositions And Unstructured Code**
> ```c
> RDEMP$E
>         MOVE      0,RDEMPCNT
>         GETFILE   EMP,ISIRECORDLEN=RDEMPTOT
> RDEMP$L
>         READKS    EMP;*ll,EMPLST
>         GOTO      RDEMP$X IF OVER 
>         ADD       1,RDEMPCNT
>         MOVE      RDEMPCNT,RDEMPPCT
>         MULT      100,RDEMPPCT
>         DIV       RDEMPTOT,RDEMPPCT
>         SETPROP   RDPROG,VALUE=RDEMPPCT
>         GOTO      RDEMP$L
> RDEMP$X
>         RETURN
> ```
> Note how this code is practially unreadable. Without a lot of comments, there is very little indication to the uninitiated programmer what this block of code does. When non PL/B programmers see this type of code, it's little wonder why they think the language is antiquated and obsolete.

> **Example: Proper Variable Names and Scope, But No Prepositions**
> ```c
> readFileWithProgress lfunction
> pMyFile                             ifile           ^
> pMyRecord                           record          likeptr someOtherRecord
>     entry
> currentRecordCounter                integer         8
> totalRecordCounter                  integer         8
> percentComplete                     integer         8
> 
>     getfile pMyFile,IsiRecordLen=totalRecordCounter
>     loop
>         readks pMyFile;*ll,pMyRecord
>         until over
>         add 1,currentRecordCounter
>         move currentRecordCounter,percentComplete
>         multiply 100,percentComplete
>         divide totalRecordCount,percentComplete
>         setprop mainWinFilePB,Value=percentComplete
>     repeat
> ```
> This code has become more readable due to the proper function names and structured programming blocks, but the results of the add, move, and divide instructions are not as clear as they could be.

> **Example: Proper Preposition Use Making Code More Self-Documenting**
> ```c
> readFileWithProgress lfunction
> pMyFile                             ifile           ^
> pMyRecord                           record          likeptr someOtherRecord
>     entry
> currentRecordCounter                integer         8
> totalRecordCounter                  integer         8
> percentComplete                     integer         8
> 
>     getfile pMyFile,IsiRecordLen=totalRecordCounter
>     loop
>         readks pMyFile;*ll,pMyRecord
>         until over
>         add 1 to currentRecordCounter
>         move currentRecordCounter to percentComplete
>         multiply 100 into percentComplete
>         divide totalRecordCount into percentComplete
>         setprop mainWinFilePB,Value=percentComplete
>     repeat
> ```
### Standards for Functions/Lfunctions

### Function Placement and Refactoring

#### IO-Specific Functions
Move IO-related functions to corresponding IO include files to keep logic organized:

>For example, if we had a ConvertSearchParamsToAKeys function that was composed of two parts, doing a getitem on all the search fields and then taking all of those and prepping them to get them ready for an AAM search. Instead we break that into two functions. We confine the AAM prep to our IO file for better structure. 

#### Abstraction
Whenever possible, creating a helper function or breaking a function down into separate parts when there is scope in the program, help both the readability, and make maintenance easier.

### Usage of Constants and Equates

#### Avoid Hardcoding Values
Replace numbers with descriptive constants or equates. This avoids ambiguity and improves code maintainability and readability.
> Instead of *Flags=2, use LVIS_SELECTED.

> Rather than operationMode=1 or 2, define and use operationMode = ADD_ITEM or UPDATE_ITEM.

### Documentation and Comments

#### Function Documentation
Add clear comments for each function, covering:
- Expected inputs and outputs.
- Relevant flags and conditions handled.
- Errors anticipated and their corresponding handling routines.
- Goal of the function

## GUI Design

### Construction Of A Window

#### Panels
Panels are the skeleton of your program's design. Everything will flow from these panels. These are the barebones separators that take up a specific amount of a predefined space which you can then manipulate to have control over everything put inside of them.

### Thoughtful Design

#### Button Design
Design the application as if you were going to use it. Make sure to have little quality of life designs, such as separating the delete button away from the other buttons and having an “Are you sure?” prompt when clicked.

#### New Item Selection
When adding a new item, make sure to select it from the listview so the user can see it was correctly added.

### Color and Visual Elements

#### Color Scheme
Use neutral colors (e.g., $BtnFace) for backgrounds of windows and panels. Avoid overly bright or garish colors used for initial design reference.

#### Font Consistency
Utilize Segoe UI at size 11 for all text elements to ensure uniformity. Avoid variations like bold or italic.

#### Mouseless Program Usage
For most programs, we want to make it so that the entire program can be navigated and used with buttons on the keyboard. The whole program should be able to function without a mouse at all. This entails using tab to navigate, the delete button to delete, the + button for adding etc.

### Layout and User Interface Components

#### Focus Management
When the application loads, set the focus on the first relevant input field to guide the user effectively.

#### Input Fields
All input fields (e.g., text, date) must conform to a standard size and format. For date inputs, use an EditDateTime object with the format YYYY-MM-DD to prevent ambiguity.

#### Element Alignment
Align text inputs to the left and numeric inputs to the right. Ensure consistent heights across all related controls (e.g., comboboxes and edit fields). This stands true for listviews as well.

#### Control Spacing
Minimize unnecessary space in toolbars and other UI elements. Ensure padding is even and does not create excessive whitespace.

### Functional Components

#### Toolbars and Buttons
Position search functionality within the toolbar for better accessibility. Include a reset button, search button, and a delete button to clear fields and lists to their default states. Make sure that the toolbar doesn’t have a border.

#### Tooltips
Add informative tooltips to all interactive elements, including input fields and toolbar buttons, to assist users in understanding their functionality.

### Data Display Standards

#### Listviews
Configure listviews to use full rows and enable grid lines for clarity. Ensure that columns are wide enough to display content fully, avoiding ellipses from truncated text.

#### Dynamic Content
Load dynamic data into comboboxes through functions, rather than static data properties. Set the rows visible to a manageable number to prevent overwhelming the user with choices.

### Window Properties

#### Minimum Size Constraints
Establish minimum width and height for windows to ensure usability across various screen sizes.

#### Title Bars
Use descriptive titles for windows that reflect their purpose (e.g., “Presidents Search/Maintenance” instead of generic titles).

#### Modal Windows
Use modal dialogs for critical actions to maintain focus on the task at hand. Configure the positioning of modal windows to center above the parent window for user convenience.

#### Window Positioning
The main window should be set with the following property: “Window Position” = “Desktop Center” so that the program opens in the center of the screen 

#### Window Type
The window type differs depending on what you are using it for. For a modal, you should fittingly use the “modal”  type.

### General Requirements

#### Consistency in Naming
Follow a structured naming convention for all UI elements, using the format:
- Prefix with the parent window name
- Followed by a descriptive name
- Suffix with one of the following abbreviations:
  - BT - Button
  - CB - Combobox
  - DL - Datalist (rarely used)
  - EDT - EditDateTime
  - EN - Edit Number
  - ET - Edit Text
  - GB - Groupbox
  - IL - Imagelist
  - LT - Labeltext
  - LV - Listview
  - PB - Progress bar
  - ST - Stattext
  - TC - Tabcontrol
  - TB - Toolbar
  - TBI - Toolbar Item (only applies when created in the source code)

> EXAMPLE: our window is mainWin, and we have a button named submit. It would be called mainWinSubmitBT.

#### Input Limitations
Set maximum characters for inputs to prevent user errors. Ensure fields are configured to prevent excess data entry.

### Object Property Standards

#### EditText, EditDateTime, EditNumber
- Alignment = Left for text inputs, and Right for numeric inputs
- BackgroundColor = $Window
- Edit Input Type, used as appropriate, or left as Default when not - applicable
- Maximum Characters, needs to be set on each edit field so the user can’t enter more data than the program expects/supports
- Multiline, set to the number of lines of data which can be entered – almost always 1, for just one line of data.
- SelectAll = true, so that when the edit field gets focus, the text within is highlighted and selected

#### Combobox
- Unless truly static, the Data property should be blank, and the combobox loaded using a function.
- Width should be large enough so that all the rows of data are shown in full. Data shouldn’t be cut off on the right-hand side
- RowsVisible should be set to a reasonable number of rows, so that the combobox doesn’t display an insanely large number of items in the list without scrolling. Usually 10-20 is plenty.
- Unless there’s a good reason for doing otherwise, the Sorted property should always be TRUE

#### Listview
- Full Row = True
- Grid Lines = True
- Sort Header = True (also requires an event handler for the ColClick event)

## Coding Related To Design

### Closing Files
When you want a window to close, you should use the “WINHIDE” instruction

### File Naming Conventions

#### Forms
Form file names should begin with the prefix of the source file they serve, followed by an underscore and a descriptor of their purpose. This convention improves clarity and association:
- fileManager.plf should be renamed to filemanager_search.plf.
- editModal.plf should be renamed to filemanager_edit.plf.

### Event Naming Conventions
Events: Use the format on<Event>_<Object> for event names to specify the event and the associated object. This structure ensures clear, descriptive names:
- onClose_MainWin for a close event on the main window.
- onDblClick_MainWinLV for a double-click event on the main window listview.

### Structure and Organization

#### Include Statements and plforms
Place all include statements and plforms before the start label. This ensures that the start of executable code is clearly defined. The first line after the start label should almost always be call main.

#### Separation of functions involving .pls and .plf
In your source code, to help with readability and flow: separate your functions into groups. Try to have all your .plf functions you call in their own spot separate from your .pls functions

### Designer Functions

#### Calling Functions From The Designer
To call functions from the designer you need to select an object, this could be an entire form, to just a button. In order to execute some code from an event look for the lightning bolt, and then you will see certain events. To the right of these events put in directly the name of your function. If the name of the function is red, then you’re good to go.
