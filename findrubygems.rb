require "open-uri"
require "nokogiri"

BASE_URL = "https://rubygems.org"

def findrubygem(query)
    result = URI.open("#{BASE_URL}/search?query=#{query.to_s}")
    data = Nokogiri::HTML(result).css("a.gems__gem")
    results = []

    data.each do |gem|
        info = gem.children[1].css("h2").children
        name = info.first.content.gsub("\n      ", "")
        version = info[1].children.first.content

        url = BASE_URL + gem.attributes["href"].value

        desc = gem.css("p").first.children.first.content
        downloads = gem.css("p")[1].children.first.content.gsub("\n    ", "")

        results.push({name: name, version: version, downloads: downloads, url: url, description: desc})
    end

    return results
end

puts "Welcome to findrubygems!"
puts "What gem do you want to search?"

input = gets.chomp
results = findrubygem(input)
index = 0

if results.empty?
    puts
    puts "No gem found. Please try again with another query."
else
    puts
    puts "#{results.length} gem#{results.length != 1 ? "s" : ""} found."
    puts
    results.each do |result|
        index += 1
        
        puts "#{index}. #{result[:name]} - #{result[:description]}"
        puts "Version: #{result[:version]}"
        puts "Downloads: #{result[:downloads]}"
        puts "URL: #{result[:url]}"
        puts if index != results.length
    end
end