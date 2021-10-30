Start by going to whatsmyname.app and looking up the username.
![screenshot1](https://github.com/lucasballr/OSUSEC/blob/Main/target_practice/sc1.png)

This finds a twitter account: [https://twitter.com/anonhunter26](https://twitter.com/anonhunter26 "https://twitter.com/anonhunter26")

At this twitter account, there's another user mentioned: @hatebav2ropc
![screenshot2](https://github.com/lucasballr/OSUSEC/blob/Main/target_practice/sc2.png)
Putting that username into the program gives a github link: [https://github.com/hatebav2ropc/useful-osint-links](https://github.com/hatebav2ropc/useful-osint-links "https://github.com/hatebav2ropc/useful-osint-links")
Plug the username into this link and you find the associated email: https://api.github.com/users/hatebav2ropc/events/public
![screenshot3](https://github.com/lucasballr/OSUSEC/blob/Main/target_practice/sc3.png)
Plug the email into https://tools.epieos.com/email.php and you get this: 
![screenshot4](https://github.com/lucasballr/OSUSEC/blob/Main/target_practice/sc4.png)
Plug the name "Gabriel Cortney" into google and you find this:
[https://www.linkedin.com/in/gabriel-cortney-3308a9224](https://www.linkedin.com/in/gabriel-cortney-3308a9224 "https://www.linkedin.com/in/gabriel-cortney-3308a9224")

That link shows that they work at opticalsocial.

If you type that into google, you find a github profile: https://gist.github.com/Oswald-Denman

Then the flag was:  osu{Oswald_Denman}
