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


-(void) toServerWithMethod:(NSString*)method andTasks:(NSArray *)tasks forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    NSMutableArray* data = [NSMutableArray array];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    for(BaseTask* task in tasks)
    {
        NSMutableDictionary* dataTask = [NSMutableDictionary dictionary];
        
        NSNumber* catID = task.categoryID > 0 ? [NSNumber numberWithInt:task.categoryID] : nil;
        NSNumber* taskType = [task isKindOfClass:[KSTask class]] ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
        NSString* taskDesc = [task isKindOfClass:[KSTask class]] ? ((KSTask*)task).taskDescription : nil;
        int createdAt = task.createdAt.timeIntervalSince1970 >= [NSDate date].timeIntervalSince1970 ? task.createdAt.timeIntervalSince1970 : [NSDate date].timeIntervalSince1970;
        int taskRemTime = task.taskReminderTime.timeIntervalSince1970 >= [NSDate date].timeIntervalSince1970 ? task.taskReminderTime.timeIntervalSince1970 : [NSDate date].timeIntervalSince1970;
        int compTime = task.completionTime.timeIntervalSince1970 >= [NSDate date].timeIntervalSince1970 ? task.completionTime.timeIntervalSince1970 : [NSDate date].timeIntervalSince1970;
        int isDel = NO;
        int isComp = task.status;
        
        [dataTask setValue:[NSNumber numberWithInteger:task.ID] forKey:@"id"];
        [dataTask setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
        [dataTask setValue:catID forKey:@"category_id"];
        [dataTask setValue:taskType forKey:@"task_type"];
        [dataTask setValue:task.name forKey:@"task_name"];
        [dataTask setValue:taskDesc forKey:@"task_description"];
        [dataTask setValue:[NSNumber numberWithInt:createdAt] forKey:@"created_at"];
        [dataTask setValue:[NSNumber numberWithInt:taskRemTime] forKey:@"task_reminder_time"];
        [dataTask setValue:[NSNumber numberWithInt:task.priority] forKey:@"task_priority"];
        [dataTask setValue:[NSNumber numberWithInt:isComp] forKey:@"is_completed"];
        [dataTask setValue:[NSNumber numberWithInt:compTime] forKey:@"task_completion_time"];
        [dataTask setValue:[NSNumber numberWithInt:isDel] forKey:@"is_deleted"];
        [dataTask setValue:[NSNumber numberWithInt:(int)task.syncStatus] forKey:@"task_sync_status"];
        
        [data addObject:dataTask];
    }
    
    [dic setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
    [dic setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [dic setValue:[FileManager readTokenFromFile] forKey:@"token"];
    [dic setValue:@"task" forKey:@"class"];
    [dic setValue:method forKey:@"method"];
    [dic setValue:data forKey:@"data"];
    
    [self dataByData:dic completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}

-(void)addTasksAsync:(NSArray *)tasks forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"addMany" andTasks:tasks forUser:user completion:completed];
}

-(void)updateTasksAsync:(NSArray *)tasks forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"updateMany" andTasks:tasks forUser:user completion:completed];
}

-(void)deleteTasksAsync:(NSArray *)tasks forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    [self toServerWithMethod:@"deleteMany" andTasks:tasks forUser:user completion:completed];
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
        if(completed) completed(json);
    }];
}

@end
