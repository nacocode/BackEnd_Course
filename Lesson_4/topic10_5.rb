flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)
p flintstones.select { |name| name[0,2] == "Be" }