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


-(void) toServerWithMethod:(NSString*)method andSubTasks:(NSArray *)subTasks toTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    NSMutableArray* data = [NSMutableArray array];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    for(KSShortTask* sub in subTasks)
    {
        NSMutableDictionary* dataSubTask = [NSMutableDictionary dictionary];
        int isDel = [method isEqualToString:@"deleteMany"];
        int isComp = sub.status;
        
        [dataSubTask setValue:[NSNumber numberWithInt:sub.ID] forKey:@"id"];
        [dataSubTask setValue:[NSNumber numberWithInt:task.ID] forKey:@"task_id"];
        [dataSubTask setValue:sub.name forKey:@"name"];
        [dataSubTask setValue:[NSNumber numberWithInt:isComp] forKey:@"is_completed"];
        [dataSubTask setValue:[NSNumber numberWithInt:isDel] forKey:@"is_deleted"];
        [dataSubTask setValue:[NSNumber numberWithInteger:sub.syncStatus] forKey:@"subtask_sync_status"];

        [data addObject:dataSubTask];
    }
    
    if(data.count)
    {
        [dic setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
        [dic setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
        [dic setValue:[FileManager readTokenFromFile] forKey:@"token"];
        [dic setValue:@"subtask" forKey:@"class"];
        [dic setValue:method forKey:@"method"];
        [dic setValue:data forKey:@"data"];
        
        [self dataByData:dic completion:^(NSData * data) {
            
            if(data)
            {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if(completed) completed(json);
                if(!json)
                {
                    NSString* str = [NSString stringWithUTF8String:[data bytes]];
                    str = @"";
                }
            }
            
            
        }];
    }
    
    
}


-(void)addSubTasksAsync:(NSArray *)subTasks toTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"addMany" andSubTasks:subTasks toTask:task forUser:user completion:completed];
}

-(void)updateSubTasksAsync:(NSArray *)subTasks inTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"updateMany" andSubTasks:subTasks toTask:task forUser:user completion:completed];
}

-(void)deleteSubTasksAsync:(NSArray *)subTasks fromTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"deleteMany" andSubTasks:subTasks toTask:task forUser:user completion:completed];
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
    
    [self dataByData:puser completion:^(NSData * data)
    {
        if(!data)
        {
            completed(nil);
            return;
        }
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}

@end
