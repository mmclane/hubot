# Description:
# Create an IAM user in the requested account
#
# Commands:
# zeke create user {username} in {account}  - Creates a user in account (i.e. create user foo in hl-dev)

# Require the edge module we installed
edge = require("edge")

# Build the PowerShell that will execute
executePowerShell = edge.func('ps', -> ###
  # Dot source the function
  . .\scripts\add-awsIAMUser.ps1
  # Edge.js passes an object to PowerShell as a variable - $inputFromJS
  # This object is built in CoffeeScript on line 28 below
  create-IAMUser -Username $inputFromJS.username -ProfileName $inputFromJS.profile
###
)

module.exports = (robot) ->
  # Capture the user message using a regex capture to find the name of the service
  robot.respond /create user (.*) in (.*)/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user, 'awsadmin')
      # Set the service name to a varaible
      username = msg.match[1]
      profile = msg.match[2]

      # Build an object to send to PowerShell
      psObject = {
        username: username,
        profile: profile
      }

      # Build the PowerShell callback
      callPowerShell = (psObject, msg) ->
        msg.send "You got it chief!  I'll get that account for "+username+" created right away in "+profile
        executePowerShell psObject, (error,result) ->
          # If there are any errors that come from the CoffeeScript comma
          if error
            msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
            msg.send error
          else
            # Capture the PowerShell outpout and convert the JSON that the function returned into a CoffeeScript object
            #msg.send "Here is what I found..."
            result = JSON.parse result[0]
            if result.output is null
              msg.send "Huh, thats weird, I got no results for you."
            # Output the results into the Hubot log file so we can see what happened - useful for troubleshooting
            console.log "results:"
            console.log result.output
            
            #Convert results to a sting.
            output = ""
            #for c in result.output
            output += " - Username: " + result.output.UserName + "\n"
            output += " - UserID: " + result.output.UserId + "\n"
            output += " - Arn: " + result.output.Arn + "\n"
              
            # Check in our object if the command was a success (checks the JSON returned from PowerShell)
            # If there is a success, prepend a check mark emoji to the output from PowerShell.
            if result.success is true
              # Build a string to send back to the channel and include the output (this comes from the JSON output)
              msg.send ":white_check_mark: *Your user was created:*"
              #msg.send ":white_check_mark: #{result.output.toString()}"
              msg.send output
            # If there is a failure, prepend a warning emoji to the output from PowerShell.
            else
              # Build a string to send back to the channel and include the output (this comes from the JSON output)
              msg.send ":warning: #{result.output}"
      # Call PowerShell function
      callPowerShell psObject, msg
    else msg.reply "Sorry, are have to be an awsadmin before I will create users for you."