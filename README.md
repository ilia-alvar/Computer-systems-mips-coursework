# Computer-systems-mips-coursework
MIPS assembly coursework for Computer Systems; low-level network packet construction, including DNS query header encoding and QNAME label parsing.

## What it does?
Builds a raw DNS query packet in memory, matching the wire format from RFC 1035: a 12-byte header, the domain name encoded as length-prefixed labels ( `example.com` → `[7]example[3]com[0]`), and the QTYPE/QCLASS fields.
