# Description:
# Gets the status of a service on the Hubot server
#
# Commands:
# marvin get members for|of <group name> - Gets a list of Distro group members from O365.

# Require the edge module we installed
edge = require("edge")

# Build the PowerShell that will execute
executePowerShell = edge.func('ps', -> ###
  # Dot source the function
  . .\scripts\get-groupmembershubot.ps1
  # Edge.js passes an object to PowerShell as a variable - $inputFromJS
  # This object is built in CoffeeScript on line 28 below
  Get-GroupMembers -group $inputFromJS.groupName
###
)

module.exports = (robot) ->
  # Capture the user message using a regex capture to find the name of the service
  robot.respond /get members (for|of) (.*)/i, (msg) ->
    # Set the service name to a varaible
    groupName = msg.match[2]

    # Build an object to send to PowerShell
    psObject = {
      groupName: groupName
    }

    # Build the PowerShell callback
    callPowerShell = (psObject, msg) ->
      msg.send "I'll get the members of "+groupName + " for you"
      msg.send "This takes a sec... "
      executePowerShell psObject, (error,result) ->
        # If there are any errors that come from the CoffeeScript comma
        if error
          msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
          msg.send error
        else
          # Capture the PowerShell outpout and convert the JSON that the function returned into a CoffeeScript object
          result = JSON.parse result[0]
          if result.output is null
            msg.send "No such group."
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
            msg.send ":white_check_mark: *I found that " + groupName + " has the following members:*"
            #msg.send ":white_check_mark: #{result.output}"
            msg.send output
          # If there is a failure, prepend a warning emoji to the output from PowerShell.
          else
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":warning: #{result.output.name}"
    # Call PowerShell function
    callPowerShell psObject, msg
