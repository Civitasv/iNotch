/*
 * AppleMusic.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class AppleMusicApplication, AppleMusicItem, AppleMusicAirPlayDevice, AppleMusicArtwork, AppleMusicEncoder, AppleMusicEQPreset, AppleMusicPlaylist, AppleMusicAudioCDPlaylist, AppleMusicLibraryPlaylist, AppleMusicRadioTunerPlaylist, AppleMusicSource, AppleMusicSubscriptionPlaylist, AppleMusicTrack, AppleMusicAudioCDTrack, AppleMusicFileTrack, AppleMusicSharedTrack, AppleMusicURLTrack, AppleMusicUserPlaylist, AppleMusicFolderPlaylist, AppleMusicVisual, AppleMusicWindow, AppleMusicBrowserWindow, AppleMusicEQWindow, AppleMusicMiniplayerWindow, AppleMusicPlaylistWindow, AppleMusicVideoWindow;

enum AppleMusicEKnd {
	AppleMusicEKndTrackListing = 'kTrk' /* a basic listing of tracks within a playlist */,
	AppleMusicEKndAlbumListing = 'kAlb' /* a listing of a playlist grouped by album */,
	AppleMusicEKndCdInsert = 'kCDi' /* a printout of the playlist for jewel case inserts */
};
typedef enum AppleMusicEKnd AppleMusicEKnd;

