$gioodapps = "communicationsapps|weather|maps|sketch|calculator|stickynotes|alarms|paint|store|edge|photos|extension|vclibs|runtime|winget|desktopappinstaller" #Sets a variable thats used for excluding to-be removed apps

get-appxprovisionedpackage -online |where {$_.displayname -notmatch $goodapps } |select displayname #Just shows you what is going to be removed
get-appxprovisionedpackage -online |where {$_.displayname -notmatch $goodapps } | remove-appxprovisionedpackage -online #This does the actual removal from the output of the above command 

get-appxpackage -allusers |where {$_.name -notmatch $goodapps } |select name #Just shows you what is going to be removed
get-appxpackage -allusers |where {$_.name -notmatch $goodapps } | remove-appxpackage #This does the actual removal from the output of the above command. NOTE, the comment is the same, but the command is not
