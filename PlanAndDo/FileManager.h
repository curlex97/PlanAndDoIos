//
//  FileManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(void) writeLastSyncTimeToFile:(NSString*)token;

+(NSString*) readLastSyncTimeFromFile;
+(NSString*) readTokenFromFile;

+(void) writeTokenToFile:(NSString*)token;

@end
