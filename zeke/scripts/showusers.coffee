module.exports = (robot) ->
  robot.respond /show users$/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user, 'admin')
      response = ""
      for own key, user of robot.brain.data.users
        response += "#{user.id} - #{user.name}"
        response += " <#{user.email_address}>" if user.email_address
        response += "\n"
      msg.send(response)
    else
      msg.reply "Sorry, you aren't an admin"

#Use what is below to enable for all users.  You will need this to get the first Admin setup.
#module.exports = (robot) ->
#  robot.respond /show users$/i, (msg) ->
#    response = ""
#    for own key, user of robot.brain.data.users
#      response += "#{user.id} - #{user.name}"
#      response += " <#{user.email_address}>" if user.email_address
#      response += "\n"
#    msg.send(response)