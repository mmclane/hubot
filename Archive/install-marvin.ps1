# Import the module
Import-Module -Name PoshHubot -Force

# Create hash of configuration options
$newBot = @{
    Path = "C:\Hubot\config.json"
    BotName = 'marvin'
    BotPath = 'C:\hubot\marvin'
    BotAdapter = 'slack'
    BotOwner = 'Matt McLAne <mmclane@onlinetech.com>'
    BotDescription = 'Awesome POSHHUBOT'
    LogPath = 'C:\Hubot\Logs'
    BotDebugLog = $true
}

# Splat the hash to the CmdLet
New-PoshHubotConfiguration @newBot

Install-HuBot -ConfigPath 'C:\hubot\config.json'

Remove-HubotScript -Name 'hubot-redis-brain' -ConfigPath 'C:\Hubot\config.json'
Remove-HubotScript -Name 'hubot-heroku-keepalive' -ConfigPath 'C:\Hubot\config.json'

# Authentication Script, allowing you to give permissions for users to run certain scripts
Install-HubotScript -Name 'hubot-auth' -ConfigPath 'C:\Hubot\config.json'
# Allows reloading Hubot scripts without having to restart Hubot
Install-HubotScript -Name 'hubot-reload-scripts' -ConfigPath 'C:\Hubot\config.json'
# Stores the Hubot brain as a file on disk
Install-HuBotScript -Name 'jobot-brain-file' -ConfigPath 'C:\Hubot\config.json'