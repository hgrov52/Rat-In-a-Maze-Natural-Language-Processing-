Henry Grover & Carlos Calero
groveh & calerc
661490149 & 661374146

********************************
********************************
********************************
***USING PROLOG*****************
********************************
************A*pls?**************
********************************
********************************
********************************

Part 1:

Simulation starts by getting the type of simulation as A, B or C, the board size, number of buttons, start cell and goal cell. 

In Type A, we do a comparison between the known goal coordinates and the current rat coordinates and determine which direction to go to reach the goal.

In Type C, we look for buttons in order until they have all been pressed, then looking for the goal and consequently terminating the program. 

This programs utilizes the findPath function heavily, where it uses a simple recursive path generating method until it reaches the goal and saves that path. Each time findPath is run it prints the valid path it finds to a file, then it returns to the simulateC function where it finds the next object. 

This program also utilizes the isValid function where we determine if a cell is taken up by a wall or if the rat has just visited the cell, to prevent infinite loops. The isValidNL is a custom is valid designed to check for valid paths for part 2 of this assignment. 

Our program works with all test cases we gave it except with a ten by ten board with no walls, due to the fact that it takes too long to come up with a valid solution. In theory our solution should work, but we didn't run our program lon enough. 

Part2:
 
Our program starts with the included parsing function to obtain the list of input sentence. From there we send the list to parseParagraphs where it parses the sentence to determine if it is valid as well as gets the start location as defined in mazeInfo. If the sentence is determined to be valid, it is passed along from parseSentence to interpretValidSentence where it calculates how far and in what direction the command is telling the rat to go, or if there is a button where the rat is told to push the button. It utilizes the isValidNP function from mazeSolver to check the mazeInfo information on whether a wall will block the desired natural language path. If a move is invalid, the program stops and the list of command outcomes is printed to the file. If a sentence is found to be invalid, it is printed to the output file and the program moves on to the next sentence. The next position of the mouse is passed through this heirarchy where if the move is valid, these are set and then passed through to parseParagraph as a way to track the rats movements. 