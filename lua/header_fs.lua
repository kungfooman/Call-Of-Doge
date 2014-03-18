ffi.cdef [[

// qshared.h

// mode parm for FS_FOpenFile
typedef enum {
	FS_READ,
	FS_WRITE,
	FS_APPEND,
	FS_APPEND_SYNC
} fsMode_t;

typedef enum {
	FS_SEEK_CUR,
	FS_SEEK_END,
	FS_SEEK_SET
} fsOrigin_t;

// also qshared.h, but different position
typedef int		fileHandle_t;

// qcommon.h


/*
==============================================================

FILESYSTEM

No stdio calls should be used by any part of the game, because
we need to deal with all sorts of directory and seperator char
issues.
==============================================================
*/

/*
	// referenced flags
	// these are in loop specific order so don't change the order
	#define FS_GENERAL_REF	0x01
	#define FS_UI_REF		0x02
	#define FS_CGAME_REF	0x04
	// number of id paks that will never be autodownloaded from baseq3/missionpack
	#define NUM_ID_PAKS		9
	#define NUM_TA_PAKS		4

	#define	MAX_FILE_HANDLES	64

	#ifdef DEDICATED
	#	define Q3CONFIG_CFG "q3config_server.cfg"
	#else
	#	define Q3CONFIG_CFG "q3config.cfg"
	#endif
*/
qboolean FS_Initialized( void );

void	FS_InitFilesystem ( void );
void	FS_Shutdown( qboolean closemfp );

qboolean FS_ConditionalRestart(int checksumFeed, qboolean disconnect);
void	FS_Restart( int checksumFeed );
// shutdown and restart the filesystem so changes to fs_gamedir can take effect

void FS_AddGameDirectory( const char *path, const char *dir );

char	**FS_ListFiles( const char *directory, const char *extension, int *numfiles );
// directory should not have either a leading or trailing /
// if extension is "/", only subdirectories will be returned
// the returned files will not include any directories or /

void	FS_FreeFileList( char **list );

qboolean FS_FileExists( const char *file );

qboolean FS_CreatePath (char *OSPath);

int FS_FindVM(void **startSearch, char *found, int foundlen, const char *name, int enableDll);

char   *FS_BuildOSPath( const char *base, const char *game, const char *qpath );
qboolean FS_CompareZipChecksum(const char *zipfile);

int		FS_LoadStack( void );

int		FS_GetFileList(  const char *path, const char *extension, char *listbuf, int bufsize );
int		FS_GetModList(  char *listbuf, int bufsize );

fileHandle_t	FS_FOpenFileWrite( const char *qpath );
fileHandle_t	FS_FOpenFileAppend( const char *filename );
fileHandle_t	FS_FCreateOpenPipeFile( const char *filename );
// will properly create any needed paths and deal with seperater character issues

fileHandle_t FS_SV_FOpenFileWrite( const char *filename );
long		FS_SV_FOpenFileRead( const char *filename, fileHandle_t *fp );
void	FS_SV_Rename( const char *from, const char *to, qboolean safe );
long		FS_FOpenFileRead( const char *qpath, fileHandle_t *file, qboolean uniqueFILE );
// if uniqueFILE is true, then a new FILE will be fopened even if the file
// is found in an already open pak file.  If uniqueFILE is false, you must call
// FS_FCloseFile instead of fclose, otherwise the pak FILE would be improperly closed
// It is generally safe to always set uniqueFILE to true, because the majority of
// file IO goes through FS_ReadFile, which Does The Right Thing already.

int		FS_FileIsInPAK(const char *filename, int *pChecksum );
// returns 1 if a file is in the PAK file, otherwise -1

int		FS_Write( const void *buffer, int len, fileHandle_t f );

int		FS_Read2( void *buffer, int len, fileHandle_t f );
int		FS_Read( void *buffer, int len, fileHandle_t f );
// properly handles partial reads and reads from other dlls

void	FS_FCloseFile( fileHandle_t f );
// note: you can't just fclose from another DLL, due to MS libc issues

long	FS_ReadFileDir(const char *qpath, void *searchPath, qboolean unpure, void **buffer);
long	FS_ReadFile(const char *qpath, void **buffer);
// returns the length of the file
// a null buffer will just return the file length without loading
// as a quick check for existance. -1 length == not present
// A 0 byte will always be appended at the end, so string ops are safe.
// the buffer should be considered read-only, because it may be cached
// for other uses.

void	FS_ForceFlush( fileHandle_t f );
// forces flush on files we're writing to.

void	FS_FreeFile( void *buffer );
// frees the memory returned by FS_ReadFile

void	FS_WriteFile( const char *qpath, const void *buffer, int size );
// writes a complete file, creating any subdirectories needed

long FS_filelength(fileHandle_t f);
// doesn't work for files that are opened from a pack file

int		FS_FTell( fileHandle_t f );
// where are we?

void	FS_Flush( fileHandle_t f );

void 	/*QDECL*/ FS_Printf( fileHandle_t f, const char *fmt, ... ); // __attribute__ ((format (printf, 2, 3)));
// like fprintf

int		FS_FOpenFileByMode( const char *qpath, fileHandle_t *f, fsMode_t mode );
// opens a file for reading, writing, or appending depending on the value of mode

int		FS_Seek( fileHandle_t f, long offset, int origin );
// seek on a file

qboolean FS_FilenameCompare( const char *s1, const char *s2 );

const char *FS_LoadedPakNames( void );
const char *FS_LoadedPakChecksums( void );
const char *FS_LoadedPakPureChecksums( void );
// Returns a space separated string containing the checksums of all loaded pk3 files.
// Servers with sv_pure set will get this string and pass it to clients.

const char *FS_ReferencedPakNames( void );
const char *FS_ReferencedPakChecksums( void );
const char *FS_ReferencedPakPureChecksums( void );
// Returns a space separated string containing the checksums of all loaded 
// AND referenced pk3 files. Servers with sv_pure set will get this string 
// back from clients for pure validation 

void FS_ClearPakReferences( int flags );
// clears referenced booleans on loaded pk3s

void FS_PureServerSetReferencedPaks( const char *pakSums, const char *pakNames );
void FS_PureServerSetLoadedPaks( const char *pakSums, const char *pakNames );
// If the string is empty, all data sources will be allowed.
// If not empty, only pk3 files that match one of the space
// separated checksums will be checked for files, with the
// sole exception of .cfg files.

qboolean FS_CheckDirTraversal(const char *checkdir);
qboolean FS_idPak(char *pak, char *base, int numPaks);
qboolean FS_ComparePaks( char *neededpaks, int len, qboolean dlstring );

void FS_Rename( const char *from, const char *to );

void FS_Remove( const char *osPath );
void FS_HomeRemove( const char *homePath );

void	FS_FilenameCompletion( const char *dir, const char *ext,
		qboolean stripExt, void(*callback)(const char *s), qboolean allowNonPureFilesOnDisk );

const char *FS_GetCurrentGameDir(void);
qboolean FS_Which(const char *filename, void *searchPath);

]]