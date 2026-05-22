    include "plblib-adjacency-alertbox.inc"     // required to set up the external call

    // replacement for:  alert CAUTION,"Alert Message",S$RETVAL,"Alert Title"
    call alertboxShow giving S$RETVAL using "caution","Alert Message","Alert Title"
