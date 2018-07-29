require "csv"
require "byebug"
require 'open-uri'

# ouvrir le csv

# parcourir chaque rangee
# stocker la premiere cellule => nom de fichier
# stocker la 3eme cellule => url a telecharger
# telecharger le fichier et lui donner le bon nom

LIMIT = 10
destination = "./photos"
i = 0

Dir.mkdir(destination) unless Dir.exists?(destination)
CSV.foreach("./images.csv", :headers => true) do |row|
  name = row[0]
  url = row[2]
  puts "Downloading #{name}"
  File.open("#{destination}/#{name}", 'wb') do |fo|
    fo.write open(url).read
  end
  break if i == LIMIT
  i += 1
end