//
//  YMADateHelper.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 10.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADateHelper.h"

static NSString *const YMARSSDateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZ";
static NSString *const YMADateFormat = @"dd.MM.yy";
static NSString *const YMATimeFormat = @"HH:mm";

@implementation YMADateHelper

+ (NSString *)stringFromRSSDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMARSSDateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromRSSString:(NSString *)dateString {    
    //NSDateFormatter *formatter = [NSDateFormatter new];
    //[formatter setDateFormat:YMARSSDateFormat];
    //return [formatter dateFromString:dateString];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSLog(@"DateObject : %@", date);
    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMADateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMADateFormat];
    return [formatter dateFromString:dateString];
}

+ (NSString *)stringFromTime:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMATimeFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate *)timeFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMATimeFormat];
    return [formatter dateFromString:dateString];
}



@end
