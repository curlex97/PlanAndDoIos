//
//  ApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "ApplicationDefines.h"

@implementation ApiManager

-(void)dataByData:(NSDictionary *)data completion:(void (^)(NSData *))completed
{
    [ACNetworkManager dataByUrlAsync:URL_API andHeaderDictionary:@{} andBodyDictionary:data andQueryType:URL_SENDTYPE completion:^(NSData* data) {
        completed(data);
    }];
}

@end
