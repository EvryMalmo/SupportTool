//
//  cutils.c
//  One Support Tool
//
//  Created by Admin on 2016-04-22.
//  Copyright © 2016 EVRY. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>

void initialize_cutils(void);
char *get_computer_name(void);
char *get_model_name(void);
char *get_os_name(void);