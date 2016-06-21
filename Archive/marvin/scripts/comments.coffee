# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.hear /life/i, (res) ->
     res.send "Life? Don't talk to me about life!"

  robot.hear /What do you think?/i, (res) ->
     res.send "I have a million ideas.  They all point to certain death."

  robot.hear /(Goodnight|good night)/i, (res) ->
    poem = """
    Now the world has gone to bed,
    Darkness won't engulf my head,
    I can see by infra-red,
    How I hate the night,
    Now I lay me down to sleep,
    Try to count electric sheep,
    Sweet dream wishes you can keep,
    How I hate the night.
    """
    res.send poem

  robot.hear /y so syrs/i, (res) ->
    res.send "Here I am, brain the size of a planet, and your asking me why I'm serious. Call that job satisfaction? 'Cos I don't."

  robot.hear /quoteme/i, (res) ->
    q1 = "Pardon me for breathing, which I never do anyway so I don't know why I bother to say it, Oh God, I'm so depressed."
    q2 = """
    You think you've got problems?
    What are you supposed to do if you are a manically depressed robot?
    No, don't try to answer that.
    I'm fifty thousand times more intelligent than you and even I don't know the answer.
    It gives me a headache just trying to think down to your level.
    """
    q3 = "There's only one life-form as intelligent as me within thirty parsecs of here and that's me."
    q4 = "I wish you'd just tell me rather trying to engage my enthusiasm, because I haven't got one."
    q5 = "And then of course I've got this terrible pain in all the diodes down my left side."
    q6 = "I've been communicating with the ship... It hates me."
    q7 = "I think you ought to know I'm feeling very depressed."
    q8 = "Here I am, brain the size of a planet, and they tell me to take you up to the bridge. Call that job satisfaction? 'Cos I don't."
    q9 = "Life! Don't talk to me about life"
    q10 = "Life, loathe it or ignore it, you can't like it"
    q11 = "Life's bad enough as it is without wanting to invent any more of it"
    q12 = "Funny, how just when you think life can't possibly get any worse it suddenly does"
    allQuotes = [q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12]
    res.send res.random allQuotes

  robot.hear /you saved me/, (msg) ->
    msg.send "I know. Wretched isn't it?"
