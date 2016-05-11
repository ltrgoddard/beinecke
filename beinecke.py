#!/usr/bin/env python

# To do:

# * automatic extraction of data from Yale catalogue using BeautifulSoup

import sys
import csv
import re

# read correspondence data copied from Yale finding aid

name = sys.argv[1]

with open(sys.argv[3], "w") as output:

    output.write("")

with open(sys.argv[2], "r", encoding = "ISO-8859-1") as input:

    data = list(csv.reader(input))

results = []

for entry in data:

    # exclude cross-references and other information

    exclusions = ["Gift", "gift", "From", "from", "transcripts", "translations", "Regards", "EMPTY", "Accompanied", "See:", "See also", "Includes", "Contains", "general", "Unidentified", "With", "GS"]

    if any(phrase in entry[2] for phrase in exclusions):

        print("Entry excluded: " + entry[2])

    else: 

        # clean up folder numbering and generate score (number of folders)

        entry[1] = re.sub(r"[A-Za-z]*", "", entry[1])

        if "-" in entry[1]:

            start, end = entry[1].split("-")

            if len(end) < len(start):

                end = start[:(len(end) - len(start))-1] + end

            folder_score = int(end) - int(start)

        else: folder_score = 1

        # clean up dates and generate score (length of correspondence in years)

        if "-" in entry[3]:

            entry[3] = re.sub(r"\[|\]|\?| ", "", entry[3])

            start, end = entry[3].split("-")

            if "," in start: offcut, start = start.split(",")
            if "," in end: end, offcut = end.split(",")

            if len(end) == 4: year_score = int(end) - int(start)
            else: year_score = (1900 + int(end)) - int(start)

        else: year_score = 1

        # combine folder and year scores to get an overall weight 

        weight = folder_score + year_score

        # clean up names

        entry[2] = re.sub(r" (?=$)", "", entry[2]) 

        with open(sys.argv[3], "a") as output:

            csv.writer(output).writerow([name, entry[2], weight])
