//
//  network.c
//  One Support Tool
//
//  Created by Admin on 2016-04-24.
//  Copyright © 2016 EVRY. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
/* The following include files for the network interface. */
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if_types.h>
/* For "strerror". */
#include <string.h>
/* For "errno". */
#include <errno.h>

#define INTERFACE_NAME_LEN  40

static  char    textblock[8192];

/*
 *  Utdata
 *  ------
 *  Interface: name
 *  Macadress: adress
 *  IP4
 *   Address: adress
 *   Mask: adress
 *   Dest: adress
 *   Broad: adress
 *  IP6
 *   Address: adress
 *   Mask: adress
 *
 *  Logik
 *  -----
 *  Skapa en lista med alla interface av typen AF_INET och AF_INET6
 *  Loop denna lista
 *   Skriv ut namn
 *   Skriv ut Macadress
 *   Skriv ut IP4-information
 *   Skriv ut IP6-information
 */

void print_ip (const char * name, struct ifaddrs * ifaddrs_ptr, void * addr_ptr)
{
    if (addr_ptr) {

	/* This constant is defined in <netinet/in.h>. */

	char address[INET6_ADDRSTRLEN];

	inet_ntop (ifaddrs_ptr->ifa_addr->sa_family,
		   addr_ptr,
		   address, sizeof (address));

	sprintf(&textblock[strlen(textblock)], "%s: %s\n", name, address);
    }
}

/* Get a pointer to the address structure from a sockaddr. */

void *get_addr_ptr (struct sockaddr * sockaddr_ptr)
{
    void * addr_ptr = 0;
    if (sockaddr_ptr->sa_family == AF_INET) {
        addr_ptr = &((struct sockaddr_in *)  sockaddr_ptr)->sin_addr;
    }
    else if (sockaddr_ptr->sa_family == AF_INET6) {
        addr_ptr = &((struct sockaddr_in6 *) sockaddr_ptr)->sin6_addr;
    }
    return addr_ptr;
}

/* Print the internet address. */
void print_internet_address (struct ifaddrs * ifaddrs_ptr)
{
    void * addr_ptr;
    if (! ifaddrs_ptr->ifa_addr) {
	return;
    }
    addr_ptr = get_addr_ptr (ifaddrs_ptr->ifa_addr);
    print_ip (" Address", ifaddrs_ptr, addr_ptr);
}

/* Print the netmask. */

void print_netmask (struct ifaddrs * ifaddrs_ptr)
{
    void * addr_ptr;
    if (! ifaddrs_ptr->ifa_netmask) {
	return;
    }
    addr_ptr = get_addr_ptr (ifaddrs_ptr->ifa_netmask);
    print_ip (" Netmask", ifaddrs_ptr, addr_ptr);
}

/* Print the mac address. */

void print_mac_address (const char * mac_address)
{
    int mac_addr_offset;

	sprintf(&textblock[strlen(textblock)], " Mac address: ");
    for (mac_addr_offset = 0; mac_addr_offset < 6; mac_addr_offset++) {
        unsigned char byte;
        
        byte = (unsigned char) mac_address[mac_addr_offset];
        sprintf(&textblock[strlen(textblock)], "%02x", byte);
	if (mac_addr_offset != 5) {
        sprintf(&textblock[strlen(textblock)], ":");
        }
    }
	sprintf(&textblock[strlen(textblock)], "\n");
}

/* Adapted from http://othermark.livejournal.com/3005.html */

void print_af_link (struct ifaddrs * ifaddrs_ptr)
{
    struct sockaddr_dl * sdl;

    sdl = (struct sockaddr_dl *) ifaddrs_ptr->ifa_addr;

    if (sdl->sdl_type == IFT_ETHER) {
        print_mac_address (LLADDR (sdl));
    }
    else if (sdl->sdl_type == IFT_LOOP) {
        sprintf(&textblock[strlen(textblock)], " Loopback\n");
    }
}

void print_internet_interface (struct ifaddrs * ifaddrs_ptr)
{
    print_internet_address (ifaddrs_ptr);
    print_netmask (ifaddrs_ptr);

    /* P2P interface destination */

    if (ifaddrs_ptr->ifa_dstaddr) {
	void * addr_ptr;

        addr_ptr = get_addr_ptr (ifaddrs_ptr->ifa_dstaddr);
	print_ip (" Destination", ifaddrs_ptr, addr_ptr);
    }

    /* Interface broadcast address */

    if (ifaddrs_ptr->ifa_broadaddr) {
	void * addr_ptr;

	addr_ptr = get_addr_ptr (ifaddrs_ptr->ifa_broadaddr);
	print_ip (" Broadcast", ifaddrs_ptr, addr_ptr);
    }
}

