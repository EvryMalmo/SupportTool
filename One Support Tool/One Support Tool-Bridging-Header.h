//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "cutils.h"
void set_networkinfo(void);
char *get_networkinfo(void);

#include <ifaddrs.h>

