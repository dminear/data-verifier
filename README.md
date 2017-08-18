# data-verifier
Program to create data and verify integrity after transfer. You run it and give the number of bytes to checksum:
    
    verify.pl 1000000
to create 1 million bytes and checksum that. Then run it again and it will store the checksum in the file.

Next, transfer the file through the channel and then run it on the other side. If all transferred OK, then the test will pass.

## Module Dependencies:
File::Slurp

## Issues
There's one big issue with this whole thing: the file and the data is all 7 bit ASCII. However, if you still had a bit flip on the MSB, the checksum would be different and the test would still fail. So I guess it's not that bad.
