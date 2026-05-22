////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
//
// plblib-adjacency-alertbox  
//
// © 2026 by Adjacency Global Solutions LLC 
//
// This work is licensed under Creative Commons Attribution-ShareAlike 4.0 International. To view a copy of this 
// license, visit https://creativecommons.org/licenses/by-sa/4.0/
//
//
// CC BY-SA 4.0
// Creative Commons Attribution-ShareAlike 4.0 International
//
// This license requires that reusers give credit to the creator. It allows reusers to distribute, remix, adapt, 
// and build upon the material in any medium or format, even for commercial purposes. If others remix, adapt, or build 
// upon the material, they must license the modified material under identical terms.
//
// BY: Credit must be given to you, the creator.
// SA: Adaptations must be shared under the same terms
//
// In short, you are free to use this however you like. If you make changes, you have to include this license in your
//  modified works.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    include "plblib-adjacency-alertbox.inc"

// 
// alertbox - a replacement for the alert instruction which is compatible with PLB Unix, PLB Console, PLB Windows, and
//              PLB Web Server.
// 
// Usage:
//
// call alertboxShow giving result using alertType,alertMessage,alertTitle,param0,param1,param2,param3
//
// Where:
//
//  result is a form or integer value giving the numeric result of the response, consistent with the ALERT instruction
//  alertType is a numeric value consistent with the ALERT instruction, or one of: STOP, PLAIN, CAUTION, NOTE
//  alertMessage is the text to be displayed in the body of the alert
//  alertTitle is the title of the alert (defaults to "Program Alert")
//  param0 - param3 are optional string values that can be used as text replacements in alertMessage
//
// Note:
//
//  1. alertMessage will be searched for literal strings of ^^. Every instance of ^^ will be replaced with the
//      newline character appropriate to the type of alert being displayed
//  2. alertMessage will be searched for literal strings of ^0, ^1, ^2, and ^3. Matches will be replaced with the
//      contents of param0 - param3.
//  3. When running on Linux or PLBCON, the alert will be displayed in the console. Under a PLBWIN/PLBWEB runtime, a GUI
//      alert dialog will be displayed.
//  4. This module will attempt to preserve the screen contents of the console using SCRNSAVE/SCRNRESTORE. This 
//      requires appropriate settings in the screen definition file for some runtimes
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
alertbox function
alertType var @             // REQUIRED: a numeric alert type, or a string containing: STOP, PLAIN, CAUTION, NOTE
alertMessage dim 512        // REQUIRED: the string to display in the alert
alertTitle dim 80           // OPTIONAL: the title of the alert
param0 dim 260              // OPTIONAL: replacement string 0, will replace all instances of ^0 in alertMessage
param1 dim 260              // OPTIONAL: replacement string 1, will replace all instances of ^1 in alertMessage
param2 dim 260              // OPTIONAL: replacement string 2, will replace all instances of ^2 in alertMessage
param3 dim 260              // OPTIONAL: replacement string 3, will replace all instances of ^3 in alertMessage
    entry
