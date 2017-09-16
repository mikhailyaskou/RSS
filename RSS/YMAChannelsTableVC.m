//
//  YMAChannelsTableVC.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <MagicalRecord/MagicalRecord.h>
#import "YMAChannelsTableVC.h"
#import "YMARSSChannel+CoreDataClass.h"
#import "YMASAXParser.h"
#import "YMAController.h"

@interface YMAChannelsTableVC ()


@property (strong, nonatomic) NSArray *channels;

@end

@implementation YMAChannelsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
        YMAController *controller = [YMAController new];

    [controller addChannelWithURL:[NSURL URLWithString:@"https://lenta.ru/rss/news"]];
   // [controller addChannelWithURL:[NSURL URLWithString:@"https://news.tut.by/rss/index.rss"]];
    
    
    self.channels = [YMARSSChannel MR_findAll];

}


@end
