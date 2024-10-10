#!/usr/bin/env python
# usage: python3 rapid_split.py FASTA > TPF

import sys
import re
from Bio import SeqIO
ns=re.compile("[Nn]+")
for seq_record in SeqIO.parse(sys.argv[1], "fasta"):
    c=1
    for m in ns.finditer(str(seq_record.seq)):
        print("?\t{}:{}-{}\t{}\tPLUS".format(seq_record.id, c, m.start(), seq_record.id))
        print("GAP\tTYPE-2\t{}".format(m.end() - m.start() + 1))
        c=m.end()+1
    print("?\t{}:{}-{}\t{}\tPLUS".format(seq_record.id, c, len(seq_record.seq), seq_record.id))
