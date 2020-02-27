
import random
# import numpy as np
from matplotlib import pyplot as plt

# Read the iris data file and transform it into a coords
def readIris() -> [[float, float, float, float]]:
    file = open("iris.data", 'r')
    petalCoordinates = []
    for line in file:
        if line == "\n":
            file.close()
            return petalCoordinates
        else:
            numbers = line.split(",")
            petalCoordinates = petalCoordinates \
                               + [[float(numbers[0]), float(numbers[1]),
                                   float(numbers[2]), float(numbers[3])]]
    print("Warning: Escaped filereading without EOF.")
    return petalCoordinates

def initialiseCentroids(k: int) -> [[float, float, float, float]]:
    minVals: [float] = [10.0, 10, 10, 10]
    maxVals: [float] = [0.0, 0, 0, 0]
    # Loop over the dimensions
    for d in range(4):
        # Determine the outer bounds of each
        for i in range(len(petalCoordinates)):
            minVals[d] = min(minVals[d], petalCoordinates[i][d])
            maxVals[d] = max(maxVals[d], petalCoordinates[i][d])
    # Initialise the centroids/swarm
    centroids = [[random.uniform(minVals[d], maxVals[d]) for d in range(4)]
                                                         for i in range(k)]
    print(str(centroids))


# k = number of clusters
k = 3
petalCoordinates = readIris()

centroids = initialiseCentroids(k)

plt.plot(, centroids[1], 'ro')
plt.show()


# ax = plt.figure().gca()
# surface = ax.plot_surface(petalCoordinates[0], petalCoordinates[1],
#                           petalCoordinates[2])
# plt.show()
