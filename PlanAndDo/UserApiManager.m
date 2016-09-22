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

-(void)loginAsyncWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(bool))completed
{
    
}

-(void) registerAsyncWithEmail:(NSString*)email andUserName:(NSString*)userName andPassword:(NSString*)password completion:(void (^)(NSDictionary*))completed
{
    NSMutableDictionary* user = [NSMutableDictionary dictionary];
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    
    [data setValue:userName forKey:@"name"];
    [data setValue:email forKey:@"email"];
    [data setValue:password forKey:@"password"];
    
    [user setValue:@"" forKey:@"user_id"];
    [user setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [user setValue:@"" forKey:@"token"];
    [user setValue:@"user" forKey:@"class"];
    [user setValue:@"register" forKey:@"method"];
    [user setValue:data forKey:@"data"];
    
    [self dataByData:user completion:^(NSData * data) {
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        completed(json);
    }];
}

@end
