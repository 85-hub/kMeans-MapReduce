#!/usr/bin/env python
"""reducer.py"""

__authors__ = "Hassan Elseoudy, Christoph Neumann"

import sys

def calculateNewCentroids():
    global centroid_index
    current_centroid = None
    sum_a = 0
    sum_b = 0
    sum_c = 0
    sum_d = 0
    count = 0

    # input comes from STDIN
    for line in sys.stdin:
        # Get (Centroid Index) and (Features)
        centroid_index, a, b, c, d = line.split('\t')

        # Floating the features
        try:
            a = float(a)
            b = float(b)
            c = float(c)
            d = float(d)
        except ValueError:
            # Just handling the ValueError
            continue

        # This if-switch works because Hadoop sorts map output
        # by key (here: centroid_index) during Shuffling phase
        # before it is passed to the reducer:
        if current_centroid == centroid_index:
            count += 1
            sum_a += a
            sum_b += b
            sum_c += c
            sum_d += d
        else:
            if count != 0:
                # Emit arithmetic mean of current cluster points as new centroid: 
                print(str(sum_a / count) + ", " + str(sum_b / count) + ", " + str(sum_c / count) + ", " + str(
                    sum_d / count))

            # Reducer instance is reused for another input vector, i.e. another cluster of points!
            # Thus, re-initialize:
            current_centroid = centroid_index
            count = 1
            sum_a = a
            sum_b = b
            sum_c = c
            sum_d = d

    # Termination for last cluster (again emit arithmetic mean of current cluster points):
    if current_centroid == centroid_index and count != 0:
        print(str(sum_a / count) + ", " + str(sum_b / count) + ", " + str(sum_c / count) + ", " + str(sum_d / count))


if __name__ == "__main__":
    calculateNewCentroids()
