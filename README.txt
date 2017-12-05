Henry Grover & Carlos Calero
groveh & calerc

Part 1:

Simulation would start by getting the type of simulation as A, B or C. 
It would also find the board size, number of buttons, start cell and goal cell. 
An if statement would call findPath() if all buttons were pressed, if they were pressed , 
then the function would find the goal cell, else if would find the next button.
findPath(), would find the path between the current position and the end position 
specified. This was done in a brute force recursive function that would move to 
a valid block up, down, left and right of the current block position. 
A valid block was a block that was not out of bounds, the goal, a wall  
and an invalid button. An invalid button was a button that was not the next 
button to be pressed. Once all the buttons were pressed, findPath would then find 
the path to the goal. The program would then stop. The path would be printed to 
an output file. Our program works with all  test cases we gave it except with a 
ten by ten board with no walls. In theory our solution should work, but we 
didn't run our program lon enough. 


Part2:
 

