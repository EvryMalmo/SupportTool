//
//  cutils.c
//  One Support Tool
//
//  Created by Admin on 2016-04-22.
//  Copyright © 2016 EVRY. All rights reserved.
//

#include "cutils.h"
#define STRLEN  80

static int  cutils_is_initialized = 0;
static int  get_sysctl_is_called = 0;

struct utsname struct_utsname;

static char os_name[STRLEN + 1];
static char computer_name[STRLEN + 1];
static char model_name[STRLEN + 1];


static char *get_sysctl_str(char *name)
{
    static  char    *p;
    size_t          len;
    
    if (get_sysctl_is_called)
    {
        free(p);
        p = NULL;
    }
    
    if (strlen(name) > 0)
    {
        get_sysctl_is_called = 1;

        sysctlbyname(name, NULL, &len, NULL, 0);
        p = malloc(len);
        sysctlbyname(name, p, &len, NULL, 0);
        return p;
    }
    
    return "";
}

void initialize_cutils(void)
{
    if (cutils_is_initialized)
        return;
    
    cutils_is_initialized = 1;
    
    uname(&struct_utsname);
    // OS Name
    memset(os_name, 0, sizeof(os_name));
    strncpy(os_name, struct_utsname.sysname, STRLEN);

    
    // Model
    memset(model_name, 0, sizeof(model_name));
    strncpy(model_name, get_sysctl_str("hw.model"), STRLEN);

    get_sysctl_str("");
}

char *get_computer_name(void)
{
    return computer_name;
}

char *get_model_name(void)
{
    return model_name;
}


char *get_os_name(void)
{
    return os_name;
}