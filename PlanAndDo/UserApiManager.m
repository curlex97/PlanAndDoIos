//
//  UserApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserApiManager.h"

@implementation UserApiManager

-(void)updateUserAsync:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
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
        completed(json);
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
        completed(json);
    }];
}

-(void)logout
{
    
}

-(void)syncUserWithCompletion:(void (^)(NSDictionary*))completed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed(nil);
    });
}


@end
