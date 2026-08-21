    move  $t6, $a1          # base output pointer (for final length)
    move  $t0, $a1          # current output pointer

    #  Header (12 bytes), big-endian 
    srl   $t1, $a2, 8
    sb    $t1, 0($t0)       # Transaction ID MSB
    andi  $t1, $a2, 0x00FF
    sb    $t1, 1($t0)       # Transaction ID LSB

    li    $t1, 0x01
    sb    $t1, 2($t0)       # Flags MSB (0x0100)
    li    $t1, 0x00
    sb    $t1, 3($t0)       # Flags LSB

    li    $t1, 0x00
    sb    $t1, 4($t0)       # QDCOUNT MSB (0x0001)
    li    $t1, 0x01
    sb    $t1, 5($t0)       # QDCOUNT LSB

    li    $t1, 0x00
    sb    $t1, 6($t0)       # ANCOUNT = 0x0000
    sb    $t1, 7($t0)

    sb    $t1, 8($t0)       # NSCOUNT = 0x0000
    sb    $t1, 9($t0)

    sb    $t1, 10($t0)      # ARCOUNT = 0x0000
    sb    $t1, 11($t0)

    addiu $t0, $t0, 12      # advance past header

    #  QNAME encode (reserve-and-copy) 
    move  $t2, $a0          # input pointer (domain string)
    li    $t7, 46           # '.' ASCII

outer_label:
    move  $t3, $t0          # length-byte address (reserved)
    addiu $t0, $t0, 1       # reserve 1 byte for length
    li    $t4, 0            # length counter for this label

inner_copy:
    lbu   $t5, 0($t2)       # current char (unsigned byte)
    beq   $t5, $zero, end_label
    beq   $t5, $t7,   end_label

    sb    $t5, 0($t0)       # copy char
    addiu $t0, $t0, 1       # out++
    addiu $t2, $t2, 1       # in++
    addiu $t4, $t4, 1       # len++
    j     inner_copy

end_label:
    sb    $t4, 0($t3)       # write length into reserved byte

    beq   $t5, $zero, qname_done   # if end of string, done labels
    addiu $t2, $t2, 1       # else skip '.'
    j     outer_label

qname_done:
    sb    $zero, 0($t0)     # terminate QNAME with 0x00
    addiu $t0, $t0, 1

    sb    $zero, 0($t0)     # QTYPE = 0x0001
    li    $t1, 0x01
    sb    $t1, 1($t0)
    addiu $t0, $t0, 2

    sb    $zero, 0($t0)     # QCLASS = 0x0001
    li    $t1, 0x01
    sb    $t1, 1($t0)
    addiu $t0, $t0, 2

    subu  $v0, $t0, $t6     # total packet length in bytes
