# Description:
#   Here script.
#
# Notes:
#   Notes here
#   
###
@title 	Storage Scripts
@author Sven Liebig
@page 	https://github.com/Sly321
###

users 	= [];
chatlog = [];


module.exports = (robot) ->

	###*
	* Returns the user, and false if he does'nt exist or the array is empty.
	* @param {name} name of the user to search for
	* @return {user} user or false
	 ###
	UserExist = (name) ->
		x = 0
		if users.length != 0
			while x < users.length
				user = users[x]
				robot.logger.info "X #{x} username #{user['user']}."
				robot.logger.info "Searching for #{name}."
				if user["user"] == name
					robot.logger.info "User #{name} exists in users array."
					return user
				x++
			robot.logger.error "User #{name} not found in users array."
			return false
		else
			robot.logger.error "Users array is empty."
			return false

	AddUser = (name) ->
		if !UserExist(name)
			users.push({"user": name})
			robot.logger.info "Added #{name} to users array."
		else
			robot.logger.error "User #{name} already exist in users array."

	IncrementHurensohn = (name) ->
		if user = UserExist(name)
			if user["hurensohnlevel"] == undefined
				user["hurensohnlevel"] = 1
				robot.logger.info "Added attribute hsl to #{name} and set 1."
			else
				user["hurensohnlevel"] += 1
				robot.logger.info "Increment attribute hsl to #{name} by 1."
		else
			AddUser(name)
			IncrementHurensohn(name)

	GetHurensohnlevel = (name) ->
		if user = UserExist(name)
			return user["hurensohnlevel"]
		else
			return false

	IncrementNachrichten = (name) ->
		if user = UserExist(name)
			if user["nachrichten"] == undefined
				user["nachrichten"] = 1
				robot.logger.info "Added attribute msg\'s to #{name} and set 1."
			else
				user["nachrichten"] += 1
				robot.logger.info "Increment attribute msg\'s to #{name} by 1."
		else
			AddUser(name)
			IncrementNachrichten(name)

	GetNachrichten = (name) ->
		if user = UserExist(name)
			return user["nachrichten"]
		else
			return false

	robot.hear /((.|\n)*)/i, (msg) ->
		name = msg.message.user.name
		log = msg.match[1]
		room = msg.message.room
		chatlog.push({"user": name, "msg": log, "room": room})
		IncrementNachrichten(name)

	robot.hear /user (.*) exist/i, (msg) ->
		name = msg.match[1];
		if user = UserExist(name)
			msg.send "Yes #{name} exists in users array."
		else
			msg.send "No #{name} does'nt exist in users array."

	robot.hear /add user (.*)/i, (msg) ->
		name = msg.match[1]
		if user = UserExist(name)
			msg.send "Yes #{name} exists in users array."
		else
			AddUser(name)
			msg.send "Added #{name}."

	robot.hear /(arsch|arschloch|penner|wichser|hrnshn|hurensohn|spast|spaßt|fotze|votze|schlampe|hure|nutte|dummer|esel|deine mutter|dei mudda|deine mudda|knecht|sieg)/i, (msg) ->
		name = msg.message.user.name
		IncrementHurensohn(name)

	robot.hear /get (hsl|hsn|hrnshn) from (.*)/i, (msg) ->
		name = msg.match[1]
		if hsl = GetHurensohnlevel(name)
			msg.send "#{name}\'s Hurensohnlevel ist #{hsl}. Krasser Typ."
		else
			msg.send "Nichtmal in meiner Datenbank #{name} der Hurensohn."

	robot.hear /get msg count from (.*)/i, (msg) ->
		name = msg.match[1]
		if msgs = GetNachrichten(name)
			msg.send "#{name} hat #{msgs} nachrichten geschrieben."
		else
			msg.send "#{name} hat keine nachrichten geschrieben."

	robot.hear /bot give chatlog/i, (msg) ->
		x = 0
		log = null
		zusammengesetzt = ""
		while x < chatlog.length
			log = chatlog[x]
			zusammengesetzt += "#{log['user']} in \##{log['room']}: #{log['msg']}\n"
			x++
		msg.send zusammengesetzt;

	robot.logger.info "Loaded script storage.coffee"