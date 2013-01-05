Slashat för iOS
===============

En app för att följa och interagera med podcasten slashat.se. 

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