## Includes
# Gems
require "active_support"
require 'ruby-graphviz'
# Project
require_relative "collatz_merkle_layer.rb"
require_relative "collatz_merkle_leaf.rb"
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
	##
	# Set up properties, nothing else on the go here
	##
	def initialize
		@layers					= [] # []CollatzMerkleLayer
		@initialTransactions 	= [] # Hash{ from, to, value}
	end
	##
	# Add the passed leaf if it isn't in @initialTransactions already (lies, doesn't check!!!)
	##
	def addTransaction from, to, value
		@initialTransactions.push({id: @initialTransactions.length + 1, from: from, to: to, value: value})
	end
	##
	# Build the tree
	##
	def build
		# First layer
		@layers			= [CollatzMerkleLayer.new]
		# Add leaves to the first layer that represent the staged transactions
		@initialTransactions.each{|transaction| 
			@layers.first.pushLeaf(
				transaction[:id], 
				transaction[:from], 
				transaction[:to],
				transaction[:value]
			)
		}
		# Create the other layers
		while true
			# Create the next layer
			nextLayer		= CollatzMerkleLayer.new
			# Until the number of nodes in the next layer == the next Collatz number
			(0...(nextCollatz @layers.last.length)).each{|nodeIDX|
				nextLayer.pushNode(
					@layers.last[(nodeIDX * 2 + @layers.last.length) % @layers.last.length], 
					@layers.last[(nodeIDX * 2 + 1 + @layers.last.length) % @layers.last.length]					
				)
			}
			# Add the layer 
			@layers.push nextLayer
			# Reached the root
			break if nextLayer.length == 1
		end
	end
	##
	# Take a number, get the next Collatz number : input is Even?  n /2. input is Odd? 3n + 1
	##
	def nextCollatz n
		((n + 2) % 2 == 0) ? n / 2 : n * 3 + 1		
	end
	##
	# Draw the graphviz graph graph
	##
	def gviz location
		# Canvas
		g 			= GraphViz.new( :G, :type => :digraph )
		# It's less hassle to work with the reversed list. Like a tiny bit of readability
		layers		= @layers.reverse
		# Assign a graphviz-node to every  Leaf and Node
		layerSets 	= []
		layers.each{|layer|
			layerSets.push({})
			layer.eachNode{|node|layerSets.last[node.hash] 	= g.add_nodes(node.hash)}
		}
		# For each layer, create edges between the current Node and its parents.  
		(0...layers.length - 1).each{|layerID|
			layers[layerID].eachNode{|node, idx|
				gNode = layerSets[layerID][node.hash]
				g.add_edges( layerSets[layerID + 1][node.parent1.hash], gNode)
				g.add_edges( layerSets[layerID + 1][node.parent2.hash], gNode)
			}
		}
		g.output( :png => location)
	end
end