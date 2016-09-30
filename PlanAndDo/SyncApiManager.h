//
//  SyncApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiManager.h"
#import "KSAuthorisedUser.h"
#import <UIKit/UIKit.h>

@interface SyncApiManager : ApiManager

-(void) syncStatusWithCompletion:(void (^)(NSDictionary*))completed;

@end
