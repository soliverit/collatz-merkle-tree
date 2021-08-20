require "digest"
class CollatzMerkleNode
	SHORT = true
	attr_reader :parent1, :parent2
	def initialize parent1, parent2
		@parent1	= parent1
		@parent2	= parent2
	end
	def hash 
		
		h = Digest::SHA256.hexdigest "#{@parent1.hash}\n#{@parent2.hash}"
		SHORT ? h[0,20] : h
	end
end