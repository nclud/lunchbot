# Description:
#   Tells you what food trucks are nearby, simple as that.
#
# Dependencies:
#   "scraper": "0.0.9"
#
# Configuration:
#   None
#
# Commands:
#	lunchbot foodtruck - Returns all food trucks currently at Franklin Square.
#
# Author:
#   kyle_conrad
#


request = require('request')
cheerio = require('cheerio')


module.exports = (robot) ->

  robot.hear /foodtruck/i, (msg) ->

    vendors = []

    request 'http://foodtruckfiesta.com/dc-food-truck-list/', (error, response, html) ->
      if !error and response.statusCode == 200
        $ = cheerio.load(html)

        $('div.post-content > h2').each ->
          vendors.push $(this).text()
          return
      return

  vendor = vendors[0]
  msg.send vendor