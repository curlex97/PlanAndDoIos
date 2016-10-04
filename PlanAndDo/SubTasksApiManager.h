//
//  SubTasksApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSShortTask.h"
#import "KSTaskCollection.h"
#import "KSTask.h"
#import "KSAuthorisedUser.h"

@interface SubTasksApiManager : ApiManager

-(void)addSubTasksAsync:(NSArray*)subTasks toTask:(KSTaskCollection*)task forUser:(KSAuthorisedUser*)user completion:(void (^)(NSDictionary*))completed;

-(void)updateSubTasksAsync:(NSArray*)subTasks inTask:(KSTaskCollection*)task forUser:(KSAuthorisedUser*)user completion:(void (^)(NSDictionary*))completed;

-(void)deleteSubTasksAsync:(NSArray*)subTasks fromTask:(KSTaskCollection*)task forUser:(KSAuthorisedUser*)user completion:(void (^)(NSDictionary*))completed;

-(void) syncSubTasksWithCompletion:(void (^)(NSDictionary*))completed;

@end
