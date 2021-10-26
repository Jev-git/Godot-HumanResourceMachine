# Doing
* Do the random solver first, since it is the actual solver without any graphic

* Level loader:
    * _ready(): get_random_inputs()
    * Reload button: clear inputs and call get_random_inputs() again
* VisualSolver:
    * Run through the instructions one by one, and interact with the nodes on the screen
    * If there are error, display on pop up, and then reload scene (but keep instructions)
    * If correct, then run the random solver
* RandomSolver:
    * Get random inputs
    * Run through the instructions one by one, but doesn't interact with nodes on the screen
    * Display check result on popup
* Verifier:
    * Generate random inputs
    * Take in a set of input and output, and verify if the output satisfy the requirement of that level.
# Time range
Sept 20th - Oct 4th (2.5 weeks)
# MVP
* ~~Draggable and dropable instructions~~
* ~~Sequencial execution~~
* Loop instructions that have a head and a tail
* Verify the solution by trying it out with a bunch of different inputs
# Instructions
* Inbox
* Outbox
* Jump
* Add
* Sub
* Copyfrom
* Copyto
# Optional
* Comments
* Multiple solution tabs
* Size/Speed challenges