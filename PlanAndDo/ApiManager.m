//
//  ApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"

@implementation ApiManager

-(void)dataByData:(NSDictionary *)data completion:(void (^)(NSData *))completed
{
    [ACNetworkManager dataByUrlAsync:@"https://plan-and-do.pro/api" andHeaderDictionary:@{} andBodyDictionary:data andQueryType:@"POST" completion:^(NSData* data) {
        completed(data);
    }];
}

@end
