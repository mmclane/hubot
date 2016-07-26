# hubots

Old bots from OT days are in the archive folder for reference.

## Zeke
Zeke is a bot written for Hack-a-thon on 6/3/2016 to start automating things in AWS, starting with IAM administration type tasks.
JIRA Card - HAC-37.  Trying to get this into my commit so that I can check the JIRA Integration.


6/3/2016 To-Do:

- [x] Setup working PoshHubot
- [x] Setup Auth for commands
- [x] Start writing powershell scripts to do cool things
- [x] Get AWS Bot to run scripts.
- [x] Profit
   - [ ] Scripts to write:
   - [x] List users 
   - [x] Create users
   - [x] Add users to group
   - [x] Remove user from group
   - [x] List users in a group
   - [x] Delete Users
   - [x] Issue with permissions.. not going to get this to work.
   - [x] New-IAMAccessKey
   - [x] Add HL-PROD
      - [x] Create user, get AccessKeys, create profile
      - [x] test
    
Once its at least somewhat working, I need to swtich from PartyRockers Slack to Hooklogic Slack.

Setup Steps to Move to Hooklogic Slack
   - [x] Need to Rename Folder and such in Repo from AWS to Zeke
   - [ ] Get  HUBOT_SLACK_TOKEN and set in awsconfig.json
   - [ ] restart hubot
   - [ ] Temporarily change showusers.coffee to remove restricts for admin group to run command
   - [ ] reload scripts and run show users.  Get UserIDs for hubot admins.  Put those in awsconfig.json
   - [ ] reload hubot.
   - [ ] Add users to awsadmin group so they can run commands that do things.
    
    Future Enhancements:
   - [ ] The error message for create-IAMUser aren't all that descriptive.  For instance, if you try to create a user, and one already exists, if just says something went wrong.  This should have better error handling.  Same if you specify an unknown profile.
   - [ ] Can't handle more then two active keys per user
   - [ ] Commands are a bit specific.  If you don't include the "in profile" part it should prompt you to include it.
   - [ ] Getting Group members isn't working.
   - [ ] Little function that return yes or know such as, does user x exist?  Is user x in group y?  These can be used by other scripts for error checking.
    
    
    
    
    
