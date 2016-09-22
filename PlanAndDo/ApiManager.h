//
//  ApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACNetworkManager.h"

@interface ApiManager : NSObject

-(void)dataByData:(NSDictionary*)data completion:(void (^)(NSData*))completed;

@end
