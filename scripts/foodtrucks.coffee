scraper = require('scraper')

module.exports = (robot) ->

	robot.hear /(dcfoodtruck|dcft)/i, (msg) ->

		options = {
			'uri': 'http://foodtruckfiesta.com/dc-food-truck-list/',
			'headers': {
				'User-Agent': 'User-Agent: Lunchbot for Hubot (+https://github.com/github/hubot-scripts)'
			}
		}

		scraper options, (err, jQuery) ->
			throw err  if err
			vendors = jQuery('div.post-content > h2').toArray()

			msg.send vendors