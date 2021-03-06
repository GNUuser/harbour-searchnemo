# SearchNemo

A simple yet powerful text search tool for [Sailfish OS](https://sailfishos.org/) and [Jolla phone](http://jolla.com/) devices.
It searches local directories for a given text inside various file types.
It can also find file and directory names containing searched text.

### Features
 * Search local directories for a given text inside files (and file/dir names) and return results list divided into sections
 * It is possible to search for a plain text or regular expression
 * Selectable search paths with white- and blacklisted directiories
 * Customization of search by quickly selectable profiles (selection of search paths, file types, max. nr of displayed search results)
 * Searched files are recognized by their MIME type or by filename extension
 * Currently supported search targets: Notes app database, files (text, html, [sqlite](https://www.sqlite.org/)), applications, filenames, directory names
 * Special search inside Notes app database (with indication of note number containing searched text)
 * Searched text is always case insensitive
 * On/off search in hidden files and directiories
 * On/off symbolic links support
 * Clear search results when press&hold on empty search field
 * Dynamically extended sections of search result list
 * Cumulative and plain view of search result list
 * Detailed view of searched text with context
 * Dynamically extended detailed file info
 * Detailed view of sqlite database record containing searched text
 * Possibility to select and copy text (open by tapping text in detailed view)
 * Preview html files
 * Open app to which found database belongs to
 * Open files (if xdg-open finds a preferred application)
 * Share files with bluetooth, MMS, e-mail etc. (depending on MIME type)
 * Open directories with File manager (using os build-in manager)
 * Open found applications
 * Preview JPEG, PNG and GIF files
 * Play back WAV, MP3, OGG and FLAC audio
 * Install Android APK and Sailfish RPM packages

### Search method
Search function is line oriented.
It assumes the serched files (except sqlite db) contain newline character. If the newline character isn't present, then the whole file is treated as a single line.

### Data safety
SearchNemo does not open any files for writing (except own config file), so there is no danger to corrupt any files stored on device.
It does not collect nor store any data from search results. It works offline and does not need network connection.
Since it is able to open local html files, it is possible to open any links (local and remote) in these files and in that case a network connection may be used.

### Translations
Currently supported languages:

 * English
 * Polish
 * Dutch (translation made by Nathan Follens, Michiel Pater)
 * German (translation made by Unreasonable_Behaviour)
 * Hungarian (translation made by Szabó G.)
 * Italian (translation made by fravaccaro)
 * Russian (translation made by Вячеслав Диконов)
 * Spanish (translation made by Carmen Fernández B.) 
 * Swedish (translation made by Åke Engelbrektson)

[Translation service](https://www.transifex.com/sargoprojects/searchnemo/) is available. Any contributions are very welcome.

### Author's comments and plans
I didn't find any similar application for Sailfish OS, so I decided to write one.
Since I kept a lot of txt and html files locally on device, I needed a tool which could find any text inside files and nicely show results.
It is always possible to do the same task using find program in command line, but ... do we have to always use command line tools having so pretty graphical os?

As a starting point I took very good app: File Browser (see Acknowledgements) and adopted search function to my needs.
Current developement state suites me well, but it can be just a starting point for further development.
Any comments, new ideas and pull requests are very welcome.

Plans:

 * ~~to introduce regular expression search~~ done!
 * to open desired app with a parameter (if app allows it)
 * to search inside other files (e.g. pdf)

### Release notes
See [here](https://github.com/sargo-devel/harbour-searchnemo/blob/master/RELEASENOTES.md) for detailed history. 



### Acknowledgements
The source code is based on the excellent [File Browser](https://github.com/karip/harbour-file-browser).
Additionaly [JHead](http://www.sentex.net/~mwandel/jhead/) Exif manipulation tool is used for display Exif data of found image files. 
