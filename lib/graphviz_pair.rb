class GraphvizPair
	attr_reader :tree, :gviz
	def initialize tree, gviz
		@tree	= tree
		@gviz	= gviz
	end
end