variableType integer 2      // determines what type of variable has been passed in through alertType
pWorkString dim ^           // work string for getting the value of alertType when its a DIM/INIT
pWorkForm form ^            // work number for getting the value of alertType when its a FORM
pWorkInteger integer ^      // work number for getting the value of alertType when its an INTEGER
alertTypeNumeric integer 4  // numeric alert type
alertTypeString dim 10      // string value passed in via alertType
runtimeType integer 1       // what type of runtime are we on? (Console, GUI, or Web Browser)
alertResult integer 4       // result of the alert, consistent with the ALERT instruction

    // convert alert types: CAUTION, NOTE, PLAN, STOP into their numeric values
    type alertType into variableType
    if (variableType = 32 or variableType = 288)
        moveaddr alertType to pWorkString
        move pWorkString to alertTypeString    
        uppercase alertTypeString
        switch alertTypeString
        case "STOP"
            calc alertTypeNumeric = (ALERT_ICON_STOP + ALERT_BUTTON_OK)
        case "NOTE"
            calc alertTypeNumeric = (ALERT_ICON_INFORMATION + ALERT_BUTTON_OK)
        case "CAUTION"
            calc alertTypeNumeric = (ALERT_ICON_EXCLAMATION + ALERT_BUTTON_OK)
        default // "PLAIN" or invalid
            calc alertTypeNumeric = (ALERT_ICON_QUESTION + ALERT_BUTTON_YESNOCANCEL)
        endswitch    
    elseif (variableType = 16 or variableType = 272)
        moveaddr alertType to pWorkForm
        move pWorkForm to alertTypeNumeric
    else
        moveaddr alertType to pWorkInteger
        move pWorkInteger to alertTypeNumeric
    endif

    // set a default alert title
    chop alertTitle
    if (alertTitle = "")
        pack alertTitle from "Program Alert"
    endif

    // string replacement consistent with PARAMTEXT instruction
    call replaceParamText using alertMessage,param0,param1,param2,param3

    // do an alert based on the runtime we're using
    call getRuntimeType giving runtimeType
    if (runtimeType = ALERT_RUNTIME_GUI)
        call doGuiAlert giving alertResult using alertTypeNumeric,alertTitle,alertMessage
    elseif (runtimeType = ALERT_RUNTIME_BROWSER)
        call doConsoleAlert giving alertResult using alertTypeNumeric,alertTitle,alertMessage
    else
        call doConsoleAlert giving alertResult using alertTypeNumeric,alertTitle,alertMessage
    endif

    return using alertResult
    functionend
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
doBrowserAlert lfunction
alertTypeNumeric integer 4
alertTitle dim 80
alertMessage dim 512
    entry
alertResult integer 1

    // replace 0x7f with <br> when running in a browser
    loop
        scan ALERT_CRLF in alertMessage
        until not equal
        splice "<br>" in alertMessage with 1
    repeat
    reset alertMessage

    // do the alert box
    alert type=alertTypeNumeric,alertMessage,alertResult,alertTitle
    return using alertResult
    functionend
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
doGuiAlert lfunction
alertTypeNumeric integer 4
alertTitle dim 80
alertMessage dim 512
    entry
alertResult integer 1

    // do the alert box
    alert type=alertTypeNumeric,alertMessage,alertResult,alertTitle
    return using alertResult
    functionend
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
doConsoleAlert lfunction
alertTypeNumeric integer 4
alertTitle dim 80
alertMessage dim 512
    entry
