## Includes
# Gem
require "digest"
##
# A Merkle tree leaf
##
class CollatzMerkleLeaf
	attr_reader :hash
	def initialize id, from, to, value
		@id		= id									#Int, transaction ID
		@from	= from									#String, person who is sending currency
		@to		= to									#String, person who is receiving currency
		@value	= value									#Float, currency value
		@hash	= @id.to_s + @from + @to + @value.to_s  #String of transaction. Not really hash, a relic of the hashed test stuff
	end
end