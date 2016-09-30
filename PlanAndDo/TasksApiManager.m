//
//  TasksApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksApiManager.h"
#import "UserApplicationManager.h"
#import "FileManager.h"


@implementation TasksApiManager

-(void)addTaskAsync:(BaseTask *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}

-(void)updateTaskAsync:(BaseTask *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}

-(void)deleteTaskAsync:(BaseTask *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}

-(void)syncTasksWithCompletion:(void (^)(NSDictionary*))completed
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
    [puser setValue:@"syncTasks" forKey:@"method"];
    
    [puser setValue:inData forKey:@"data"];
    
    [self dataByData:puser completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        completed(json);
    }];
}

@end
