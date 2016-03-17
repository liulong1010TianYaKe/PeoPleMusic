//
//  NSString+IPAddress.m
//  JuMi
//
//  Created by Kyo on 17/6/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "NSString+IPAddress.h"
#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#import <arpa/inet.h>
#import <netdb.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <dlfcn.h>
//#import "wwanconnect.h//frome apple 你可能没有哦
#import <SystemConfiguration/SystemConfiguration.h>

#define kPingUrl    @"http://www.baidu.com/"

@implementation NSString (IPAddress)

//
//+ (NSString *)macAddress {
//    int                    mib[6];
//    size_t                len;
//    char                *buf;
//    unsigned char        *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl    *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1/n");
//        return NULL;
//    }
//    
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        return NULL;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    // NSString *outstring = [NSString stringWithFormat:@"x:x:x:x:x:x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    NSString *outstring = [NSString stringWithFormat:@"%x%x%x%x%x%x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
//    return [outstring uppercaseString];
//}

//这是外网可见的ip地址，如果你在小区的局域网中，那就是小区的，不是局域网的内网地址。
//+ (NSString *)whatIsMyIpDotCom {
//    NSError *error;
//    NSURL *ipURL = [NSURL URLWithString:kPingUrl];
//    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
//    return ip ? ip : [error localizedDescription];
//}

//这是获取本地wifi的ip地址
+ (NSString *)localWiFiIPAddressAndPort {
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    
                    return [NSString stringWithFormat:@"%@:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)],[NSString stringWithFormat: @"%tu", ((struct sockaddr_in *)cursor)->sin_port]];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return @"";
}

//NSString和Address的转换
+ (NSString *)stringFromAddress:(const struct sockaddr *)address {
    if(address && address->sa_family == AF_INET) {
        const struct sockaddr_in* sin = (struct sockaddr_in*) address;
        return [NSString stringWithFormat:@"%@:%d", [NSString stringWithUTF8String:inet_ntoa(sin->sin_addr)], ntohs(sin->sin_port)];
    }
    
    return nil;
}

//比较字符串ip和scokaddr_in是否是相同的ip地址
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address {
    if (!IPAddress || ![IPAddress length]) {
        return NO;
    }
    
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
    
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
        NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
    
    return YES;
}

//获取host的名称
+ (NSString *)hostname {
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}


//从host获取地址
+ (NSString *)getIPAddressForHost:(NSString *)theHost {
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {
        herror("resolv");
        return NULL;
    }
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}

//这是本地host的IP地址
+ (NSString *)localIPAddress {
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

@end
