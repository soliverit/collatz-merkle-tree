#############################################
#											#
# 	Collatz-Merkle tree							#
#											#
#	A Merkle tree but it's a directed acyclic graph 		#
#	constructed by applying  the Collatz-conjecture rules	#
#		n % 2 == 0 ? 0.5n : 3n + 1					#
#											#
#	Why? Glad you aske...						#
#############################################
class CollatzMerkleTree
	def initialize
		@layers					= []
		@initialTransactions 	= []
	end
	# Add the passed leaf if it isn't in @initialTransactions already (lies, doesn't check!!!)
	def addTransaction id, value
		@initialTransactions.push CollatzMerkleNode.new(id, value)
	end
	# Build the tree
	def build
		# First layer
		@layers			= [CollatzMerkleLayer.new]
		@initialTransactions.each{|transaction| @layers.first.pushNode transaction}
		# Create the other layers
		while true
			# Create the next layer
			nextLayer		= CollatzMerkleLayer.new
			# Until the number of nodes in the next layer == the next Collatz number
			(0...(nextCollatz @layers.last.length)).each{|nodeIDX|
				nextLayer.pushNode CollatzMerkleChildNode.new(
					@layers.last[(nodeIDX * 2) % @layers.last.length], 
					@layers.last[(nodeIDX * 2 + 1) % @layers.last.length]
				)
			}
			# Add the layer 
			@layers.push nextLayer
			# Reached the root
			break if nextLayer.length == 1
		end
	end
	# Take a number, get the next Collatz number
	def nextCollatz n
		((n + 2) % 2 == 0) ? n / 2 : n * 3 + 1		
	end
	# Output some stuff see if it looks right
	def print
		(0...@layers.length).each{|idx| puts "#{idx}\t#{@layers[idx].length}"}
	end
end
class CollatzMerkleLayer
	def initialize 
		@nodes	= []
	end
	def length
		@nodes.length
	end
	def pushNode node
		@nodes.push node unless @nodes.find_index node
	end
	def [] idx
		@nodes[idx]
	end
end
class CollatzMerkleNode
	def initialize id, value
		@id		= id
		@value	= value
	end
	def hash
		"#{@id}:#{value}"
	end
end
class CollatzMerkleChildNode
	def initialize parent1, parent2
		@parent1	= parent1
		@parent2	= parent2
	end
	def hash
		@parent1.hash + @parent2.hash
	end
end