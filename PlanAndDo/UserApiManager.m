//
//  UserApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserApiManager.h"
#import "FileManager.h"
#import "UserApplicationManager.h"

@implementation UserApiManager

-(void)updateUserAsync:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{

}

-(void)loginAsyncWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSDictionary*))completed
{
    NSMutableDictionary* user = [NSMutableDictionary dictionary];
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    
    [data setValue:email forKey:@"email"];
    [data setValue:password forKey:@"password"];
    
    [user setValue:@"" forKey:@"user_id"];
    [user setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [user setValue:@"" forKey:@"token"];
    [user setValue:@"user" forKey:@"class"];
    [user setValue:@"login" forKey:@"method"];
    [user setValue:data forKey:@"data"];
    
    [self dataByData:user completion:^(NSData * data) {
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}

-(void) registerAsyncWithEmail:(NSString*)email andUserName:(NSString*)userName andPassword:(NSString*)password completion:(void (^)(NSDictionary*))completed
{
    NSMutableDictionary* user = [NSMutableDictionary dictionary];
    NSMutableDictionary* inputData = [NSMutableDictionary dictionary];
    
    [inputData setValue:userName forKey:@"name"];
    [inputData setValue:email forKey:@"email"];
    [inputData setValue:password forKey:@"password"];
    
    [user setValue:@"" forKey:@"user_id"];
    [user setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [user setValue:@"" forKey:@"token"];
    [user setValue:@"user" forKey:@"class"];
    [user setValue:@"register" forKey:@"method"];
    [user setValue:inputData forKey:@"data"];
    
    [self dataByData:user completion:^(NSData * data) {
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}

-(void)logout
{
    
}

-(void)syncUserWithCompletion:(void (^)(NSDictionary*))completed
{
    KSAuthorisedUser* user = [[[UserApplicationManager alloc] init] authorisedUser];
    
    NSMutableDictionary* puser = [NSMutableDictionary dictionary];
    NSMutableDictionary* inData = [NSMutableDictionary dictionary];
    
    NSNumber *number = [NSNumber numberWithInteger:[[FileManager readLastSyncTimeFromFile] intValue]];
    
    [inData setValue:number forKey:@"lst"];
    
    [puser setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
    [puser setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [puser setValue:[FileManager readTokenFromFile] forKey:@"token"];
    [puser setValue:@"sync" forKey:@"class"];
    [puser setValue:@"syncUsers" forKey:@"method"];
    
    [puser setValue:inData forKey:@"data"];
    
    [self dataByData:puser completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}


@end
