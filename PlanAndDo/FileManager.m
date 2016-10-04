//
//  FileManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "FileManager.h"

#import "ApplicationDefines.h"

@implementation FileManager


+(void) writeTokenToFile:(NSString*)token
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_TOKEN];
    [token writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*) readTokenFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_TOKEN];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


+(void) writeLastSyncTimeToFile:(NSString*)token
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_LAST_SYNC_TIME];
    [token writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*) readLastSyncTimeFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_LAST_SYNC_TIME];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+(void) writePassToFile:(NSString*)token
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_PASS];
    [token writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*) readPassFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_PASS];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+(void) writeUserEmailToFile:(NSString*)token
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_EMAIL];
    [token writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*) readUserEmailFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:FS_EMAIL];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+(void)clearLocalData
{
    [FileManager writePassToFile:@""];
    [FileManager writeTokenToFile:@""];
    [FileManager writeUserEmailToFile:@""];
    [FileManager writeLastSyncTimeToFile:@""];
}
@end