alertIconString dim 1
testValue integer 4
alertKeyinResponse dim 1
showButtonOK integer 1
showButtonAbort integer 1
showButtonIgnore integer 1
showButtonRetry integer 1
showButtonCancel integer 1
showButtonYes integer 1
showButtonNo integer 1
alertButtonMask integer 1,"7"
validResponses dim 10
screenSize integer 4
screenBuffer dim ^

    // set the alert icon
    move "!" to alertIconString

    move alertTypeNumeric to testValue
    and ALERT_ICON_STOP with testValue
    if (testValue)
        move "X" to alertIconString
    endif

    move alertTypeNumeric to testValue
    and ALERT_ICON_QUESTION with testValue
    if (testValue)
        move "?" to alertIconString
    endif

    move alertTypeNumeric to testValue
    and ALERT_ICON_INFORMATION with testValue
    if (testValue)
        move "i" to alertIconString
    endif

    // make sure we only take the value of the alert buttons between 0 and 7    
    and alertTypeNumeric into alertButtonMask
    switch alertButtonMask
    case 0
        set showButtonOK
    case 1
        set showButtonOK
        set showButtonCancel
    case 2
        set showButtonAbort
        set showButtonRetry
        set showButtonIgnore
    case 3
        set showButtonYes
        set showButtonNo
        set showButtonCancel
    case 4
        set showButtonYes
        set showButtonNo
    case 5
        set showButtonRetry
        set showButtonCancel
    default
        set showButtonOK
    endswitch        

    // replace 0x7f with CRLF in the alert message
    loop
        scan ALERT_CRLF in alertMessage
        until not equal
        splice ALERT_CONSOLE_CRLF in alertMessage with 1
    repeat
    reset alertMessage

    // save the screen state
    scrnsize screenSize
    dmake screenBuffer using screenSize
    scrnsave screenBuffer

    // set up a subwindow for displaying the alert
    display *savesw,*setswall=10:18:1:80,*border,*shrinksw;

    // display the title and message
    display *es:
            *revon,*el,*ulon,*ll,"[",alertIconString,"] ",alertTitle,*uloff,*revoff:
            *n,*el,*wrapon,alertMessage,*hd,*el;

    // choose which buttons to display and set the responses we will allow
    if (showButtonOK)            
        display " ",*boldon,"[   ",*revon,"O",*revoff,"K   ]",*boldoff," "; 
        append "O" to validResponses
    endif

    if (showButtonYes)            
        display " ",*boldon,"[   ",*revon,"Y",*revoff,"es  ]",*boldoff," "; 
        append "Y" to validResponses
    endif

    if (showButtonNo)            
        display " ",*boldon,"[   ",*revon,"N",*revoff,"o   ]",*boldoff," "; 
        append "N" to validResponses
    endif

    if (showButtonAbort)            
        display " ",*boldon,"[  ",*revon,"A",*revoff,"bort ]",*boldoff," "; 
        append "A" to validResponses
    endif

    if (showButtonRetry)            
        display " ",*boldon,"[  ",*revon,"R",*revoff,"etry ]",*boldoff," "; 
        append "R" to validResponses
    endif

    if (showButtonIgnore)            
        display " ",*boldon,"[ ",*revon,"I",*revoff,"gnore]",*boldoff," "; 
        append "I" to validResponses
    endif

    if (showButtonCancel)            
        display " ",*boldon,"[ ",*revon,"C",*revoff,"ancel ]",*boldoff," "; 
        append "C" to validResponses
    endif

    reset validResponses
    display *b;

    // make the user press one of the valid responses
    loop
        keyin *hd,*+,alertKeyinResponse;
        uppercase alertKeyinResponse
        scan alertKeyinResponse in validResponses
        break if equal
        display *b;
    repeat 

    // restore our screen state
    display *restsw;
    scrnrestore screenBuffer

    switch alertKeyinResponse
    case "O"
        return using ALERT_ID_OK
    case "C"
        return using ALERT_ID_CANCEL
    case "A"
        return using ALERT_ID_ABORT
    case "R"
        return using ALERT_ID_RETRY
    case "I"
        return using ALERT_ID_IGNORE
    case "Y"
        return using ALERT_ID_YES
    case "N"
        return using ALERT_ID_NO
    endswitch

    return using ALERT_ID_NONE

    functionend
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
getRuntimeType lfunction
    entry
versionString dim 31
versionRec record
interpreterVersion dim 5
blank1 dim 1
interpreterName dim 8
blank2 dim 1
systemId dim 2
blank3 dim 1
clientName dim 8
clientVersion dim 5
    recordend

    clock version into versionString
    unpack versionString into versionRec
    chop versionRec.interpreterName
    chop versionRec.clientName

    return using ALERT_RUNTIME_BROWSER if (versionRec.clientName = "webbrw")
    return using ALERT_RUNTIME_GUI if (versionRec.interpreterName = "PLBWIN")
    return using ALERT_RUNTIME_CONSOLE
    functionend
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
replaceParamText lfunction
pAlertString dim ^
params dim 260[0..3]
    entry
index form 1
scanString dim 2

    loop
        scan "^^" in pAlertString
        until not equal
        splice ALERT_CRLF in pAlertString with 2
    repeat
    reset pAlertString

    for index from 0 to 3
        pack scanString from "^",index
        loop
            scan scanString in pAlertString
            until not equal
            splice params[index] in pAlertString with 2
        repeat
        reset pAlertString
    repeat

    functionend
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
