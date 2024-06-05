* = $0801 ; 10 SYS 2064 ($0810)
!byte $0c, $08, $0a, $00, $9e, $20, $32, $30, $36, $34, $00, $00, $00

* = $0810
jmp main

!src "wic64.h"
!src "wic64.asm"
!src "macros.asm"

main:
    +print newline
    +print intro
    +print newline

    +wic64_execute http_get_request, response

    bcs timeout
    bne error

success:
    +print newline
    +print response
    +print newline
    rts

error:
    +wic64_execute status_request, response
    bcs timeout

    +print status_prefix
    +print response
    rts

timeout:
    +print timeout_error_message
    rts

timeout_error_message: !pet "?timeout error", $00

http_get_request: !byte "R", WIC64_HTTP_GET, <payload_size, >payload_size
http_get_payload: !text "http://localhost:3000/api/gAfC64?p=Wann+hat+der+Kollege+CW+mal+3+Tage+Zeit+fuer+einen+Workshop"

payload_size = * - http_get_payload

status_request: !byte "R", WIC64_GET_STATUS_MESSAGE, $01, $00, $01

status_prefix: !pet "?request failed: ", $00

newline: !byte $0d, $00

intro: !pet "talk-to-tt..."

response: