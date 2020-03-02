from datetime import datetime
startTime = datetime.now()

import numpy as np
import matplotlib.pyplot as plt
import sklearn.datasets
from sklearn.cluster import KMeans

iris = sklearn.datasets.load_iris(return_X_y=False)
X = iris.data
y = iris.target
n_clusters = np.unique(y, return_counts=False).size
estimator = sklearn.cluster.KMeans(n_clusters=n_clusters)
estimator.fit(X)
inertia = estimator.inertia_
print("Quantization error Iris Dataset = " + str(inertia))

print("Total computation time Iris Dataset = " + str(datetime.now() - startTime))


X_art = np.zeros((400,2))
y_art = np.zeros((400,))
for i in range(len(X_art)):
    X_art[i] = np.random.uniform(-1,1,2)
    if(X_art[i,0] >= 0.7 or X_art[i,0] <= 0.3) and (X_art[i,1] >= -0.2-X_art[i,0]):
        y_art[i] = 1
    else:
        y_art[i] = 0
startTime = datetime.now()
n_clusters = np.unique(y_art, return_counts=False).size
estimator = sklearn.cluster.KMeans(n_clusters=n_clusters)
estimator.fit(X_art)

inertia = estimator.inertia_
print("Quantization error Aritificial Dataset 1 = " + str(inertia))

print("Total computation time Aritificial Dataset 1 = " + str(datetime.now() - startTime))
