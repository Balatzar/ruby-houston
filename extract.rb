require "csv"
require "open-uri"

destination = "./photos"

Dir.mkdir(destination) unless Dir.exists?(destination)
CSV.foreach("./images.csv", :headers => true) do |row|
  name = row[0]
  url = row[2]
  puts "Downloading #{name}"
  File.open("#{destination}/#{name}", 'wb') do |fo|
    fo.write open(url).read
  end
end