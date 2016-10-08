//
//  CategoryApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryApiManager.h"
#import "FileManager.h"
#import "UserApplicationManager.h"

@implementation CategoryApiManager


-(void)toServerWithMethod:(NSString*)method andCategories:(NSArray *)categories forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    NSMutableArray* data = [NSMutableArray array];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    for(KSCategory* category in categories)
    {
        NSMutableDictionary* dataCategory = [NSMutableDictionary dictionary];
        int isDel = [method isEqualToString:@"deleteMany"];
        
        [dataCategory setValue:[category name] forKey:@"category_name"];
        [dataCategory setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
        [dataCategory setValue:[NSNumber numberWithInt:isDel] forKey:@"is_deleted"];
        [dataCategory setValue:[NSNumber numberWithInteger:[category syncStatus]] forKey:@"category_sync_status"];

        [data addObject:dataCategory];
    }
    
    [dic setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
    [dic setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [dic setValue:[FileManager readTokenFromFile] forKey:@"token"];
    [dic setValue:@"category" forKey:@"class"];
    [dic setValue:method forKey:@"method"];
    [dic setValue:data forKey:@"data"];
    
    [self dataByData:dic completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
        if(!json)
        {
            NSString* str = [NSString stringWithUTF8String:[data bytes]];
            str = @"";
        }
    }];
}

-(void)addCategoriesAsync:(NSArray *)categories forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"addMany" andCategories:categories forUser:user completion:completed];
}

-(void)updateCategoriesAsync:(NSArray *)categories forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"updateMany" andCategories:categories forUser:user completion:completed];
}

-(void)deleteCategoriesAsync:(NSArray *)categories forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"deleteMany" andCategories:categories forUser:user completion:completed];
}

-(void)syncCategoriesWithCompletion:(void (^)(NSDictionary*))completed
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
    [puser setValue:@"syncCategories" forKey:@"method"];
    
    [puser setValue:inData forKey:@"data"];
    
    [self dataByData:puser completion:^(NSData * data)
    {
        if(!data)
        {
            completed(nil);
            return;
        }
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
       if(completed)  completed(json);
    }];
}

@end
