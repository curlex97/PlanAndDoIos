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

-(void)addTaskAsync:(BaseTask*)task forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;;

-(void)updateTaskAsync:(BaseTask*)task forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;;

-(void)deleteTaskAsync:(BaseTask*)task forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;;

@end
