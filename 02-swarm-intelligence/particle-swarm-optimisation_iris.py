# PSO algorithm inspired on
# https://medium.com/analytics-vidhya/implementing-particle-swarm-optimization-pso-algorithm-in-python-9efc2eb179a6
# A lot of thanks to Iran Macedo for writing his tutorial!

from datetime import datetime

startTime = datetime.now()

import random
import numpy as np
import sklearn.datasets
from sklearn.cluster import KMeans
from scipy.spatial import distance
iris = sklearn.datasets.load_iris(return_X_y=False)
X = iris.data
y = iris.target

minima = np.min(X, axis=0)
maxima = np.max(X, axis=0)

n_clusters = np.unique(y, return_counts=False).size
estimator = sklearn.cluster.KMeans(n_clusters=n_clusters)
estimator.fit(X)
inertia = estimator.inertia_
print("Quantization error Iris Dataset = " + str(inertia))

W = 0.85
c1 = 1
c2 = 1.5

quant_error_to_beat = 78.85
# Max iterations, we'll stop when we beat the quant error of k-means
# n_iterations = int(input("Inform the number of iterations: "))
n_iterations = 200
# target_error = float(input("Inform the target error: "))
target_error = 1e-4
# n_particles = int(input("Inform the number of particles: "))
n_particles = 150


class Particle:
    def __init__(self):
        self.solution = np.array([[random.uniform(minima[d], maxima[d]) for d in range(X.shape[1])] for i in range(np.unique(y, return_counts=False).size)])
        self.pbest_solution = self.solution
        self.pbest_value = float('inf')
        self.velocity = np.array([0, 0, 0, 0])

    def __str__(self):
        print("I am at ", self.solution, " meu pbest is ", self.pbest_solution)

    def move(self):
        self.solution = self.solution + self.velocity

    def fitness(self):
        dist_label = np.zeros((len(X),len(self.solution)+1)) #+1 for label
        for i in range(len(X)):
            for j in range(len(self.solution)):
                dist_label[i,j]=distance.euclidean(X[i], self.solution[j])
            dist_label[i,3] = np.argmin(dist_label[i,:3]) #Set the best matching centroid as label

        return np.mean([distance.euclidean(data,self.solution[int(dist_label[i,3])]) for data,i in zip(X,range(len(X)))])


class Space:

    def __init__(self, target, target_error, n_particles):
        self.target = target
        self.target_error = target_error
        self.n_particles = n_particles
        self.particles = []
        self.gbest_value = float('inf')
        self.gbest_solution = np.array([random.random(), random.random(), random.random(),random.random()])

    def print_particles(self):
        for particle in self.particles:
            particle.__str__()

    def set_pbest(self):
        for particle in self.particles:
            fitness_cadidate = particle.fitness()
            if (particle.pbest_value > fitness_cadidate):
                particle.pbest_value = fitness_cadidate
                particle.pbest_solution = particle.solution

    def set_gbest(self):
        for particle in self.particles:
            best_fitness_cadidate = particle.fitness()
            if (self.gbest_value > best_fitness_cadidate):
                self.gbest_value = best_fitness_cadidate
                self.gbest_solution = particle.solution

    def move_particles(self):
        for particle in self.particles:
            global W
            new_velocity = (W * particle.velocity) + (c1 * random.random()) * (particle.pbest_solution - particle.solution) + \
            (random.random() * c2) * (self.gbest_solution - particle.solution)
            particle.velocity = new_velocity
            particle.move()


search_space = Space(1, target_error, n_particles)
particles_vector = [Particle() for _ in range(search_space.n_particles)]
search_space.particles = particles_vector
#search_space.print_particles()


def quantization_error(solution):
    dist_label = np.zeros((len(X),len(solution)+1))
    for i in range(len(X)):
        for j in range(len(solution)):
            dist_label[i, j] = distance.euclidean(X[i], solution[j])
        dist_label[i, 3] = np.argmin(dist_label[i, :3])

    return np.sum(np.square(np.array([distance.euclidean(data,solution[int(dist_label[i,3])]) for data,i in zip(X,range(len(X)))])))


iteration = 0
quant_error = 1
while (iteration < n_iterations):
# while (quant_error > quant_error_to_beat):
    print("Iteration " + str(iteration))
    search_space.set_pbest()
    search_space.set_gbest()

    if (abs(
            search_space.gbest_value - search_space.target) <=
            search_space.target_error):
        break
    print("Error = " + str(abs(search_space.gbest_value - search_space.target)))
    quant_error = quantization_error(search_space.gbest_solution)
    print(str(quant_error))
    search_space.move_particles()
    print("Total computation time = " + str(datetime.now() - startTime))
    iteration += 1
    print("Quantization error = " + str(quant_error))

print("The best solution is: ", search_space.gbest_solution, " in n_iterations: ",
      iteration)

print("PSO Quantization error Iris Dataset = " + str(quant_error))
