Slashat för iOS
===============

En app för att följa och interagera med podcasten slashat.se. Utvecklingsarbetet går att följa här på github och på [Slashats forum](http://forum.slashat.se/viewforum.php?f=13) där man kan diskutera allt som har med utvecklandet av apparna att göra. Om man är sugen på att hjälpa till (vi behöver all hjälp vi kan få) så  är det enklast att forka det här projektet och börja utforska. 

Vill man hänga bland likasinnande så brukar det alltid vara någon online i [#slashatdev på irc.slashat.se](irc://irc.slashat.se/slashatdev). 

Skisser och planer är utspridda mellan forumet och github. Det smidigaste är nästan att fråga på forumet, i #slashatdev eller fråga ([@kottkrig](http://twitter.com/kottkrig)) om man undrar över vad det är som gäller.

Features:
---------
* Se Slashat live på tisdagar kl 19.30
* Lyssna på avsnitt från förr
* Mer info om oss programledare

Utvecklarbeslut:
-------

* Automatic Reference Counting
* Storyboards
* iOS 6

Med tanke på att utrullningen av iOS6 gått såpass smärtfritt (senaste siffrorna ligger på ~75% and counting) så kör vi det som krav. Detta innebär att vi utan problem kan använda godsaker som *Social Framework*, *UITableView pull-to-refresh*, och *UICollectionView*.

Gränssnittet och flödet är i stor mån uppbyggt med hjälp av Storyboards. 

Vi kör ARC för att slippa jönsa runt med retain/release.

Mer info kommer.
