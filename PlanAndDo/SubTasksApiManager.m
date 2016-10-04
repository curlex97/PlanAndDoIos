//
//  SubTasksApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksApiManager.h"
#import "UserApplicationManager.h"
#import "FileManager.h"


@implementation SubTasksApiManager

-(void)addSubTasksAsync:(NSArray *)subTasks toTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{

}

-(void)updateSubTasksAsync:(NSArray *)subTasks inTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{

}

-(void)deleteSubTasksAsync:(NSArray *)subTasks fromTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{

}


-(void)syncSubTasksWithCompletion:(void (^)(NSDictionary*))completed
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
    [puser setValue:@"syncSubtasks" forKey:@"method"];
    
    [puser setValue:inData forKey:@"data"];
    
    [self dataByData:puser completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}

@end
