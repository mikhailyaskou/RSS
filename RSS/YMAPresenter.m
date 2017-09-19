//
//  YMAPresenter.m
//  RSS
//
//  Created by Mikhail Yaskou on 18.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAPresenter.h"
#import "YMARSSItem+CoreDataClass.h"

@interface YMAPresenter ()



@end

@implementation YMAPresenter

+ (YMAPresenter *)sharedInstance {
    static YMAPresenter *sharedInstance = nil;
    static dispatch_once_t *onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [YMAPresenter new];
    });
    return sharedInstance;
}






@end
