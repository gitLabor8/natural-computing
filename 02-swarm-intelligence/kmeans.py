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
# predicted_labels = estimator.labels_
# performance_score = sklearn.metrics.homogeneity_score(y, predicted_labels)
# centroids = estimator.cluster_centers_
inertia = estimator.inertia_
print("Quantization error = " + str(inertia))

print("Total computation time = " + str(datetime.now() - startTime))
