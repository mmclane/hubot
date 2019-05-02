# Description:
# Runs the add-userToGroup script to add a user to an email distro group.
#
# Commands:
# marvin add <username> to <distroGroup> - Adds user to group in either AD or O365.

# Require the edge module we installed
edge = require("edge")

# Build the PowerShell that will execute
executePowerShell = edge.func('ps', -> ###
  # Dot source the function
  . .\scripts\add-userToGroup.ps1
  # Edge.js passes an object to PowerShell as a variable - $inputFromJS
  # This object is built in CoffeeScript on line 28 below
  Add-UserToGroup -user $inputFromJS.user -groupName $inputFromJS.groupName
###
)

module.exports = (robot) ->
  # Capture the user message using a regex capture to find the name of the service
  robot.respond /add (.*) to (.*)/i, (msg) ->
    # Set the service name to a varaible
    user = msg.match[1]
    groupName = msg.match[2]

    # Build an object to send to PowerShell
    psObject ={user: user, groupName: groupName}

    # Build the PowerShell callback
    callPowerShell = (psObject, msg) ->
      msg.send "Ok, I'll add "+user+" to "+groupName+" for you."
      msg.send "This takes a min... "
      executePowerShell psObject, (error,result) ->
        # If there are any errors that come from the CoffeeScript comma
        if error
          msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
          msg.send error
        else
          # Capture the PowerShell outpout and convert the JSON that the function returned into a CoffeeScript object
          result = JSON.parse result[0]

          # Check in our object if the command was a success (checks the JSON returned from PowerShell)
          # If there is a success, prepend a check mark emoji to the output from PowerShell.
          if result.success is true
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":white_check_mark: *Done*"
            #msg.send ":white_check_mark: #{result.output}"
            msg.send result.output
          # If there is a failure, prepend a warning emoji to the output from PowerShell.
          else
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":warning: #{result.output.name}"
    # Call PowerShell function
    callPowerShell psObject, msg
