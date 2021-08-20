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
				if nodeIDX < @layers.last.length
					nextLayer.pushNode(
						@layers.last[(nodeIDX * 2) % @layers.last.length], 
						@layers.last[(nodeIDX * 2 + 1) % @layers.last.length]					
					)
				else
					nextLayer.pushNode(
						@layers.last[(rand(1000) + @layers.last.length) % @layers.last.length], 
						@layers.last[(rand(1000) + @layers.last.length) % @layers.last.length]					
					)
				end
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
	# Draw the graph  
	def graphviz location
		g 	= GraphViz.new( :G, :type => :digraph )
		gNodes	= {}
		@layers.each{|layer| 
			layer.eachNode{|node| gNodes[node.to_s]	= g.add_nodes(node.hash)}
		}
		@layers.each{|layer|
			layer.eachNode{|node|
				next if node.class == CollatzMerkleLeaf
				gNode			= gNodes[node.to_s]
				g.add_edges(gNodes[node.parent1.to_s], gNode)
				g.add_edges(gNodes[node.parent2.to_s], gNode) 
			}
		}
		g.output( :png => location)
	end
end