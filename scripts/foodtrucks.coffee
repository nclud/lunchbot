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
#	lunchbot foodtruck-franklin - Returns all food trucks currently at Franklin Square.
#
# Author:
#   kyle_conrad
#


request = require('request')
cheerio = require('cheerio')


module.exports = (robot) ->

  robot.hear /foodtruck-franklin/i, (msg) ->

    vendors = []

    request 'http://foodtruckfiesta.com/dc-food-truck-list/', (error, response, html) ->
      if !error and response.statusCode == 200
        $ = cheerio.load(html)

        $('h2:contains("DC - Franklin Square")').nextUntil('h2').find('span').each ->
          vendors.push $(this).text()
          return

        format = (ary) ->
          result = "Here are the food trucks hanging out at Franklin Square today:\n"
          for index, vendor of ary
            result += "#{ vendor }\n"
          return result

        msg.send format(vendors)