/* Adapted from http://publib.boulder.ibm.com/infocenter/iseries/v6r1m0/index.jsp?topic=/apis/getifaddrs.htm */
void print_ifaddrs (struct ifaddrs * ifaddrs_ptr)
{
    while (ifaddrs_ptr) {
        sprintf(&textblock[strlen(textblock)], "Name: %s; Flags: 0x%x; ",
                ifaddrs_ptr->ifa_name, ifaddrs_ptr->ifa_flags);

        /* Decide what to do based on the family. */

        if (ifaddrs_ptr->ifa_addr->sa_family == AF_INET) {

            /* AF_INET is defined in <sys/socket.h>. */

            print_internet_interface (ifaddrs_ptr);
        }
        else if (ifaddrs_ptr->ifa_addr->sa_family == AF_INET6) {
            print_internet_interface (ifaddrs_ptr);
        }
        else if (ifaddrs_ptr->ifa_addr->sa_family == AF_LINK) {
            print_af_link (ifaddrs_ptr);
        }

        /* Print a line between this entry and the next. */

        sprintf(&textblock[strlen(textblock)], "\n");

        ifaddrs_ptr = ifaddrs_ptr->ifa_next;
    }
}

void set_networkinfo(void)
{
	struct ifaddrs	*ifap, *ifa;
    struct  ifacelist
    {
        char    name[INTERFACE_NAME_LEN + 1];
        struct  ifacelist *next;
        
    } *il_start, *il_hlp, *il_search;

    memset(textblock, 0, sizeof textblock);

	getifaddrs(&ifap);

    /* Plocka fram unika interface för IP4/IP6 */
	ifa = ifap;
    il_start = NULL;
	while (ifa != 0)
	{
        if (ifa->ifa_addr->sa_family == AF_INET || ifa->ifa_addr->sa_family == AF_INET6)
		{
            if (il_start == NULL)
            {
                il_hlp = (struct ifacelist *) calloc(1, sizeof (struct ifacelist));
                strncpy(il_hlp->name, ifa->ifa_name, INTERFACE_NAME_LEN);
                il_hlp->next = NULL;
                il_start = il_hlp;
            }
            else
            {
                il_hlp = NULL;
                il_search = il_start;
                while (il_search != NULL && il_hlp == NULL)
                {
                    if (strncmp(il_search->name, ifa->ifa_name, INTERFACE_NAME_LEN) == 0)
                        il_hlp = il_search;
                    else if (il_search->next == NULL)
                    {
                        il_hlp = (struct ifacelist *) calloc(1, sizeof (struct ifacelist));
                        strncpy(il_hlp->name, ifa->ifa_name, INTERFACE_NAME_LEN);
                        il_hlp->next = NULL;
                        il_search->next = il_hlp;
                    }
                    else
                        il_search = il_search->next;
                }
            }
        }
		ifa = ifa->ifa_next;
    }

    /* Löp igenom unika interfacen */
    il_search = il_start;
    while (il_search != NULL)
    {
        if (il_search != il_start)
            sprintf(&textblock[strlen(textblock)], "\n");

        sprintf(&textblock[strlen(textblock)], "Interface: %s\n", il_search->name);

        /* Först macadress */
        ifa = ifap;
        while (ifa != 0)
        {
            if (strncmp(il_search->name, ifa->ifa_name, INTERFACE_NAME_LEN) == 0 && ifa->ifa_addr->sa_family == AF_LINK)
                print_af_link(ifa);
            ifa = ifa->ifa_next;
        }

        /* Sedan IP4 */
        ifa = ifap;
        while (ifa != 0)
        {
            if (strncmp(il_search->name, ifa->ifa_name, INTERFACE_NAME_LEN) == 0 && ifa->ifa_addr->sa_family == AF_INET)
            {
                sprintf(&textblock[strlen(textblock)], "IP4\n");
                print_internet_interface (ifa);
            }
            ifa = ifa->ifa_next;
        }

        /* Sist IP6 */
        ifa = ifap;
        while (ifa != 0)
        {
            if (strncmp(il_search->name, ifa->ifa_name, INTERFACE_NAME_LEN) == 0 && ifa->ifa_addr->sa_family == AF_INET6)
            {
                sprintf(&textblock[strlen(textblock)], "IP6\n");
                print_internet_interface (ifa);
            }
            ifa = ifa->ifa_next;
        }

        il_search = il_search->next;
    }

    /* Släpp listan */
    il_search = il_start;
    while (il_search != NULL)
    {
        il_hlp = il_search;
        il_search = il_search->next;
        free(il_hlp);
    }

    freeifaddrs(ifap);
}

char *get_networkinfo(void)
{
    return textblock;
}
