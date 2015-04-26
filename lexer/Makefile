RACC_FLAGS=-g -v # DEBUG
#RACC_FLAGS=
RACC=racc
RDOC=rdoc
PARSER = parser.y

parser.rb: ${PARSER}
	${RACC} parser.y -o parser.rb
clean:
	rm parser.rb

