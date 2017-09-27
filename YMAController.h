//
//  YMAController.h
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int YMAInitialSelectedIndex = 0;

@class YMARSSItem;

@interface YMAController : NSObject

@property (nonatomic, copy) NSArray<YMARSSItem *> *rssItems;
@property (nonatomic, strong) NSNumber *selectedChannelIndex;
@property (nonatomic, strong) NSNumber *selectedCategoryIndex;
@property (nonatomic, assign, getter=isUpdateInProgress) BOOL updateInProgress;

+ (YMAController *)sharedInstance;

- (void)setObserverForRSSItems:(id)observer;
- (void)removeObserverForRSSItems:(id)observer;
- (void)setObserverForUpdateProgress:(id)observer;
- (void)removeObserverForUpdateProgress:(id)observer;
- (void)loadChannelWithURL:(NSURL *)url;
- (void)applySelectedParameters;
- (void)updateChannelForIndex:(NSNumber *)index;
- (void)updateSelectedChannel;
- (void)updateChannelForIndex:(NSNumber *)index withCompletionBlock:(nullable void (^)())completion;
- (void)updateSelectedChannelWithCompletionBlock:(nullable void (^)())completion;

@end
