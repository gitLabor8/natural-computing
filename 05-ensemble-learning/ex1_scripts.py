import math

limit = 20
w, h = 2*limit, 2*limit
lookupTable = [[0.0 for x in range(w)] for y in range(h)]


def binom_lookup_table(n, k):
    if lookupTable[n][k] == 0.0:
        # Compute the new value
        coeff = binomial_coeff(n, k)
        lookupTable[n][k] = coeff
        return coeff
    else:
        # Lookup the old value
        return lookupTable[n][k]


def binomial_coeff(n, k):
    # n choose k
    if k == 0 or k == n:
        return 1
    # Recursive Call
    return binom_lookup_table(n - 1, k - 1) + binom_lookup_table(n - 1, k)


def chance_of_success(p, n):
    # 0 <= p <= 1
    # n > 0, odd if you want sensible answers
    aggregated_chance = 0
    for i in range(0, math.ceil(n/2)):
        aggregated_chance += binom_lookup_table(n, i) * pow(p, n - i) * pow(1 - p, i)
    return aggregated_chance


for i in range(0, limit):
    print(chance_of_success(0.60, i*2+1))

# print(chance_of_success(0.5, 2))
