//
//  SubTasksApplicationManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSShortTask.h"
#import "KSTaskCollection.h"
#import "SubTasksApiManager.h"
#import "SubTasksCoreDataManager.h"

@interface SubTasksApplicationManager : NSObject

-(NSArray<KSShortTask*>*) allSubTasksForTask:(KSTaskCollection*)task;

-(void)addSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task completion:(void (^)(bool))completed;

-(void)updateSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task completion:(void (^)(bool))completed;

-(void)deleteSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task completion:(void (^)(bool))completed;

-(void) cleanTable;

-(void) recieveSubTasksFromDictionary:(NSDictionary*)dictionary;


@end
