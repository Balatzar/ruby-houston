require 'csv'
require 'open-uri'
require 'fileutils'

destination = './photos'
temp_folders = 4
winners = []

folders = (0...temp_folders).map do |i|
  Dir.mkdir("./temp#{i}") unless Dir.exist?("./temp#{i}")
  "./temp#{i}"
end

puts folders

Dir.mkdir(destination) unless Dir.exist?(destination)

CSV.foreach('./images.csv', headers: true) do |row|
  name = row[0]
  url = row[2]
  puts "Extracting #{name}"
  folders.each do |folder|
    File.open("#{folder}/#{name}", 'wb') do |fo|
      puts "Download file to #{folder}"
      fo.write open(url).read
    end
  end
  winner = 0
  winner_size = 0
  folders.each_with_index do |folder, i|
    size = File.size "#{folder}/#{name}"
    puts "#{folder} is size #{size}"
    if size > winner_size
      winner_size = size
      winner = i
    end
  end
  puts "Winner is temp#{winner}"
  winners << winner
  FileUtils.mv("#{folders[winner]}/#{name}", "#{destination}/#{name}.jpg")
  folders.each do |folder|
    File.delete("#{folder}/#{name}") rescue Errno::ENOENT
  end
  sleep(5)
end

File.open("./logs", 'w') { |file| file.write(winners.join(",")) }
