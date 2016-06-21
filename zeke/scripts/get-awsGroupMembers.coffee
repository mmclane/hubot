# Description:
# Gets the members of an IAM Group
#
# Commands:
# zeke get members of {groupName} in {account}  - Returns a list of users in the {groupName} group in {account}

# Require the edge module we installed
edge = require("edge")

# Build the PowerShell that will execute
executePowerShell = edge.func('ps', -> ###
  # Dot source the function
  . .\scripts\get-IAMGroupMembers.ps1
  # Edge.js passes an object to PowerShell as a variable - $inputFromJS
  # This object is built in CoffeeScript on line 28 below
  get-awsIAMGroupMembers -GroupName $inputFromJS.groupname -ProfileName $inputFromJS.profile
###
)

module.exports = (robot) ->
  # Capture the user message using a regex capture to find the name of the service
  robot.respond /get members of (.*) in (.*)/i, (msg) ->
    # Set the service name to a varaible
    groupname = msg.match[1]
    profile = msg.match[2]

    # Build an object to send to PowerShell
    msg.send "Okeydoke, I'll go get a list of users in the "+groupname+" group in "+profile
    #msg.send "Justa  sec.."
    
    psObject = {
      profile: profile,
      groupname: groupname
    }

    # Build the PowerShell callback
    callPowerShell = (psObject, msg) ->
      #msg.send "Sure thing bossman.  I'll go get a list of users for you."
      msg.send "This might take a sec..."
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
            msg.send "Huh, thats weird, no users found."
          # Output the results into the Hubot log file so we can see what happened - useful for troubleshooting
          console.log "results:"
          console.log result.output
          #Convert results to a sting.
          output = ""
          for c in result.output
            output += " *-* " + c.UserName + "\n"

          # Check in our object if the command was a success (checks the JSON returned from PowerShell)
          # If there is a success, prepend a check mark emoji to the output from PowerShell.
          if result.success is true
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":white_check_mark: I found that the following users in *HL-DEV*:"
            #msg.send ":white_check_mark: #{result.output}"
            msg.send output
          # If there is a failure, prepend a warning emoji to the output from PowerShell.
          else
            # Build a string to send back to the channel and include the output (this comes from the JSON output)
            msg.send ":warning: #{result.output.Username}"
    # Call PowerShell function
    callPowerShell psObject, msg

      
