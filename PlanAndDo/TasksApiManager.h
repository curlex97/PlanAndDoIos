//
//  TasksApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSTask.h"
#import "KSTaskCollection.h"
#import "KSAuthorisedUser.h"

@interface TasksApiManager : ApiManager

-(void)addTasksAsync:(NSArray*)tasks forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;;

-(void)updateTasksAsync:(NSArray*)tasks forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void)deleteTasksAsync:(NSArray*)tasks forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void) syncTasksWithCompletion:(void (^)(NSDictionary*))completed;

@end