enum AppleMusicEnum {
	AppleMusicEnumStandard = 'lwst' /* Standard PostScript error handling */,
	AppleMusicEnumDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum AppleMusicEnum AppleMusicEnum;

enum AppleMusicEPlS {
	AppleMusicEPlSStopped = 'kPSS',
	AppleMusicEPlSPlaying = 'kPSP',
	AppleMusicEPlSPaused = 'kPSp',
	AppleMusicEPlSFastForwarding = 'kPSF',
	AppleMusicEPlSRewinding = 'kPSR'
};
typedef enum AppleMusicEPlS AppleMusicEPlS;

enum AppleMusicERpt {
	AppleMusicERptOff = 'kRpO',
	AppleMusicERptOne = 'kRp1',
	AppleMusicERptAll = 'kAll'
};
typedef enum AppleMusicERpt AppleMusicERpt;

enum AppleMusicEShM {
	AppleMusicEShMSongs = 'kShS',
	AppleMusicEShMAlbums = 'kShA',
	AppleMusicEShMGroupings = 'kShG'
};
typedef enum AppleMusicEShM AppleMusicEShM;

enum AppleMusicESrc {
	AppleMusicESrcLibrary = 'kLib',
	AppleMusicESrcAudioCD = 'kACD',
	AppleMusicESrcMP3CD = 'kMCD',
	AppleMusicESrcRadioTuner = 'kTun',
	AppleMusicESrcSharedLibrary = 'kShd',
	AppleMusicESrcITunesStore = 'kITS',
	AppleMusicESrcUnknown = 'kUnk'
};
typedef enum AppleMusicESrc AppleMusicESrc;

enum AppleMusicESrA {
	AppleMusicESrAAlbums = 'kSrL' /* albums only */,
	AppleMusicESrAAll = 'kAll' /* all text fields */,
	AppleMusicESrAArtists = 'kSrR' /* artists only */,
	AppleMusicESrAComposers = 'kSrC' /* composers only */,
	AppleMusicESrADisplayed = 'kSrV' /* visible text fields */,
	AppleMusicESrANames = 'kSrS' /* track names only */
};
typedef enum AppleMusicESrA AppleMusicESrA;

enum AppleMusicESpK {
	AppleMusicESpKNone = 'kNon',
	AppleMusicESpKFolder = 'kSpF',
	AppleMusicESpKGenius = 'kSpG',
	AppleMusicESpKLibrary = 'kSpL',
	AppleMusicESpKMusic = 'kSpZ',
	AppleMusicESpKPurchasedMusic = 'kSpM'
};
typedef enum AppleMusicESpK AppleMusicESpK;

enum AppleMusicEMdK {
	AppleMusicEMdKSong = 'kMdS' /* music track */,
	AppleMusicEMdKMusicVideo = 'kVdV' /* music video track */,
	AppleMusicEMdKMovie = 'kVdM' /* movie track */,
	AppleMusicEMdKTVShow = 'kVdT' /* TV show track */,
	AppleMusicEMdKUnknown = 'kUnk'
};
typedef enum AppleMusicEMdK AppleMusicEMdK;

enum AppleMusicERtK {
	AppleMusicERtKUser = 'kRtU' /* user-specified rating */,
	AppleMusicERtKComputed = 'kRtC' /* computed rating */
};
typedef enum AppleMusicERtK AppleMusicERtK;

enum AppleMusicEAPD {
	AppleMusicEAPDComputer = 'kAPC',
	AppleMusicEAPDAirPortExpress = 'kAPX',
	AppleMusicEAPDAppleTV = 'kAPT',
	AppleMusicEAPDAirPlayDevice = 'kAPO',
	AppleMusicEAPDBluetoothDevice = 'kAPB',
	AppleMusicEAPDHomePod = 'kAPH',
	AppleMusicEAPDTV = 'kAPV',
	AppleMusicEAPDUnknown = 'kAPU'
};
typedef enum AppleMusicEAPD AppleMusicEAPD;

enum AppleMusicEClS {
	AppleMusicEClSUnknown = 'kUnk',
	AppleMusicEClSPurchased = 'kPur',
	AppleMusicEClSMatched = 'kMat',
	AppleMusicEClSUploaded = 'kUpl',
	AppleMusicEClSIneligible = 'kRej',
	AppleMusicEClSRemoved = 'kRem',
	AppleMusicEClSError = 'kErr',
	AppleMusicEClSDuplicate = 'kDup',
	AppleMusicEClSSubscription = 'kSub',
	AppleMusicEClSPrerelease = 'kPrR',
	AppleMusicEClSNoLongerAvailable = 'kRev',
	AppleMusicEClSNotUploaded = 'kUpP'
};
typedef enum AppleMusicEClS AppleMusicEClS;

enum AppleMusicEExF {
	AppleMusicEExFPlainText = 'kTXT',
	AppleMusicEExFUnicodeText = 'kUCT',
	AppleMusicEExFXML = 'kXML',
	AppleMusicEExFM3U = 'kM3U',
	AppleMusicEExFM3U8 = 'kM38'
};
typedef enum AppleMusicEExF AppleMusicEExF;

@protocol AppleMusicGenericMethods

- (void) printPrintDialog:(BOOL)printDialog withProperties:(NSDictionary *)withProperties kind:(AppleMusicEKnd)kind theme:(NSString *)theme;  // Print the specified object(s)
- (void) close;  // Close an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (void) open;  // Open the specified object(s)
- (void) save;  // Save the specified object(s)
- (void) playOnce:(BOOL)once;  // play the current track or the specified track or file.
- (void) select;  // select the specified object(s)

@end



/*
 * Music Suite
 */

// The application program
@interface AppleMusicApplication : SBApplication

- (SBElementArray<AppleMusicAirPlayDevice *> *) AirPlayDevices;
- (SBElementArray<AppleMusicBrowserWindow *> *) browserWindows;
- (SBElementArray<AppleMusicEncoder *> *) encoders;
- (SBElementArray<AppleMusicEQPreset *> *) EQPresets;
- (SBElementArray<AppleMusicEQWindow *> *) EQWindows;
- (SBElementArray<AppleMusicMiniplayerWindow *> *) miniplayerWindows;
- (SBElementArray<AppleMusicPlaylist *> *) playlists;
- (SBElementArray<AppleMusicPlaylistWindow *> *) playlistWindows;
- (SBElementArray<AppleMusicSource *> *) sources;
- (SBElementArray<AppleMusicTrack *> *) tracks;
- (SBElementArray<AppleMusicVideoWindow *> *) videoWindows;
- (SBElementArray<AppleMusicVisual *> *) visuals;
- (SBElementArray<AppleMusicWindow *> *) windows;

@property (readonly) BOOL AirPlayEnabled;  // is AirPlay currently enabled?
@property (readonly) BOOL converting;  // is a track currently being converted?
@property (copy) NSArray<AppleMusicAirPlayDevice *> *currentAirPlayDevices;  // the currently selected AirPlay device(s)
@property (copy) AppleMusicEncoder *currentEncoder;  // the currently selected encoder (MP3, AIFF, WAV, etc.)
@property (copy) AppleMusicEQPreset *currentEQPreset;  // the currently selected equalizer preset
@property (copy, readonly) AppleMusicPlaylist *currentPlaylist;  // the playlist containing the currently targeted track
@property (copy, readonly) NSString *currentStreamTitle;  // the name of the current track in the playing stream (provided by streaming server)
@property (copy, readonly) NSString *currentStreamURL;  // the URL of the playing stream or streaming web site (provided by streaming server)
@property (copy, readonly) AppleMusicTrack *currentTrack;  // the current targeted track
@property (copy) AppleMusicVisual *currentVisual;  // the currently selected visual plug-in
@property BOOL EQEnabled;  // is the equalizer enabled?
@property BOOL fixedIndexing;  // true if all AppleScript track indices should be independent of the play order of the owning playlist.
@property BOOL frontmost;  // is this the active application?
@property BOOL fullScreen;  // is the application using the entire screen?
@property (copy, readonly) NSString *name;  // the name of the application
@property BOOL mute;  // has the sound output been muted?
@property double playerPosition;  // the player’s position within the currently playing track in seconds.
@property (readonly) AppleMusicEPlS playerState;  // is the player stopped, paused, or playing?
@property (copy, readonly) SBObject *selection;  // the selection visible to the user
@property BOOL shuffleEnabled;  // are songs played in random order?
@property AppleMusicEShM shuffleMode;  // the playback shuffle mode
@property AppleMusicERpt songRepeat;  // the playback repeat mode
@property NSInteger soundVolume;  // the sound output volume (0 = minimum, 100 = maximum)
@property (copy, readonly) NSString *version;  // the version of the application
@property BOOL visualsEnabled;  // are visuals currently being displayed?

- (void) printPrintDialog:(BOOL)printDialog withProperties:(NSDictionary *)withProperties kind:(AppleMusicEKnd)kind theme:(NSString *)theme;  // Print the specified object(s)
- (void) run;  // Run the application
- (void) quit;  // Quit the application
- (AppleMusicTrack *) add:(NSArray<NSURL *> *)x to:(SBObject *)to;  // add one or more files to a playlist
- (void) backTrack;  // reposition to beginning of current track or go to previous track if already at start of current track
- (AppleMusicTrack *) convert:(NSArray<SBObject *> *)x;  // convert one or more files or tracks
- (void) fastForward;  // skip forward in a playing track
- (void) nextTrack;  // advance to the next track in the current playlist
- (void) pause;  // pause playback
- (void) playOnce:(BOOL)once;  // play the current track or the specified track or file.
- (void) playpause;  // toggle the playing/paused state of the current track
- (void) previousTrack;  // return to the previous track in the current playlist
- (void) resume;  // disable fast forward/rewind and resume playback, if playing.
- (void) rewind;  // skip backwards in a playing track
- (void) stop;  // stop playback
- (void) openLocation:(NSString *)x;  // Opens an iTunes Store or audio stream URL

@end

// an item
@interface AppleMusicItem : SBObject <AppleMusicGenericMethods>

@property (copy, readonly) SBObject *container;  // the container of the item
- (NSInteger) id;  // the id of the item
@property (readonly) NSInteger index;  // the index of the item in internal application order
@property (copy) NSString *name;  // the name of the item
@property (copy, readonly) NSString *persistentID;  // the id of the item as a hexadecimal string. This id does not change over time.
@property (copy) NSDictionary *properties;  // every property of the item

- (void) download;  // download a cloud track or playlist
- (NSString *) exportAs:(AppleMusicEExF)as to:(NSURL *)to;  // export a source or playlist
- (void) reveal;  // reveal and select a track or playlist

@end

// an AirPlay device
@interface AppleMusicAirPlayDevice : AppleMusicItem

@property (readonly) BOOL active;  // is the device currently being played to?
@property (readonly) BOOL available;  // is the device currently available?
@property (readonly) AppleMusicEAPD kind;  // the kind of the device
@property (copy, readonly) NSString *networkAddress;  // the network (MAC) address of the device
- (BOOL) protected;  // is the device password- or passcode-protected?
@property BOOL selected;  // is the device currently selected?
@property (readonly) BOOL supportsAudio;  // does the device support audio playback?
@property (readonly) BOOL supportsVideo;  // does the device support video playback?
@property NSInteger soundVolume;  // the output volume for the device (0 = minimum, 100 = maximum)


@end

// a piece of art within a track or playlist
@interface AppleMusicArtwork : AppleMusicItem

@property (copy) NSImage *data;  // data for this artwork, in the form of a picture
@property (copy) NSString *objectDescription;  // description of artwork as a string
@property (readonly) BOOL downloaded;  // was this artwork downloaded by Music?
@property (copy, readonly) NSNumber *format;  // the data format for this piece of artwork
@property NSInteger kind;  // kind or purpose of this piece of artwork
@property (copy) id rawData;  // data for this artwork, in original format


@end

// converts a track to a specific file format
@interface AppleMusicEncoder : AppleMusicItem

@property (copy, readonly) NSString *format;  // the data format created by the encoder


@end

// equalizer preset configuration
@interface AppleMusicEQPreset : AppleMusicItem

@property double band1;  // the equalizer 32 Hz band level (-12.0 dB to +12.0 dB)
@property double band2;  // the equalizer 64 Hz band level (-12.0 dB to +12.0 dB)
@property double band3;  // the equalizer 125 Hz band level (-12.0 dB to +12.0 dB)
@property double band4;  // the equalizer 250 Hz band level (-12.0 dB to +12.0 dB)
@property double band5;  // the equalizer 500 Hz band level (-12.0 dB to +12.0 dB)
@property double band6;  // the equalizer 1 kHz band level (-12.0 dB to +12.0 dB)
@property double band7;  // the equalizer 2 kHz band level (-12.0 dB to +12.0 dB)
@property double band8;  // the equalizer 4 kHz band level (-12.0 dB to +12.0 dB)
@property double band9;  // the equalizer 8 kHz band level (-12.0 dB to +12.0 dB)
@property double band10;  // the equalizer 16 kHz band level (-12.0 dB to +12.0 dB)
@property (readonly) BOOL modifiable;  // can this preset be modified?
@property double preamp;  // the equalizer preamp level (-12.0 dB to +12.0 dB)
@property BOOL updateTracks;  // should tracks which refer to this preset be updated when the preset is renamed or deleted?


@end

// a list of tracks/streams
@interface AppleMusicPlaylist : AppleMusicItem

- (SBElementArray<AppleMusicTrack *> *) tracks;
- (SBElementArray<AppleMusicArtwork *> *) artworks;

@property (copy) NSString *objectDescription;  // the description of the playlist
@property BOOL disliked;  // is this playlist disliked?
@property (readonly) NSInteger duration;  // the total length of all tracks (in seconds)
@property (copy) NSString *name;  // the name of the playlist
@property BOOL favorited;  // is this playlist favorited?
@property (copy, readonly) AppleMusicPlaylist *parent;  // folder which contains this playlist (if any)
@property (readonly) NSInteger size;  // the total size of all tracks (in bytes)
@property (readonly) AppleMusicESpK specialKind;  // special playlist kind
@property (copy, readonly) NSString *time;  // the length of all tracks in MM:SS format
@property (readonly) BOOL visible;  // is this playlist visible in the Source list?

- (void) moveTo:(SBObject *)to;  // Move playlist(s) to a new location
- (AppleMusicTrack *) searchFor:(NSString *)for_ only:(AppleMusicESrA)only;  // search a playlist for tracks matching the search string. Identical to entering search text in the Search field.

@end

// a playlist representing an audio CD
@interface AppleMusicAudioCDPlaylist : AppleMusicPlaylist

- (SBElementArray<AppleMusicAudioCDTrack *> *) audioCDTracks;

@property (copy) NSString *artist;  // the artist of the CD
@property BOOL compilation;  // is this CD a compilation album?
@property (copy) NSString *composer;  // the composer of the CD
@property NSInteger discCount;  // the total number of discs in this CD’s album
@property NSInteger discNumber;  // the index of this CD disc in the source album
@property (copy) NSString *genre;  // the genre of the CD
@property NSInteger year;  // the year the album was recorded/released


@end

// the main library playlist
@interface AppleMusicLibraryPlaylist : AppleMusicPlaylist

- (SBElementArray<AppleMusicFileTrack *> *) fileTracks;
- (SBElementArray<AppleMusicURLTrack *> *) URLTracks;
- (SBElementArray<AppleMusicSharedTrack *> *) sharedTracks;


@end

// the radio tuner playlist
@interface AppleMusicRadioTunerPlaylist : AppleMusicPlaylist

- (SBElementArray<AppleMusicURLTrack *> *) URLTracks;


@end

// a media source (library, CD, device, etc.)
@interface AppleMusicSource : AppleMusicItem

- (SBElementArray<AppleMusicAudioCDPlaylist *> *) audioCDPlaylists;
- (SBElementArray<AppleMusicLibraryPlaylist *> *) libraryPlaylists;
- (SBElementArray<AppleMusicPlaylist *> *) playlists;
- (SBElementArray<AppleMusicRadioTunerPlaylist *> *) radioTunerPlaylists;
- (SBElementArray<AppleMusicSubscriptionPlaylist *> *) subscriptionPlaylists;
- (SBElementArray<AppleMusicUserPlaylist *> *) userPlaylists;

@property (readonly) long long capacity;  // the total size of the source if it has a fixed size
@property (readonly) long long freeSpace;  // the free space on the source if it has a fixed size
@property (readonly) AppleMusicESrc kind;


@end

// a subscription playlist from Apple Music
@interface AppleMusicSubscriptionPlaylist : AppleMusicPlaylist

- (SBElementArray<AppleMusicFileTrack *> *) fileTracks;
- (SBElementArray<AppleMusicURLTrack *> *) URLTracks;


@end

// playable audio source
@interface AppleMusicTrack : AppleMusicItem

- (SBElementArray<AppleMusicArtwork *> *) artworks;

@property (copy) NSString *album;  // the album name of the track
@property (copy) NSString *albumArtist;  // the album artist of the track
@property BOOL albumDisliked;  // is the album for this track disliked?
@property BOOL albumFavorited;  // is the album for this track favorited?
@property NSInteger albumRating;  // the rating of the album for this track (0 to 100)
@property (readonly) AppleMusicERtK albumRatingKind;  // the rating kind of the album rating for this track
@property (copy) NSString *artist;  // the artist/source of the track
@property (readonly) NSInteger bitRate;  // the bit rate of the track (in kbps)
@property double bookmark;  // the bookmark time of the track in seconds
@property BOOL bookmarkable;  // is the playback position for this track remembered?
@property NSInteger bpm;  // the tempo of this track in beats per minute
@property (copy) NSString *category;  // the category of the track
@property (readonly) AppleMusicEClS cloudStatus;  // the iCloud status of the track
@property (copy) NSString *comment;  // freeform notes about the track
@property BOOL compilation;  // is this track from a compilation album?
@property (copy) NSString *composer;  // the composer of the track
@property (readonly) NSInteger databaseID;  // the common, unique ID for this track. If two tracks in different playlists have the same database ID, they are sharing the same data.
@property (copy, readonly) NSDate *dateAdded;  // the date the track was added to the playlist
@property (copy) NSString *objectDescription;  // the description of the track
@property NSInteger discCount;  // the total number of discs in the source album
@property NSInteger discNumber;  // the index of the disc containing this track on the source album
@property BOOL disliked;  // is this track disliked?
@property (copy, readonly) NSString *downloaderAppleID;  // the Apple ID of the person who downloaded this track
@property (copy, readonly) NSString *downloaderName;  // the name of the person who downloaded this track
@property (readonly) double duration;  // the length of the track in seconds
@property BOOL enabled;  // is this track checked for playback?
@property (copy) NSString *episodeID;  // the episode ID of the track
@property NSInteger episodeNumber;  // the episode number of the track
@property (copy) NSString *EQ;  // the name of the EQ preset of the track
@property double finish;  // the stop time of the track in seconds
@property BOOL gapless;  // is this track from a gapless album?
@property (copy) NSString *genre;  // the music/audio genre (category) of the track
@property (copy) NSString *grouping;  // the grouping (piece) of the track. Generally used to denote movements within a classical work.
@property (copy, readonly) NSString *kind;  // a text description of the track
@property (copy) NSString *longDescription;  // the long description of the track
@property BOOL favorited;  // is this track favorited?
@property (copy) NSString *lyrics;  // the lyrics of the track
@property AppleMusicEMdK mediaKind;  // the media kind of the track
@property (copy, readonly) NSDate *modificationDate;  // the modification date of the content of this track
@property (copy) NSString *movement;  // the movement name of the track
@property NSInteger movementCount;  // the total number of movements in the work
@property NSInteger movementNumber;  // the index of the movement in the work
@property NSInteger playedCount;  // number of times this track has been played
@property (copy) NSDate *playedDate;  // the date and time this track was last played
@property (copy, readonly) NSString *purchaserAppleID;  // the Apple ID of the person who purchased this track
@property (copy, readonly) NSString *purchaserName;  // the name of the person who purchased this track
@property NSInteger rating;  // the rating of this track (0 to 100)
@property (readonly) AppleMusicERtK ratingKind;  // the rating kind of this track
@property (copy, readonly) NSDate *releaseDate;  // the release date of this track
@property (readonly) NSInteger sampleRate;  // the sample rate of the track (in Hz)
@property NSInteger seasonNumber;  // the season number of the track
@property BOOL shufflable;  // is this track included when shuffling?
@property NSInteger skippedCount;  // number of times this track has been skipped
@property (copy) NSDate *skippedDate;  // the date and time this track was last skipped
@property (copy) NSString *show;  // the show name of the track
@property (copy) NSString *sortAlbum;  // override string to use for the track when sorting by album
@property (copy) NSString *sortArtist;  // override string to use for the track when sorting by artist
@property (copy) NSString *sortAlbumArtist;  // override string to use for the track when sorting by album artist
@property (copy) NSString *sortName;  // override string to use for the track when sorting by name
@property (copy) NSString *sortComposer;  // override string to use for the track when sorting by composer
@property (copy) NSString *sortShow;  // override string to use for the track when sorting by show name
@property (readonly) long long size;  // the size of the track (in bytes)
@property double start;  // the start time of the track in seconds
@property (copy, readonly) NSString *time;  // the length of the track in MM:SS format
@property NSInteger trackCount;  // the total number of tracks on the source album
@property NSInteger trackNumber;  // the index of the track on the source album
@property BOOL unplayed;  // is this track unplayed?
@property NSInteger volumeAdjustment;  // relative volume adjustment of the track (-100% to 100%)
@property (copy) NSString *work;  // the work name of the track
@property NSInteger year;  // the year the track was recorded/released


@end

// a track on an audio CD
@interface AppleMusicAudioCDTrack : AppleMusicTrack

@property (copy, readonly) NSURL *location;  // the location of the file represented by this track


@end

// a track representing an audio file (MP3, AIFF, etc.)
@interface AppleMusicFileTrack : AppleMusicTrack

@property (copy) NSURL *location;  // the location of the file represented by this track

- (void) refresh;  // update file track information from the current information in the track’s file

@end

// a track residing in a shared library
@interface AppleMusicSharedTrack : AppleMusicTrack


@end

// a track representing a network stream
@interface AppleMusicURLTrack : AppleMusicTrack

@property (copy) NSString *address;  // the URL for this track


@end

// custom playlists created by the user
@interface AppleMusicUserPlaylist : AppleMusicPlaylist

- (SBElementArray<AppleMusicFileTrack *> *) fileTracks;
- (SBElementArray<AppleMusicURLTrack *> *) URLTracks;
- (SBElementArray<AppleMusicSharedTrack *> *) sharedTracks;

@property BOOL shared;  // is this playlist shared?
@property (readonly) BOOL smart;  // is this a Smart Playlist?
@property (readonly) BOOL genius;  // is this a Genius Playlist?


@end

// a folder that contains other playlists
@interface AppleMusicFolderPlaylist : AppleMusicUserPlaylist


@end

// a visual plug-in
@interface AppleMusicVisual : AppleMusicItem


@end

// any window
@interface AppleMusicWindow : AppleMusicItem

@property NSRect bounds;  // the boundary rectangle for the window
@property (readonly) BOOL closeable;  // does the window have a close button?
@property (readonly) BOOL collapseable;  // does the window have a collapse button?
@property BOOL collapsed;  // is the window collapsed?
@property BOOL fullScreen;  // is the window full screen?
@property NSPoint position;  // the upper left position of the window
@property (readonly) BOOL resizable;  // is the window resizable?
@property BOOL visible;  // is the window visible?
@property (readonly) BOOL zoomable;  // is the window zoomable?
@property BOOL zoomed;  // is the window zoomed?


@end

// the main window
@interface AppleMusicBrowserWindow : AppleMusicWindow

@property (copy, readonly) SBObject *selection;  // the selected tracks
@property (copy) AppleMusicPlaylist *view;  // the playlist currently displayed in the window


@end

// the equalizer window
@interface AppleMusicEQWindow : AppleMusicWindow


@end

// the miniplayer window
@interface AppleMusicMiniplayerWindow : AppleMusicWindow


@end

// a sub-window showing a single playlist
@interface AppleMusicPlaylistWindow : AppleMusicWindow

@property (copy, readonly) SBObject *selection;  // the selected tracks
@property (copy, readonly) AppleMusicPlaylist *view;  // the playlist displayed in the window


@end

// the video window
@interface AppleMusicVideoWindow : AppleMusicWindow


@end

