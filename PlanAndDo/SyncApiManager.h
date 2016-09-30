//
//  SyncApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncApiManager : NSObject

-(void) syncStatusWithCompletion:(void (^)(bool))completed;


@end
