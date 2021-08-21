## Includes
# Gem
require "digest"
##
# A Merkle tree node: Two parents and a hash
##
class CollatzMerkleNode
	attr_reader :parent1, :parent2, :hash
	def initialize parent1, parent2
		@parent1	= parent1		#CollatzMerkleNode or CollatzMerkleLeaf
		@parent2	= parent2		#CollatzMerkleNode or CollatzMerkleLeaf
		@salt		= rand.to_s		#String - a simple hash uniqifier... duplicate node hashes. Do something else later, or don't
		@hash		= generateHash	#String - SHA256 hash
	end
protected
	##
	# One-off create hash
	##
	def generateHash
		Digest::SHA256.hexdigest "#{@salt}#{Time.now}#{@parent1.hash}\n#{@parent2.hash}"
	end
end