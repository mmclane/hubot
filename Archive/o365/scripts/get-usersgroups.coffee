# Description:
# Gets all the groups a user is a member of from )365
#
# Commands:
# marvin get groups for|of <emailaddress> - Gets a list of Distro groups that the email address is in.

# Require the edge module we installed
edge = require("edge")

# Build the PowerShell that will execute
executePowerShell = edge.func('ps', -> ###
  # Dot source the function
  . .\scripts\get-usersgroupshubot.ps1
  # Edge.js passes an object to PowerShell as a variable - $inputFromJS
  # This object is built in CoffeeScript on line 28 below
  Get-UsersGroups -user $inputFromJS.emailaddress
###
)

module.exports = (robot) ->
  # Capture the user message using a regex capture to find the name of the service
  robot.respond /get groups (for|of) (.*)/i, (msg) ->
    # Set the service name to a varaible
    emailaddress = msg.match[2]

    # Build an object to send to PowerShell
    psObject = {
      emailaddress: emailaddress
    }

    # Build the PowerShell callback
    callPowerShell = (psObject, msg) ->
      msg.send "I'll look in ALL the groups in 0365 and tell you which groups " + emailaddress + " is a member of."
      msg.send "cuz I had nothing better to do ... "
      #msg.send "Hang on, this takes a few... "
      executePowerShell psObject, (error,result) ->
        # If there are any errors that come from the CoffeeScript comma
        if error
          msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
          msg.send error
        else
          # Capture the PowerShell outpout and convert the JSON that the function returned into a CoffeeScript object
          result = JSON.parse result[0]
          if result.output is null
            msg.send "No groups."
          # Output the results into the Hubot log file so we can see what happened - useful for troubleshooting
          console.log "Found:"
          console.log result.output
          #Convert results to a sting.
          output = ""
          for c in result.output
            output += " *-* " + c + "\n"

          # Check in our object if the command was a success (checks the JSON returned from PowerShell)
          # If there is a success, prepend a check mark emoji to the output from PowerShell.
          if result.success is true
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":white_check_mark: *I found that " + emailaddress + " is a member of the following groups:*"
            #msg.send ":white_check_mark: #{result.output}"
            msg.send output
          # If there is a failure, prepend a warning emoji to the output from PowerShell.
          else
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":warning: #{result.output.name}"
    # Call PowerShell function
    callPowerShell psObject, msg
