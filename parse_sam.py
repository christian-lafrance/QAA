#!/usr/bin/env python


import argparse


def get_args():
    parser = argparse.ArgumentParser(description="parse_sam.py")
    parser.add_argument("-f", help="sam file", required=True, type=str)
    return parser.parse_args()
args = get_args()


def parse_reads(filename: str) -> tuple[int : int]:
    '''
    Parses a SAM file line by line, ignoring lines beginning with '@'
    and counts the number of mapped and unmapped reads using the
    bitwise flag. Secondary alignments are ignored.
    Returns a tuple: (mapped_count, unmapped_count).
    '''
    mapped_count = 0
    unmapped_count = 0

    with open(filename, "r") as sam:
        for line in sam:
            if line[0] != "@":
                flag = int(line.split()[1])

                if(flag & 4) != 4 and (flag & 256) != 256:
                    mapped_count += 1
                elif(flag & 4) == 4 and (flag & 256) != 256:
                    unmapped_count += 1

    return mapped_count, unmapped_count


#################### Function calls ###########################
filename = args.f
mapped_count, unmapped_count = parse_reads(filename)
print(args.f)
print(f"Mapped: {mapped_count}\nUnmapped: {unmapped_count}")