//
//  TasksApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksApiManager.h"

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

-(void)syncTasksWithCompletion:(void (^)(bool))completed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed(true);
    });
}

@end
