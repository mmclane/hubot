# Import the module
Import-Module -Name PoshHubot -Force

$config = "C:\Hubot\o365config.json"

# Create hash of configuration options
$newBot = @{
    Path = "C:\Hubot\o365config.json"
    BotName = 'o365'
    BotPath = 'C:\hubot\o365'
    BotAdapter = 'slack'
    BotOwner = 'Matt McLAne <mmclane@onlinetech.com>'
    BotDescription = 'Bot to connect Slack with o365'
    LogPath = 'C:\Hubot\Logs'
    BotDebugLog = $true
}

# Splat the hash to the CmdLet
New-PoshHubotConfiguration @newBot

Install-HuBot -ConfigPath $config

Remove-HubotScript -Name 'hubot-redis-brain' -ConfigPath $config
Remove-HubotScript -Name 'hubot-heroku-keepalive' -ConfigPath $config

# Authentication Script, allowing you to give permissions for users to run certain scripts
Install-HubotScript -Name 'hubot-auth' -ConfigPath $config
# Allows reloading Hubot scripts without having to restart Hubot
Install-HubotScript -Name 'hubot-reload-scripts' -ConfigPath $config
# Stores the Hubot brain as a file on disk
Install-HuBotScript -Name 'jobot-brain-file' -ConfigPath $config