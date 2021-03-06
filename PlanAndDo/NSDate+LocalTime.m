//
//  NSDate+LocalTime.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 23.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "NSDate+LocalTime.h"
#import "ApplicationDefines.h"

@implementation NSDate (LocalTime)

-(NSDate*) localDate
{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:DT_ABBREVIATION_ZONE];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
}

@end
