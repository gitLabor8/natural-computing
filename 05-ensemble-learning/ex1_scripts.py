import math as m


def binomialCoeff(n, k):
    if k == 0 or k == n:
        return 1
    # Recursive Call
    return binomialCoeff(n - 1, k - 1) + binomialCoeff(n - 1, k)

# 0 <= p <= 1
# n > 0, odd if you want sensible answers
def chance_of_success(p, n):
    aggregated_chance = 0
    for i in range(0, m.ceil(n/2) + 1):
        aggregated_chance += binomialCoeff(n, i) * pow(p, n - i) * pow(1-p, n-i)
        print(str(i) + ": " + str(aggregated_chance))
    return aggregated_chance


print(binomialCoeff(3, 2))
print("Result: ")
print(chance_of_success(0.8, 3))
# print(chance_of_success(0.5, 2))
