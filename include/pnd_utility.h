
#ifndef h_pnd_utility_h
#define h_pnd_utility_h

#ifdef __cplusplus
extern "C" {
#endif

#include <time.h>

// expand_tilde() will only function correctly if a user is actually logged in; perhaps you
// want to spin until it looks like someone has in fact done so. (most devices will likely
// have auto-login, but its not instantaneous!)
//  r_username is optional; if present, will receive a copy of username
unsigned char pnd_check_login ( char *r_username, unsigned int maxlen );

// given a malloc'd pointer to a string, expand ~ to $HOME as often as it is found, returning a
// new string; the old string is destroyed in the process, or returned as-is.
char *pnd_expand_tilde ( char *freeable_buffer );

// arbtrary execute function; fire and forget really
void pnd_exec_no_wait_1 ( char *fullpath, char *arg1 );

//  NOTE: Does _NOT_ automatically pick up PXML-overrides; you can call that function if you want
pnd_pxml_handle *pnd_pxml_get_by_path ( char *fullpath );

// determine_mountpoint() will examine a path, and return the mountpoint that this path
// is sitting on; returns 1 on success, meaning the target was populated.
// consider for a similar effect: df /home -> look at "Mounted on"
unsigned char pnd_determine_mountpoint ( char *fullpath, char *r_mountpoint, unsigned int mountpoint_len );

// filecopy will return >0 on success
unsigned char pnd_filecopy ( char *sourcepath, char *targetpath );

// some lame file locking utility (not using 'flock')
// ** This is not race condition safe, so not for serious locking; this is just for casual locking, not high speed
#define PND_LOCK_PATH "/tmp" /* default path to stick lockfiles */
unsigned char pnd_lock ( char *lockname ); // return 0 on fail, >0 on success; lock file, not semaphore/etc
time_t pnd_is_locked ( char *lockname );   // return 0 on unlocked, >0 is epoch time when locked
void pnd_unlock ( char *lockname );        // assumes success
// wait 'max' occurances of microseconds (usleep) for unlock
// if max is 0, will not wait at all (will just check, same as pnd_is_locked())
// return '1' for unlock (may be immediate), 0 for failed 'max' timse
unsigned char pnd_wait_for_unlock ( char *lockname, unsigned short int max, unsigned int usec_delta );

#ifdef __cplusplus
} /* "C" */
#endif

#endif
