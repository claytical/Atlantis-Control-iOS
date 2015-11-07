//
//  AppDelegate.m
//  Atlantis Control
//
//  Created by Clay Ewing on 9/24/15.
//  Copyright (c) 2015 NERDLab. All rights reserved.
//

#import "AppDelegate.h"
#include <arpa/inet.h>

@interface AppDelegate () <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    NSNetServiceBrowser* browser;
    NSMutableArray* services;
    
}

//@property (strong) NERDLabServer* server;
//@property (strong) NERDLabClient* client;
@end

@implementation AppDelegate

@synthesize window = _window, player_name;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //BONJOUR
    services = [[NSMutableArray alloc] init];
    browser = [[NSNetServiceBrowser alloc] init];
    browser.delegate = self;
    [browser searchForServicesOfType:@"._tcp" inDomain:@"local."];

    serverList = [[NSMutableArray alloc] init];
    [self searchForBonjourServices];

    
    //OSC
    self.server = [[NERDLabServer alloc] initWithPort:9001];
    self.server.app = self;
    [self.server start];
    
    self.client = [[NERDLabClient alloc] initWithPort:9000];
    self.client.app = self;
    
}

-(void) setClientHost: (NSString *) host {
    [self.client setHost:host];
}

- (void)searchForBonjourServices
{
   // [browser searchForServicesOfType:@"_services._dns-sd._udp." inDomain:@""];
    
        [browser searchForServicesOfType:@"_nerdlab._tcp." inDomain:@"local."];
    
    NSLog(@"Searching for services");
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    
    [services addObject:aNetService];
    
    aNetService.delegate = self;
    [aNetService resolveWithTimeout:5];
    
    NSLog(@"Found a service: %@", aNetService);
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    
    [services removeObject:aNetService];
    NSLog(@"A service was removed: %@", aNetService);
    
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {

//    NSLog(@"Resolved address for service %@", sender);
    for (NSData* data in [sender addresses]) {
        char addressBuffer[100];
        struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
        int sockFamily = socketAddress->sin_family;
        if (sockFamily == AF_INET) {
            const char* addressStr = inet_ntop(sockFamily,
                                               &(socketAddress->sin_addr), addressBuffer,
                                               sizeof(addressBuffer));
            
            int port = ntohs(socketAddress->sin_port);
            if (addressStr && port) {
                NSLog(@"Found service at %s:%d", addressStr, port);
                NSMutableDictionary *service = [[NSMutableDictionary alloc] init];
                [service setObject:[NSString stringWithUTF8String:addressStr] forKey:@"ip"];
                [service setObject:sender.hostName forKey:@"host"];
                [service setObject:[NSNumber numberWithInteger:sender.port] forKey:@"port"];
            
                /*
                NSDictionary *service = [[NSDictionary alloc] initWithObjectsAndKeys:sender.hostName, @"host", [NSString stringWithUTF8String:addressStr], @"ip", sender.port, @"port", nil];
                 */
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nerdlabServerFound" object:nil userInfo:service];
               
            }
        }
    }

    
    
    
}

- (CMMotionManager *)motionManager
{
    if (!motionManager) motionManager = [[CMMotionManager alloc] init];
    
    return motionManager;
}

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Couldn't resolve address for service %@: %@", sender, errorDict);
}




@end