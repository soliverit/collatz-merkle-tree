## Includes
# Gems
require 'ruby-graphviz'
# Local
require "./lib/collatz_merkle_tree.rb"
## Do stuff
# Make the tree
tree	= CollatzMerkleTree.new
# Create some transactions
tree.addTransaction "Dave", "Claire", 100
tree.addTransaction "Dave", "Claire", 100
tree.addTransaction "Tahir", "Rachel", 120
tree.addTransaction "Tahir", "Rachel", 120
tree.addTransaction "Tahir", "Rachel", 120
tree.addTransaction "Tahir", "Rachel", 120
# Go
tree.build
# Draw
tree.gviz "./collatz-merkle-tree.png"
