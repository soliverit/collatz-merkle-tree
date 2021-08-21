require_relative "collatz_merkle_leaf.rb"
require_relative "collatz_merkle_node.rb"
class CollatzMerkleLayer
	def initialize 
		@nodes	= []
	end
	def length
		@nodes.length
	end
	def pushLeaf id, from, to, value
		@nodes.push CollatzMerkleLeaf.new(id, from, to, value)
	end
	def pushNode parent1, parent2
		@nodes.push CollatzMerkleNode.new(parent1, parent2) 
	end
	def [] idx
		@nodes[idx]
	end
	def eachNode
		@nodes.each_with_index{|node, index| yield node, index}
	end
end