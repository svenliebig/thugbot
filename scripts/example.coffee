# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"

  robot.hear /I like pie/i, (res) ->
    res.emote "makes a freshly baked pie"

  lulz = ['lol', 'rofl', 'lmao']

  robot.respond /lulz/i, (res) ->
    res.send res.random lulz

  robot.topic (res) ->
    res.send "#{res.message.text}? That's a Paddlin'"

  enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  leaveReplies = ['Are you still there?', 'Target lost', 'Searching']

  robot.enter (res) ->
    res.send res.random enterReplies
  robot.leave (res) ->
    res.send res.random leaveReplies

  answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING

  robot.respond /what is the answer to the ultimate question of life/, (res) ->
    unless answer?
      res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
      return
    res.send "#{answer}, but what is the question?"

  robot.respond /you are a little slow/, (res) ->
    setTimeout () ->
      res.send "Who you calling 'slow'?"
    , 60 * 1000

  annoyIntervalId = null

  robot.respond /annoy me/, (res) ->
    if annoyIntervalId
      res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
      return

    res.send "Hey, want to hear the most annoying sound in the world?"
    annoyIntervalId = setInterval () ->
      res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
    , 1000

  robot.respond /unannoy me/, (res) ->
    if annoyIntervalId
      res.send "GUYS, GUYS, GUYS!"
      clearInterval(annoyIntervalId)
      annoyIntervalId = null
    else
      res.send "Not annoying you right now, am I?"


  robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
    room   = req.params.room
    data   = JSON.parse req.body.payload
    secret = data.secret

    robot.messageRoom room, "I have a secret: #{secret}"

    res.send 'OK'

    robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

  robot.respond /have a soda/i, (res) ->
    sodasHad = robot.brain.get('totalSodas') * 1 or 0
    if sodasHad > 4
      res.reply "I'm too fizzy.."
    else
      res.reply 'Sure!'
      robot.brain.set 'totalSodas', sodasHad+1

  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalSodas', 0
    res.reply 'zzzzz'

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
  winows 				= /windows/i
  einzigste 		= /einzigste/i
  lebenshit 		= /(leben)(.)+(scheiße)/i
  operation 		= /(^|\s)(\d+\.?\d*)(\s)*(\+|\-|\/|\*)(\s)*(\d+\.?\d*)($|\s)/i
  newsarten			= /^(sport|league|it)$/i
  newsToken     = false
  newsUser      = "";

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

  ###
    @title 	Custom Respond Scripts
    @author Sven Liebig
    @author Cedric Laier
    @page 	https://github.com/Sly321
  ###

  # # # # # # # # # # # # # # # # # # # # # #
  # Regexbefehle für die Hear Section     # #
  # # # # # # # # # # # # # # # # # # # # # #
  yousuck      = /you suck/i
  countspells  = /(spells spoken)|(how many spells)/i
  justwhy      = /why (.*)/i
  youstupid    = /you (silly|stupid|facking|fucking|grumpy|fat) (.*)/i
  bitch        = /bitch/i
  hoe          = /hoe/i
  suckdicks    = /suck dicks/i
  wherearewe   = /(where are we)|(room)/i
  thanks       = /(thx)|(danke)|(thanks)|(dank dir)|(thank you)/i
  thankscount  = /how many thx/i
  uptime       = /(uptime)|(onlinetime)|(how long are you online)|(onlinezeit)|(wielange bist du online)/i
  pr0gramm     = /(pr0)|(pr0gramm)|(würde)|(fliesentisch)/i
  news         = /(news|nachrichten|meldungen)(\s)?(\w*)/i

  robot.respond yousuck, (res) ->
    res.send ".. no you suck."

  robot.respond countspells, (res) ->
    spellsSpoken = robot.brain.get('spellsSpoken') * 1 or 0
    res.send "I spoke #{spellsSpoken} spells you mudblood."

  robot.respond justwhy, (res) ->
    what = res.match[1]
    res.reply "WHY '#{what}'-WHAT?! WANT TO MESS UP WITH ME?"

  robot.respond youstupid, (res) ->
    what = res.match[1]
    res.reply "y, touch yourself, double #{what}."

  robot.respond bitch, (res) ->
    res.reply "hoe!"

  robot.respond hoe, (res) ->
    res.reply "bitch!"

  robot.respond suckdicks, (res) ->
    res.reply "Grown up boy. Didn't mommy love you enough? Or did daddy love you too much?"

  robot.respond wherearewe, (res) ->
    room = res.message.room
    res.reply "We are in the room: " + room

  robot.respond thanks, (res) ->
    totalthx = robot.brain.get('totalthx') * 1 or 0
    robot.brain.set 'totalthx', totalthx+1
    res.reply "Your welcome."

  robot.respond thankscount, (res) ->
    totalthx = robot.brain.get('totalthx') * 1 or 0
    res.reply "I thanked the humans #{totalthx} times, and i'm kinda tired of this."

  robot.respond uptime, (res) ->
    totaltime = robot.brain.get('totaltime') * 1 or 0
    if totaltime < 60
      res.reply "I'm on for #{totaltime} seconds."
    else if totaltime < 3600
      seconds = Math.floor(totaltime % 60)
      minutes = Math.floor(totaltime / 60)
      res.reply "I'm on for #{minutes} minutes and #{seconds} seconds."
    else
      hours = Math.floor(totaltime / 3600)
      minutes = Math.floor((totaltime % 3600) / 60)
      seconds = Math.floor((totaltime % 60))
      res.reply "I'm on for #{hours} hours, #{minutes} minutes and #{seconds} seconds."

  robot.respond pr0gramm, (res) ->
    max = 107400
    min = 1
    pr0 = Math.floor(Math.random() * (max - min) + min)
    res.reply "Darf es ein bisschen Pr0 sein?\n Nimm das: http://www.pr0gramm.com/new/#{pr0} :)"

  robot.respond news, (res) ->
    if newsToken
      console.error("ERROR: Newstoken bereits vergeben, Timeout von 30 sekunden läuft noch.");
      return
    what = res.match[3];
    console.log("2nd #{what}");
    switch what
      when "sport"
        res.reply "hier nachrichten für sport einfügen"
        newsToken = false
      when "league"
        res.reply "hier nachrichten für league einfügen"
        newsToken = false
      when "it"
        res.reply "hier nachrichten für it einfügen"
        newsToken = false
      else
        newsUser = res.message.user.name
        res.reply "Welche Nachrichten #{newsUser}?"
        newsToken = true
        setTimeout () ->
          newsUser = ""
          newsToken = false
        , 30000

