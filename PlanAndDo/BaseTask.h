//
//  BaseTask.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSShortTask.h"

typedef NS_ENUM(NSInteger, KSTaskPriority)
{
    KSTaskDefaultPriority=1,
    KSTaskHighPriority,
    KSTaskVeryHighPriority
};

@interface BaseTask : KSShortTask

@property (nonatomic)BOOL isRemind;
@property (nonatomic) NSDate* taskReminderTime;
@property (nonatomic)KSTaskPriority priority;
@property (nonatomic)int categoryID;
@property (nonatomic)NSDate* createdAt;
@property (nonatomic)NSDate* completionTime;

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name
                      andStatus:(BOOL)status
            andTaskReminderTime:(NSDate*) taskReminderTime
                andTaskPriority:(KSTaskPriority)priority
            andCategoryID:(int)categoryID
             andCreatedAt:(NSDate*)createdAt
        andCompletionTime:(NSDate*)completionTime
                  andSyncStatus:(int)syncStatus;
@end
