require "digest"

class CollatzMerkleNode
	SHORT = false
	attr_reader :parent1, :parent2, :hash
	def initialize parent1, parent2
		@parent1	= parent1
		@parent2	= parent2
		@salt		= rand.to_s
		@hash		= generateHash
	end
	def generateHash
		h = Digest::SHA256.hexdigest "#{@salt}#{Time.now}#{@parent1.hash}\n#{@parent2.hash}"
		SHORT ? h[0...8] : h
	end
end