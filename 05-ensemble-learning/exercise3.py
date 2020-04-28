import math
import matplotlib.pyplot as plt
import numpy as np

P_strong = 0.85
P_weak = 0.60

def binomial_coeff(n, k):
    # n choose k
    if k == 0 or k == n:
        return 1
    return binomial_coeff(n - 1, k - 1) + binomial_coeff(n - 1, k)
#Exercise 3a
def calc_even_weights():
    sum_1 = 0
    sum_2 = 0
    for i in range(5,11):
        sum_1 += binomial_coeff(10, i)*(P_weak**i)*((1-P_weak)**(10-i))

    for j in range(6,11):
        sum_2 += binomial_coeff(10, j)*(P_weak**j)*((1-P_weak)**(10-j))

    return (P_strong*sum_1)+((1-P_strong)*sum_2)

def weighted_majority_vote(W_strong):
    sum_1 = 0
    sum_2 = 0
    W_weak = (1 - W_strong)/10

    nr_of_weak = 1
    while W_strong + (nr_of_weak*W_weak) <= 0.5:
        nr_of_weak += 1

    nr_of_only_weak = 1
    while nr_of_only_weak*W_weak <= 0.5:
        nr_of_only_weak += 1

    for i in range(nr_of_weak,11):
        sum_1 += binomial_coeff(10, i)*(P_weak**i)*((1-P_weak)**(10-i))

    for j in range(nr_of_only_weak,11):
        sum_2 += binomial_coeff(10, j)*(P_weak**j)*((1-P_weak)**(10-j))

    return (P_strong*sum_1)+((1-P_strong)*sum_2)
# exercise 3b
def plot_weights_probabilities():
    data_x = list()
    data_y = list()
    for i in np.arange(1/11,0.5,0.01):
        data_x.append(i)
        data_y.append(weighted_majority_vote(i))

    plt.plot(data_x, data_y)
    plt.xlabel("Weight of strong classifier (p=0.85).")
    plt.ylabel("Majority vote probability of a correct decision.")
    plt.show()


def adaWeight(SuccessProb):
    err_weak = 1.0 - SuccessProb
    W = math.log((1.0-err_weak)/err_weak)
    return W
# exercise 3c
def adaWeakStrong():
    W_weak = adaWeight(P_weak)
    W_strong = adaWeight(P_strong)
    W_weak_N = W_weak/(10*W_weak+W_strong)
    W_strong_N = W_strong/(10*W_weak+W_strong)
    return W_weak_N, W_strong_N
# exercise 3d
def adaPlot():
    data_x = list()
    data_y = list()
    for i in np.arange(0.99,0.0,-0.01):
        data_x.append(1.0-i)
        data_y.append(adaWeight(i))
    plt.plot(data_x, data_y)
    plt.xlabel("Error rate of base learner.")
    plt.ylabel("AdaBoost.M1 weight.")
    plt.show()


def main():
    # print("Weak classifier weight = %f, Strong classifier weight = %f" % (adaWeakStrong()))
    # exercise 3a
    print("Answer to 3a = %f " % calc_even_weights())
    calc_even_weights()
    # exercise 3b
    print("Answer to 3b is a figure.")
    plot_weights_probabilities()
    # exercise 3c
    print("Answer to 3c = ")
    print("Weak classifier weight = %f, Strong classifier weight = %f" % (adaWeakStrong()))
    # exercise 3d
    print("Answer to 3d is a figure.")
    adaPlot()

if __name__ == "__main__":
    main()
