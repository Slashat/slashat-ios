Slashat för iOS
===============

En app till iPhone och iPad för att följa och interagera med podcasten slashat.se. Utvecklingsarbetet går att följa här på github och på [Slashats forum](http://forum.slashat.se/viewforum.php?f=13) där man kan diskutera allt som har med utvecklandet av apparna att göra. Om man är sugen på att hjälpa till (vi behöver all hjälp vi kan få) så  är det enklast att forka det här projektet och börja utforska. 

Vill man hänga bland likasinnande så brukar det alltid vara någon online i [#slashatdev på irc.slashat.se][slashatdev]. 

Skisser och planer är utspridda mellan forumet och github. Det smidigaste är nästan att fråga på forumet, i [#slashatdev][slashatdev] eller fråga ([@kottkrig](http://twitter.com/kottkrig)) om man undrar över vad det är som gäller.


Dependencies:
-------------

- [CocoaPods](http://cocoapods.org)
- XCode

Installera CocoaPods, dra ned projektet och kör:

```bash
pod install
```

Öppna sedan `Slashat.xcworkspace`.

Features:
---------
* Se Slashat live på tisdagar kl 19.30
* Lyssna på avsnitt från förr
* Mer info om oss programledare

Utvecklarbeslut:
-------

* Automatic Reference Counting
* Storyboards
* iOS 7

Med tanke på att utrullningen av iOS6 gått såpass smärtfritt (senaste siffrorna ligger på ~75% and counting) så kör vi det som krav. Detta innebär att vi utan problem kan använda godsaker som *Social Framework*, *UITableView pull-to-refresh*, och *UICollectionView*.

Gränssnittet och flödet är i stor mån uppbyggt med hjälp av Storyboards. 

Vi kör ARC för att slippa jönsa runt med retain/release.

Instruktioner
=============
Eftersom vi använder Bambusers privata api för liveström så krävs det en api-nyckel samt endpoint-url till detta api för att kunna se liveströmmar under utvecklingsfasen. Appen i övrigt skall gå fint att köra även utan detta men då utan möjlighet att se liveströmmen. Döp om *SampleAPIKey.h* till *APIKey.h* för att projektet skall kompilera.


Klassöversikt
=============

ViewControllers
---------------

### SlashatLiveViewController
Sköter livefliken. Innehåller poll samt instans av `SlashatLiveVideoViewController` för uppspelning av bambusers livestream.

### SlashatArchiveTableViewController
Sköter Arkivfliken. Hämtar podrss från slashat.se genom *AFNetworking* och modifierad `RSSParser` samt sköter uppritning av celler som länkar till `SlashatArchiveEpisodeViewController`. Cellerna är mappade mot en Array av `SlashatEpisode`-instanser. Någon gång framöver så hade det varit snygg om detta cachades lokalt i CoreData och mergades varje gång man uppdaterade. För tillfället så hämtas hela rss:en på nytt varje gång vyn startar.

### SlashatArchiveEpisodeViewController
Vykontroller för arkiverat slashatavsnitt. Initieras med en instans av `SlashatEpisode`. Titel och text sätts från episoden som den initieras med. Tryck på playknapp skickar episoden vidare till `AppDelegate` som i sin tur spelar episoden genom en instans av `SlashatAudioControlViewController`.

### SlashatAboutTableViewController
Vykontroller för Om oss-fliken. En TableView bestående av foton på våra nunor samt label med namn. Info och bild ligger lokalt i appen.

### SlashatAboutHostProfileViewController
Vykontroller för en programledare för slashat. Skall innehålla foto, länkar till sociala medier och beskrivande text. Info och bild ligger lokalt i appen.

### SlashatAudioControlViewController
Håller en instans av `SlashatAudioHandler` och sköter uppspelning av en arkiverad slashatepisod. Skall innehålla play/pause, duration samt airplaymöjlighet. Denna skall synas på samtliga vyer i appen (och därför ligger den i nuläget i AppDelegaten) och skall kännas som att den ligger i anslutning till TabBaren.

### SlashatLiveVideoViewController
Sköter uppspelning av Slashats livestream via bambusers privata transcoding api. Man behöver hemliga nycklar för att kunna köra denna i devläge. 


Models
------

### SlashatEpisode
Innehåller relevant info om ett slashatavsnitt från rss-feeden. Denna info används för att starta uppspelning av avsnitt.

	title
	itemDescription
	link
	mediaUrl
	podcastImage


Övrigt
------

### SlashatAudioHandler
Sköter uppspelning av ett `SlashatEpisode`. Använder sig av `MPMoviePlayerController` för att strömma från ett avsnitts `mediaUrl`. Troligtvis så sköter denna klass även sättandet av lock-screen-media-image samt lyssning på användarinteraktion från låsskärm eller systemets mediaknappar.

### AppDelegate
Håller instans av `SlashatAudioControlViewController` för att den skall vara tillgänglig globalt, `SlashatArchiveEpisodeViewController` kallar på `playSlashatAudioEpisode` för att sätta igång spelning av episod. Sköter även sättandet av färger på NavigationBar.

[slashatdev]: irc://irc.slashat.se/slashatdev


Utvecklare
==========

- <a href="https://plus.google.com/113428742926263981798?rel=author" rel="author">Johan Larsson</a>
- Erika Thorsen
