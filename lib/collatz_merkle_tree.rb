## Includes
# Gems
require "active_support"
require 'ruby-graphviz'
# Project
require_relative "collatz_merkle_layer.rb"
require_relative "collatz_merkle_leaf.rb"
require_relative "graphviz_pair.rb"
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
	def addTransaction from, to, value
		@initialTransactions.push({id: @initialTransactions.length + 1, from: from, to: to, value: value})
	end
	# Build the tree
	def build
		# First layer
		@layers			= [CollatzMerkleLayer.new]
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
	# Take a number, get the next Collatz number
	def nextCollatz n
		((n + 2) % 2 == 0) ? n / 2 : n * 3 + 1		
	end
	def gviz location
		g 	= GraphViz.new( :G, :type => :digraph )
		layerSets = []
		@layers = @layers.reverse
		nodeCounters = {}
		doneConnections = {}
		@layers.each{|layer|
			layerSets.push({})
			layer.eachNode{|node|
				layerSets.last[node.hash] 	= g.add_nodes(node.hash)
				doneConnections[node.hash] 	= {}
			}
		}
		ii = 0
		(0...@layers.length - 1).each{|layerID|
			puts @layers[layerID].length
			@layers[layerID].eachNode{|node, idx|
				# next if doneConnections[node.hash] && doneConnections[node.hash][node.parent1.hash] == true
				# next if doneConnections[node.hash] && doneConnections[node.hash][node.parent2.hash] == true
				# next if doneConnections[node.parent1.hash] && doneConnections[node.parent1.hash][node.hash] == true
				# next if doneConnections[node.parent2.hash]	&& doneConnections[node.parent2.hash][node.hash] == true
				gNode = layerSets[layerID][node.hash]
				g.add_edges( layerSets[layerID + 1][node.parent1.hash], gNode)
				g.add_edges( layerSets[layerID + 1][node.parent2.hash], gNode)
				doneConnections[node.hash][node.parent1.hash] 	= true
				doneConnections[node.hash][node.parent2.hash] 	= true	
				
				ii += 1
			}
		}
		g.output( :png => location)
	end
end