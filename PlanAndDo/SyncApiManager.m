//
//  SyncApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SyncApiManager.h"
#import "ApplicationDefines.h"
#import "FileManager.h"

@implementation SyncApiManager

-(void) syncStatusWithUser:(KSAuthorisedUser*)user andCompletion:(void (^)(NSDictionary*))completed
{
    
    NSMutableDictionary* puser = [NSMutableDictionary dictionary];
    NSMutableDictionary* inData = [NSMutableDictionary dictionary];
    
    NSNumber *number = [NSNumber numberWithInteger:[[FileManager readLastSyncTimeFromFile] intValue]];
    
    [inData setValue:number forKey:@"lst"];
    
    [puser setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
    [puser setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [puser setValue:[FileManager readTokenFromFile] forKey:@"token"];
    [puser setValue:@"sync" forKey:@"class"];
    [puser setValue:@"startSync" forKey:@"method"];
    
    [puser setValue:inData forKey:@"data"];
    
    [self dataByData:puser completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        completed(json);
    }];
    
    
}


@end
