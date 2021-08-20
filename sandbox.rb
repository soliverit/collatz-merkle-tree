require "./collatz-merkle.rb"

# Make the tree
tree	= CollatzMerkleTree.new
# Create some transactions
tree.addTransaction 0, "shoe"
tree.addTransaction 1, "fire"
tree.addTransaction 2, "water"
tree.addTransaction 3, "bucket"
tree.addTransaction 4, "caravan"
# Go
tree.build
# Debug
tree.print