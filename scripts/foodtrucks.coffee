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
#
# Author:
#   kyle_conrad

scraper = require('scraper')

module.exports = (robot) ->

	robot.hear /foodtruck/i, (msg) ->

		options = {
			'uri': 'http://foodtruckfiesta.com/dc-food-truck-list/'
		}

		scraper options, (err, jQuery) ->
			throw err  if err
			vendors = jQuery('div.post-content > h2').toArray()

			msg.send vendors