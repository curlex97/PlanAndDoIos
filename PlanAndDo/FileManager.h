//
//  FileManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(NSString*) readLastSyncTimeFromFile;
+(NSString*) readTokenFromFile;
+(NSString*) readPassFromFile;
+(NSString*) readUserEmailFromFile;

+(void) writeTokenToFile:(NSString*)token;
+(void) writeLastSyncTimeToFile:(NSString*)token;
+(void) writePassToFile:(NSString*)token;
+(void) writeUserEmailToFile:(NSString*)token;

+(void)clearLocalData;
@end
