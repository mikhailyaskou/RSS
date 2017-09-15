//
//  YMAController.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "YMAController.h"
#import "YMARSSChannel+CoreDataClass.h"
#import "YMASAXParser.h"

@implementation YMAController


- (void) addChannelWithURL:(NSURL *)url {

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        YMARSSChannel *channel = [YMARSSChannel MR_createEntityInContext:localContext];
        YMASAXParser *parser = [[YMASAXParser alloc] initWithContext:localContext];
        [parser parseRSSChannelWithURL:url inCoreDataMOChannel:channel];
        NSLog(@"%u",[[channel items] count]);

    } completion:^(BOOL success, NSError *error) {
        
      }];
}



- (void) updateAllChannels {

//    NSArray *

}

- (void) updateChannel:(YMARSSChannel *)channel {

    [self deleteAllItemsFromChannel:channel];
    YMASAXParser *parser = [YMASAXParser new];
    NSURL *url = [[NSURL alloc] initWithString:channel.url];
    [parser parseRSSChannelWithURL:url inCoreDataMOChannel:channel];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        YMARSSChannel *localChanel = [channel MR_inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        if (success){
            NSLog(@"MO saved");
        }else{
            NSLog(@"MO save error");
        }

    }];




}

- (void) deleteAllItemsFromChannel:(YMARSSChannel *)channel {
    [channel removeItems:channel.items];
}



@end
