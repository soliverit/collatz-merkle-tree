# Collatz-Merkle-tree
## A Merkle tree but it's also a directed acyclic graph!

### What it does
A set of transactions are added to the tree and paired to be linked to a node in the next layer. But, instead of n_current = n_previous / 2 nodes on each layer, n_current = n_previous % 2 == 0? n_prevoius / 2 : 3 * n_previous + 1

### Why?
Thanks for asking

### Example

```Ruby
## Includes
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
```


 ![Tux, the Linux mascot](https://i.imgur.com/egemHkx.png)
 
### Notes:
- There's a "salt" in CollatzMerkleLeaf to ensure all node has a unique hash. If this makes it beyond a joke, I'll do something proper.
