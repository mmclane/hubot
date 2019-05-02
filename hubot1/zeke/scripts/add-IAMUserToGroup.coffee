# Description:
# Adds an IAM user to an IAM Group in the requested account
#
# Commands:
# zeke add IAM user {username} to {groupname} in {account}  - i.e. add mmclane to SuperHeros in hl-dev.

# Require the edge module we installed
edge = require("edge")

# Build the PowerShell that will execute
executePowerShell = edge.func('ps', -> ###
  # Dot source the function
  . .\scripts\add-awsIAMUserToGroup.ps1
  # Edge.js passes an object to PowerShell as a variable - $inputFromJS
  # This object is built in CoffeeScript on line 28 below
  Add-awsIAMUserToGroup -Username $inputFromJS.username -GroupName $inputFromJS.groupname -ProfileName $inputFromJS.profile
###
)

module.exports = (robot) ->
  # Capture the user message using a regex capture to find the name of the service
  robot.respond /add IAM user (.*) to (.*) in (.*)/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user, 'awsadmin')
      # Set the service name to a varaible
      username = msg.match[1]
      groupname = msg.match[2]
      profile = msg.match[3]

      # Build an object to send to PowerShell
      psObject = {
        username: username,
        groupname: groupname,
        profile: profile
      }

      # Build the PowerShell callback
      callPowerShell = (psObject, msg) ->
        msg.send "No problem.  I'll add "+username+" to the "+groupname+" group in "+profile+"."
        executePowerShell psObject, (error,result) ->
          # If there are any errors that come from the CoffeeScript comma
          if error
            msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
            msg.send error
          else
            # Capture the PowerShell outpout and convert the JSON that the function returned into a CoffeeScript object
            result = JSON.parse result[0]
            if result.output is null
              msg.send "Huh, thats weird, I got no results for you."
            # Output the results into the Hubot log file so we can see what happened - useful for troubleshooting
            console.log "results:"
            console.log result.output
            
            #Convert results to a sting.
            #output = ""
            #for c in result.output
            #output += "\n - Username: " + result.output.UserName + "\n"
            #output += " - AccessKeyId: " + result.output.AccessKeyId + "\n"
            #output += " - SecretAccessKey: " + result.output.SecretAccessKey + "\n"
            #output += " - Status: " + result.output.Status + "\n"
              
            # Check in our object if the command was a success (checks the JSON returned from PowerShell)
            # If there is a success, prepend a check mark emoji to the output from PowerShell.
            if result.success is true
              # Build a string to send back to the channel and include the output (this comes from the JSON output)
              # msg.reply ":white_check_mark: *Here is the new key information:*"
              msg.send ":white_check_mark: #{result.output}"
              #msg.reply output
            # If there is a failure, prepend a warning emoji to the output from PowerShell.
            else
              # Build a string to send back to the channel and include the output (this comes from the JSON output)
              msg.send ":warning: #{result.output}"
      # Call PowerShell function
      callPowerShell psObject, msg
    else msg.reply "Sorry, are have to be an awsadmin before I will make changes for you."