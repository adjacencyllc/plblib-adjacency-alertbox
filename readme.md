# alertbox 
a replacement for the alert instruction which is compatible with PLB Unix, PLB Console, PLB Windows, and PLB Web Server.

# License Information

plblib-adjacency-alertbox  

© 2026 by Adjacency Global Solutions LLC 

This work is licensed under Creative Commons Attribution-ShareAlike 4.0 International. To view a copy of this 
license, visit https://creativecommons.org/licenses/by-sa/4.0/

CC BY-SA 4.0
Creative Commons Attribution-ShareAlike 4.0 International

This license requires that reusers give credit to the creator. It allows reusers to distribute, remix, adapt, 
and build upon the material in any medium or format, even for commercial purposes. If others remix, adapt, or build 
upon the material, they must license the modified material under identical terms.

BY: Credit must be given to you, the creator.
SA: Adaptations must be shared under the same terms

In short, you are free to use this however you like. If you make changes, you have to include this license in your modified works.

## Usage

```call alertboxShow [giving result] {using alertType,alertMessage}[,{alertTitle}][,{param0}][,{param1}][,{param2}][,{param3}]```

Where:

- result is a form or integer value giving the numeric result of the response, consistent with the ALERT instruction
- alertType is a numeric value consistent with the ALERT instruction, or one of: STOP, PLAIN, CAUTION, NOTE
- alertMessage is the text to be displayed in the body of the alert
- alertTitle is the title of the alert (defaults to "Program Alert")
- param0 - param3 are optional string values that can be used as text replacements in alertMessage

Note:

1. alertMessage will be searched for literal strings of ^^. Every instance of ^^ will be replaced with the newline character appropriate to the type of alert being displayed
2. alertMessage will be searched for literal strings of ^0, ^1, ^2, and ^3. Matches will be replaced with the contents of param0 - param3.
3. When running on Linux or PLBCON, the alert will be displayed in the console. Under a PLBWIN/PLBWEB runtime, a GUI alert dialog will be displayed.
4. This module will attempt to preserve the screen contents of the console using SCRNSAVE/SCRNRESTORE. This requires appropriate settings in the screen definition file for some runtimes