# # TOTAL TIME COUNTER - by Sven Liebig https://github.com/Sly321 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  timecalc = setInterval () ->
    totaltime = robot.brain.get('totaltime') * 1 or 0
    robot.brain.set 'totaltime', totaltime+1
  , 1000

 # # CALCULATOR AND CONVERTER POWERED BY MATHJS - by Cedric Laier github.com/FICKDICHISTMIREGAL # # # # # # # # #

  mathjs = require("mathjs")

  robot.respond /(rechne|berechne|calculate|convert|konvertiere|mathe|math|machmirdenstreber)( me)? (.*)/i, (msg) ->
    try
      result = mathjs.eval msg.match[3]
      msg.send "#{result}"
    catch error
      msg.send error.message || 'Bischt du dumm oder was?'

  robot.respond /(nachhilfe)|(mathehilfe)|(mathhelp)/i, (msg) ->
    res.reply "Hier sind meine Funktionen!\n\nWurzel:  sqrt(x)\n Faktor:  pow(x, y)\n Logarithmus:  log(x,y)\n\nWird erweitert, habe gerade keinen Bock weiter zu machen."

  sieg = [
    "http://thejointblog.com/wp-content/uploads/2013/04/victory.jpg",
    "http://www.quickmeme.com/img/ea/ea4671998341d9fbb6f7815394b49cb2890a50ac80b62802fb021c147c068d8e.jpg",
    "http://cdn-media.hollywood.com/images/l/victory_620_080712.jpg",
    "http://cf.chucklesnetwork.agj.co/items/5/5/9/6/0/one-does-not-simply-declare-victory-but-i-just-did.jpg",
    "http://t.qkme.me/3qlspk.jpg",
    "http://img.pandawhale.com/86036-victory-dance-gif-Despicable-M-EPnS.gif",
    "http://1.bp.blogspot.com/-rmJLwpPevTg/UOEBgVNiVFI/AAAAAAAAFFY/-At3Z_DzBbw/s1600/dancing+charlie+murphy+animated+gif+victory+dance.gif",
    "http://www.gifbin.com/bin/20048442yu.gif",
    "http://www.quickmeme.com/img/30/300ace809c3c2dca48f2f55ca39cbab24693a9bd470867d2eb4e869c645acd42.jpg",
    "http://jeffatom.files.wordpress.com/2013/09/winston-churchill-says-we-deserve-victory.jpg",
    "http://i.imgur.com/lmmBt.gif",
    "http://danceswithfat.files.wordpress.com/2011/08/victory.jpg",
    "http://stuffpoint.com/family-guy/image/56246-family-guy-victory-is-his.gif",
    "http://thelavisshow.files.wordpress.com/2012/06/victorya.jpg",
    "http://alookintomymind.files.wordpress.com/2012/05/victory.jpg",
    "http://rack.3.mshcdn.com/media/ZgkyMDEzLzA4LzA1L2QwL2JyYWRwaXR0LmJjMmQyLmdpZgpwCXRodW1iCTg1MHg1OTA-CmUJanBn/1a5a0c57/968/brad-pitt.jpg",
    "http://rack.0.mshcdn.com/media/ZgkyMDEzLzA4LzA1L2ViL2hpZ2hzY2hvb2xtLjI4YjJhLmdpZgpwCXRodW1iCTg1MHg1OTA-CmUJanBn/4755556e/b82/high-school-musical-victory.jpg",
    "http://rack.2.mshcdn.com/media/ZgkyMDEzLzA4LzA1L2ZkL25hcG9sZW9uZHluLjBiMTFlLmdpZgpwCXRodW1iCTg1MHg1OTA-CmUJanBn/8767246f/d7a/napoleon-dynamite.jpg",
    "http://rack.0.mshcdn.com/media/ZgkyMDEzLzA4LzA1L2RiL3RvbWZlbGRvbi41NmRjNi5naWYKcAl0aHVtYgk4NTB4NTkwPgplCWpwZw/05cd12cc/645/tom-feldon.jpg",
    "http://rack.3.mshcdn.com/media/ZgkyMDEzLzA4LzA1L2JmL2hpbXltLjU4YTEyLmdpZgpwCXRodW1iCTg1MHg1OTA-CmUJanBn/90a990f6/b38/himym.jpg",
    "http://rack.3.mshcdn.com/media/ZgkyMDEzLzA4LzA1L2U1L2NvbGJlcnRyZXBvLjVjNmYxLmdpZgpwCXRodW1iCTg1MHg1OTA-CmUJanBn/710824a0/764/colbert-report.jpg",
    "http://rack.1.mshcdn.com/media/ZgkyMDEzLzA4LzA1LzYyL2FuY2hvcm1hbi42NjJkYS5naWYKcAl0aHVtYgk4NTB4NTkwPgplCWpwZw/009ee80f/1c0/anchorman.jpg",
    "http://rack.3.mshcdn.com/media/ZgkyMDEzLzA4LzA1LzFmL2hhcnJ5cG90dGVyLjYxNjYzLmdpZgpwCXRodW1iCTg1MHg1OTA-CmUJanBn/db79fc85/147/harry-potter.jpg",
    "http://www.velocityindiana.org/wp-content/uploads/2014/08/bff.gif",
    "http://i.kinja-img.com/gawker-media/image/upload/s--_dYUH9jW--/18vvnw5taib2ogif.gif",
    "https://31.media.tumblr.com/e844e0925dbd8699ddb68fb2408d61b6/tumblr_mqrjr2oH0G1r3kc9vo1_250.gif",
    "http://i.kinja-img.com/gawker-media/image/upload/s--0wAEcaN4--/c_fit,fl_progressive,q_80,w_636/bdbtzjrhyyuarpfbqksn.gif",
    "http://media.giphy.com/media/vpybhig8QFLOM/giphy.gif",
    "https://media.giphy.com/media/3o85xzwOcKkOw67ywg/giphy.gif",
    "https://ladygeekgirl.files.wordpress.com/2012/01/1352309-huzzah1_super1.jpg"
  ]


  robot.hear /sieg\b/i, (msg) ->
    msg.send msg.random sieg
