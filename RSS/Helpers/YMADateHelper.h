//
//  YMADateHelper.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 10.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMADateHelper : NSObject

+ (NSString *)stringFromRSSDate:(NSDate *)date;

+ (NSDate *)dateFromRSSString:(NSString *)dateString;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)stringFromTime:(NSDate *)date;

+ (NSDate *)timeFromString:(NSString *)dateString;

@end
