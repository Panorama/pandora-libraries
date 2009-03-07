
#ifndef h_pnd_device_h
#define h_pnd_device_h

#ifdef __cplusplus
extern "C" {
#endif

// do we have a 'minimal' lib yet anywhere formalized? if not, we could
// attempt to include it here.

// for reference material, see the Pandora wiki. Specifically, some good
// places to look:
// http://pandorawiki.org/Kernel_interface

/* utility
 */
unsigned char pnd_device_open_write_close ( char *name, char *v );
unsigned char pnd_device_open_read_close ( char *name, char *r_buffer, unsigned int buffer_len );

/* overall clock speed
 * WARN: No boundaries are checked, so try to avoid setting clock to 2GHz :)
 * NOTE: get-clock() is not implemented yet.
 */
#define PND_DEVICE_PROC_CLOCK "/proc/pandora/cpu_mhz_max"
unsigned char pnd_device_set_clock ( unsigned int c ); // returns >0 on success
unsigned int pnd_device_get_clock ( void );

// LCD to set on/off

// Backlight control
#define PND_DEVICE_SYS_BACKLIGHT_BRIGHTNESS "/sys/class/backlight/gpio-backlight/brightness"
unsigned char pnd_device_set_backlight ( unsigned int v ); // value to set; 0 is off
unsigned int pnd_device_get_backlight ( void );

// set one or more LEDs on

// suspend/hibernate/etc

#ifdef __cplusplus
} /* "C" */
#endif

#endif
