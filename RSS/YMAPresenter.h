//
//  YMAPresenter.h
//  RSS
//
//  Created by Mikhail Yaskou on 18.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMARSSItem;

@interface YMAPresenter : NSObject

@property (nonatomic, strong) NSArray<YMARSSItem *> *items;

+ (YMAPresenter *)sharedInstance;

@end
