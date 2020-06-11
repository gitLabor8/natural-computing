# ###
# Write out the results of our algorithm to a file
# ##

import json


def write_json(data):
    with open('storage/data.json','w') as f:
        json.dump(data, f, indent=4)


def store_intermediate_results(gene, generation, run, fitness, id):
    with open('storage/data.json') as f:
        data = json.load(f)
        l = {'gene': gene,
             'generation': generation,
             'data': run,
             'fitness': fitness,
             'id': id.int}
        data.append(l)
        write_json(data)
