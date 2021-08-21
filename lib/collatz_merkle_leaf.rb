require "digest"
class CollatzMerkleLeaf
	attr_reader :hash
	def initialize id, from, to, value
		@id		= id
		@from	= from
		@to		= to
		@value	= value
		@hash	= generateHash
	end
protected
	def generateHash
		@id.to_s + @from + @to + @value.to_s
	end
end