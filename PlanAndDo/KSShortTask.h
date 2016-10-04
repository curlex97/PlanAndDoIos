//
//  KSShortTask.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSObject.h"

@interface KSShortTask : KSObject

@property (nonatomic)NSString * name;
@property (nonatomic)BOOL status;

-(instancetype)initWithID:(int)ID andName:(NSString *)name andStatus:(BOOL)status  andSyncStatus:(int)syncStatus;
@end
