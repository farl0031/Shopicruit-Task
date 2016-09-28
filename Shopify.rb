require 'rubygems'
require 'net/http'
require 'json'

json_iterator = 1
products_array = []

# Loop through remote json
# populate products_array with products parsed from json
loop do

  url = "http://shopicruit.myshopify.com/products.json?page="
  url = url + json_iterator.to_s

  resp = Net::HTTP.get_response(URI.parse(url))
  json_raw = resp.body
  json_parsed = JSON.parse(json_raw)

  # check if parsed json is empty - If empty, break out of loop
  if json_parsed['products'].empty?
    break;
  end

  products_iterator = 0

  # populate products_array with products parsed from json
  while products_iterator < json_parsed['products'].length
    products_array.push(json_parsed['products'][products_iterator])
    products_iterator += 1
  end

  json_iterator += 1
end


total_cost = 0.0
products_iterator = 0
# Calculate sum total of costs for all watches and clocks
while products_iterator < products_array.length

  # Loop through products_array to find all watches and clocks
  if products_array[products_iterator]['product_type'] == 'Clock' || products_array[products_iterator]['product_type'] == 'Watch'
    variants_iterator = 0

    # Add cost of all variants of watch/clock to total_cost
    while variants_iterator < products_array[products_iterator]['variants'].length
      total_cost += products_array[products_iterator]['variants'][variants_iterator]['price'].to_f
      variants_iterator += 1
    end

  end

  products_iterator += 1
end


puts '$' + total_cost.round(2).to_s