#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#Initialized population size and mutation rate as 10 
    def _init_(self):
        self.population = []
        self.population_size = 10
        self.mutation_rate = 10

# DNA generation based on encoding
    def generate_dna(self):
        choices = ["a","b","c","ab","ac","bc","abc"]
        self.start_time = time.time()
        dna = []
        for x in range(10):
            dna.append(random.choice(choices))
        return dna   
    
    def generate_population(self):
        self.population = []
        for x in range(self.population_size):
            dna = self.generate_dna()
            self.population.append(dna)
     
    def tournament_selection(self):
        score = []
        final= [] #combined list 
        self.generate_population()
        gene_samples=random.sample(self.generate_population,3)
        for i in range(1:4):
            #passing the gene sample for that score value
            score[i] = self.get_score(gene_samples[i])
        Gene_score = {'gene_samples':gene_samples,'score':score}
        df = pd.DataFrame(Gene_score)
        #combine the 2 lists
        df_final = df.sort_values(by = ['score'], ascending=False)
        return(df_final.head(2)) 
                        
    def mutation(self, gene1, gene2):
        visited = {}
        population = []
        for x in range(self.population_size):
            position = random.randint(0, len(gene1))
            if not visited.get(position):
                visited[position] = True
                if random.randint(0, 50) > 25:
                    child = gene1[0:position] + gene2[position:]        
                    if random.randint(0, 50) <= self.mutation_rate:
                        index = random.randint(0, len(child) - 1)
                        child[index] = self.generate_dna()[0]
                    population.append(child)
                else:
                    child = gene2[0:position] + gene1[position:]
                    if random.randint(0, 50) < self.mutation_rate:
                        index = random.randint(0, len(child) - 1)
                        child[index] = self.generate_dna()[0]
                    population.append(child)
            else:
                population.append(self.generate_dna())
        self.population = population

