##Includes
# Project
require_relative "collatz_merkle_leaf.rb"
require_relative "collatz_merkle_node.rb"
##
# A Merkle tree layer with multiple CollatzMerkleLeaf or CollatzMerkleNode nodes 
##
class CollatzMerkleLayer
	def initialize 
		@nodes	= []	# CollatzMerkleLeaf or CollatzMerkleNode 
	end
	##
	# Number of nodes
	##
	def length
		@nodes.length
	end
	##
	# Push a CollatzMerkleLeaf: A transaction , really
	##
	def pushLeaf id, from, to, value
		@nodes.push CollatzMerkleLeaf.new(id, from, to, value)
	end
	##
	# Push a CollatzMerkleNode
	##
	def pushNode parent1, parent2
		@nodes.push CollatzMerkleNode.new(parent1, parent2) 
	end
	##
	# Subscripted access to nodes
	##
	def [] idx
		@nodes[idx]
	end
	##
	# Node iterator: no output
	##
	def eachNode	
		@nodes.each_with_index{|node, index| yield node, index}
	end
end