# Description:
#   Here script.
#
# Notes:
#   Notes here
#   
###
@title 	Custom Hear Scripts
@author Sven Liebig
@page 	https://github.com/Sly321
###

# # # # # # # # # # # # # # # # # # # # # #
# Regexbefehle für die Hear Section     # #
# # # # # # # # # # # # # # # # # # # # # #
avadakedabra 	= /avada kedabra/i
thuglife 			= /thug life/i
expiliarmus 	= /expiliarmus/i
dislike 			= /dislike/i
windows				= /windows/i
einzigste 		= /einzigste/i
lebenshit 		= /(leben)(.)+(scheiße)/i
operation 		= /(^|\s)(\d+\.?\d*)(\s)*(\+|\-|\/|\*)(\s)*(\d+\.?\d*)($|\s)/i
newsarten			= /^(sport|league|it)$/i
byerobot      = /(bye|later|gute nacht|tschüss|tschüß|schlaf gut|bis später|hau rein|cucu|cu),?\s(.*)/i
newsToken     = false
newsUser      = "";
goodbyes = [
  "Bye, {name}.",
  "Hauste, {name}.",
  "Tschüss, {name}.",
  "Bis dann, {name}.",
  "Gehabt euch wohl, {name}."
]

goodbye = (name) ->
  index = parseInt(Math.random() * goodbyes.length)
  message = goodbyes[index]
  message.replace(/{name}/, name);

module.exports = (robot) ->
  robot.hear avadakedabra, (res) ->
    res.send "EXPILIARMUS! :nerd_face:"
    spellsSpoken = robot.brain.get('spellsSpoken') * 1 or 0
    robot.brain.set 'spellsSpoken', spellsSpoken+1

  robot.hear thuglife, (res) ->
    res.send "Dementors suck life, you suck dicks. :fire:"

  robot.hear expiliarmus, (res) ->
    res.send "AVADA KEDABRA! :skull_and_crossbones:"

  robot.hear dislike, (msg) ->
    msg.send "http://imgick.nola.com/home/nola-media/width620/img/pets_impact/photo/grumpy-catjpg-3ca3ff6a7951c9d2.jpg"

  robot.hear windows, (msg) ->
    msg.send "*windumb"

  robot.hear einzigste, (msg) ->
    msg.send "*einzige"

  robot.hear lebenshit, (msg) ->
    msg.send "Man reiche dem Herr'n die :gun:"

  robot.hear operation, (msg) ->
    zahl1 = msg.match[2]
    operant = msg.match[4]
    zahl2 = msg.match[6]
    msg.send "Berechne #{zahl1} #{operant} #{zahl2} ="
    result = mathjs.eval zahl1+operant+zahl2
    msg.send "#{result}"

  robot.hear newsarten, (msg) ->
    art = undefined
    if newsToken and msg.message.user.name == newsUser
      art = msg.match[1]
      switch art
        when 'sport'
          msg.send 'hier nachrichten sport einfügen'
          return newsToken = false
        when 'league'
          msg.send 'hier nachrichten Leauge einfügen'
          return newsToken = false
        when 'it'
          msg.send 'hier nachrichten IT einfügen'
          return newsToken = false
        else
          msg.send 'Keine Nachrichten zu diesem Thema gefunden.'
          return newsToken = false
    else if msg.message.user.name != newsUser
      console.log("ERROR: #{msg.message.user.name} ist nicht berechtigt die news von #{newsUser} anzusehen.")
    else
      console.log("ERROR: Kein Token vergeben beim abgreifen von News. (User #{msg.message.user.name}");
      return newsToken = false
    return
  
  robot.hear /(bye|later|gute nacht|tschüss|tschüß|schlaf gut|bis später|hau rein|cucu|cu),?\s(.*)/i, (msg) ->
    if robot.name.toLowerCase() == msg.match[2].toLowerCase()
      byeMessage = goodbye(msg.message.user.name)
      msg.send(byeMessage)

  robot.logger.info "Loaded script hear.coffee"