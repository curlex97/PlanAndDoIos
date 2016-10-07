//
//  TasksApplicationManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTask.h"
#import "KSTask.h"
#import "KSTaskCollection.h"
#import "KSCategory.h"
#import "TasksApiManager.h"
#import "TasksCoreDataManager.h"

@interface TasksApplicationManager : NSObject

-(NSArray<BaseTask *>*) allTasks;

-(NSArray<BaseTask *>*) allTasksForToday;

-(NSArray<BaseTask *>*) allTasksForTomorrow;

-(NSArray<BaseTask *>*) allTasksForWeek;

-(NSArray<BaseTask *>*) allTasksForArchive;

-(NSArray<BaseTask *>*) allTasksForBacklog;

-(NSArray<BaseTask *>*) allTasksForCategory:(KSCategory*)category;

-(BaseTask*)taskWithId:(int)Id;

-(void) updateTask:(BaseTask*)task completion:(void (^)(bool))completed;

-(void)addTask:(BaseTask*)task completion:(void (^)(bool))completed;

-(void)deleteTask:(BaseTask*)task completion:(void (^)(bool))completed;

-(void) cleanTable;

-(void) recieveTasksFromDictionary:(NSDictionary*)dictionary;

@end
