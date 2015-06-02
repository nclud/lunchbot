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