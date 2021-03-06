
# Playing GIRP
## A Genetic Algorithm Approach
### Dependencies
To install the python (3) packages needed to run the project code, run:

```
pip install -r requirements.txt
```
Furthermore, the driver requires a Firefox installation with a working Flash player.

### Configuration
To configure the genetic algorithm, hyperparameters in `'config.py'` can be configured.

### Running the code
To start the project code, run

```
python code/main.py
```

The Firefox instance will start and navigate to [http://foddy.net/GIRP.html](http://foddy.net/GIRP.html) and the program will ask you to click the $\verb!Allow!$ popup to enable Flash playback on the GIRP and click on the game window to start the game. The driver will now start to control the game with timed key pressed generated by the genetic algorithm.

Note that any other input from peripherals or clicking on other windows will disrupt the genetic algorithm.

After the game is done, the Firefox window will close and a visualisation of the max fitness, average fitness and reached height will follow.

### Example run
We recorded a screen recording of the program in action named `'example_run.mov'`.
