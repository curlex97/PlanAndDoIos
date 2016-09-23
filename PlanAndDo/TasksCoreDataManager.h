//
//  TasksCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "BaseTask.h"
#import "KSTask.h"
#import "KSTaskCollection.h"
#import "KSCategory.h"

@interface TasksCoreDataManager : CoreDataManager

// test 1 OK
-(NSArray<BaseTask *>*) allTasks;

// test 1 OK
-(NSArray<BaseTask *>*) allTasksForToday;

// test 1 OK
-(NSArray<BaseTask *>*) allTasksForTomorrow;

// test 1 OK
-(NSArray<BaseTask *>*) allTasksForWeek;

// test 1 OK
-(NSArray<BaseTask *>*) allTasksForArchive;

// test 1 OK
-(NSArray<BaseTask *>*) allTasksForBacklog;

// test 1 OK
-(NSArray<BaseTask *>*) allTasksForCategory:(KSCategory*)category;

// test 1 OK
-(BaseTask*)taskWithId:(int)Id;

// test 1 OK
-(void) updateTask:(BaseTask*)task;

// test 1 OK
-(void)addTask:(BaseTask*)task;

// test 1 OK
-(void)deleteTask:(BaseTask*)task;

-(void)cleanTable;

@end
