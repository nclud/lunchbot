# Description:
#   DC Food Trucks
#
# Commands:
#   hubot dcfoodtruck me <query> - Searches for trucks matching query, can be blank, state abbrev (dc, md, va), location (farragut square) or food item. Can use 'dcft' for short.
#
# Dependencies:
#   "zombie": "2.x"
#   "moment": "1.7.x"
#
# Configuration:
#   None
#

Browser = require('zombie')
moment = require('moment')

module.exports = (robot) ->
  robot.respond /(dcfoodtruck|dcft)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    msg.http("http://foodtruckfiesta.com/dc-food-truck-list/")
      .get() (err, res, body) ->
        states = {}
        locations = {}
        vendors = []
        browser = new Browser({ loadCSS: false, runScripts: false })
        browser.load body, (htmlError) ->
          return msg.send 'Error' if (htmlError)
          state = location = skip = vendor = tweet = published = false
          count = 0
          for index, node of browser.queryAll('div.post-content > h2, div.post-content > div, div.post-content > div > b')
            content = browser.text('', node).trim()
            skip = true if content.match /unrecognized locations/i
            continue if skip
            if node._nodeName == 'h2'
              state = content.split(' - ')[0].toUpperCase();
              location = content.split(' - ')[1]
              count = 0
              continue
            count++
            if 1%count == 0
              vendor = content
            else if 2%count == 0
              tweet = content
            else if 3%count == 0
              states[state] ||= []
              locations[location.toLowerCase()] ||= []
              published = moment(content).from(moment())
              payload = "#{ location }, #{ state } - #{ vendor } said #{ tweet } #{ published }"
              states[state].push payload
              locations[location.toLowerCase()].push payload
              vendors.push payload
              count = 0

          if Object.keys(states).length == 0
            return msg.send 'No food truck data found'

          query = query.replace /\s?me/, ''

          format = (ary) ->
            result = "Here's what I found for you:\n"
            for index, vendor of ary
              result += "#{ vendor }\n"
            return result

          return msg.send format(vendors) if !query || query.length == 0

          if query.match(/^(va|dc|md)$/i)
            return msg.send format states[query.toUpperCase()] if states[query.toUpperCase()]
            return msg.send "No trucks found in #{ query }"

          return msg.send format locations[query.toLowerCase()] if locations[query.toLowerCase()]
          
          found = []
          for index, vendor of vendors
            found.push(vendor) if !!vendor.match(new RegExp(query, 'i'))
          return msg.send format found if found.length > 0          

          msg.send "No trucks found matching the query '#{ query }'"
