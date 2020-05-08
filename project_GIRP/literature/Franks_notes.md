# Literature Notes

## Evolving QWOP Gaits

### Basic terminology
Control Scheme: buttons 'q', 'w', 'o' and 'p'. Normal human running is practically impossible, since previous walking motoric experience is ueseless because it's control scheme is rerouted through these buttons. Instead people opt for scooting.

Ragdoll Physics: method for procedurally animating characters based on the skeletal configuration of the rigid bodies by joints in a simulated physical environment.
As a result gravity always tries to get the runner to fall and constantly demands correction. On top of that all movements has consequences for the overall momentum and velocity, making every change unforgiving.

Genetic Algorithm Models (GA's): lot of candidates/population that reproduces every cycle. New population is built from the old one according to fitness.

Steady State GA: Only replace a few instances of the population every cycle, mostly the fittest and some random.

Cellular GA: Introduces isolation by distance, a new candidate evolves based on it's previous neighbours. This way we can have subpopulations -> more diversity.

### Interfacing
Uses java.awt.Robot class. Periodically takes score screencap, turns it black and white and parses a number out of it. If player falls, uses spacebar to restart.

### Gait evolution
Tried two encodings:
 - _encoding 1_: capital letter is press that button, small letter is release the button. '+' is a delay of 150ms. It's easy to read and understand. Context dependent.
 - _encoding 2_: Every combination of button presses is encoded in a letter, so 2^4 = 16 letters. Assumes 150ms delay. Context independent.

Mutation operator: randomly select and alter a character in every child runner.

Crossover strategies:
 - _cut-and-splice_ or _single-point_: 
   - Def: Different crossover point for every parent, causing varying chromosomal lengths in offspring.
   - Motivation: no fixed/obvious loop length
 - _two-point_:
   - Def: Same crossover points on both parents. Offspring have same chromosomal length.
   - Motivation: Assumes fixed loop lenght. Loop length can be estimated as parameter

Evolutionary models used:
 - Standard Genetic Algorithm (SGA)
 - Cellular Genetic Algorithm (CGA)

CGA uses 
 - two-dimensional wrap-around grid structure, so everyone has the same amount of neighbours. Idea is to slow premature convergence on suboptimal solution by enhancing the diversity. 
 - Children only replace parents when they are more fit, making total fitness monotone increasing and gives elitism, good traits can't disappear. 
 - Runners can only mate with fittest neighbour
 
Scores:
 - Final state:
   - Crashed: Runner fell over: fitness = 0
   - Stopped: Timer ran out: fitness = final distance 
   - other combo's were explored, but not deemed good enough to put in the paper (so first get a stable gait, than focus speed)
   
Init:
 - Randomly seed all runners
 - Above, but for way too many runners, then run fitness on them for max 60 seconds
 - SGA: 16 runners
 - CGA: 30 runners
 
### Results
Initialisation brought some variation in testing: a runner that stands still starts wobbling due to the physics engine. -> Same gene has different outcomes. Increases importance of stable gait, as are allowed to reproduced.

Has 2 openings that are standard. Fastest human player has different, more unstable, opening as he can use longer combinations to get to a stable gait.

Config 1:
 - SGA, encoding 1, 3:2 tournament selection, single point crossover, init best 16 out of 390 randoms
 - Fails to improve, due to high fail rate of children worsening the gene pool

Config 2:
 - Same, but children only survive the next gen if they outperform the worst of the three parents
 - Creates positive results!

Config 3: (spoiler: it's the best)
 - CGA, encoding 2, two-point crossover, init best 30 of 500 randoms
 
Encoding models: encoding 2 yields a better initialisation. Other traits of config 3 ensure fast acceleration of fitness.

### Conclusion
 - CGA was the best.
 - Steady state models > generational when fitness is highly sensitive to small changes in encoding
 - Looking at the body instead of just the score would improve result
 - Running takes long, because of browser simulation. Parallellisation might mitigate this

## A (Java)Framework for Genetic Algorithms in Games
Six steps to evolutionary algorithms:
 - Population creation
 - Fitness evaluation
 - Chromosome mating and mutation
 - deletion of lowest fitness individuals
 - re-evaluation of new population
 
Nice things:
 - Easily parallelisable
 - Avoids local maxima through mutations

Not so nice things (drawbacks):
 - Time consuming
 - A lot of options to tweak so a lot of experimentation is needed
 - No guarantee of optimal solution, although good local maxima are sufficient for games
 - Hard to debug
 
### Framework Description
Roles of an individual:
 - provide business methods for accessing domain specific properties
 - implement common GA interface
 - act as mediator for genome structure and manipulation

Advantages:
 - Fitness function doesn't manipulate genome directly, resistant to changes
 - Framework independent of genome structure. Multiple structures can be experimented with

From this point on it gets really technical, really fast. If we're not using this exact framework, I'm not sure how useful this is.

Crossovers:
 - Point crossover: Userdefined number of crossover points. Can be multi point crossover. Allows only random mutation
 - Uniform crossover: 
 
Scaling: Prevents super individuals, units that dominate entire population. Rank scale and sigma truncation scale.

Selection methods:
 - Tournament
 - Roulette wheel, but optimised (less iterative loops)
 - Stochastic

An example of Simcity follows and than a short conclusion.



