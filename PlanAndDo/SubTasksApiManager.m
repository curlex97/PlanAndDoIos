//
//  SubTasksApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksApiManager.h"

@implementation SubTasksApiManager

-(void)addSubTaskAsync:(KSShortTask *)subTask toTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}

-(void)updateSubTaskAsync:(KSShortTask *)subTask inTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}

-(void)deleteSubTaskAsync:(KSShortTask *)subTask fromTask:(KSTaskCollection *)task forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}


-(void)syncSubTasksWithCompletion:(void (^)(bool))completed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed(true);
    });
}

@end
