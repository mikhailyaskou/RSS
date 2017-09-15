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
#import "YMAChannelCell.h"
#import "YMASAXParser.h"
#import "YMAController.h"

@interface YMAChannelsTableVC ()


@property (strong, nonatomic) NSArray *channels;

@end

@implementation YMAChannelsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
        YMAController *controller = [YMAController new];

    [controller addChannelWithURL:[NSURL URLWithString:@"https://news.tut.by/rss/all.rss"]];
    
    self.channels = [YMARSSChannel MR_findAll];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.channels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMACellChannelIdentifier" forIndexPath:indexPath];
    YMARSSChannel *channel = [self.channels objectAtIndex:indexPath.row];
    cell.title.text = channel.title;
    cell.image.image = [UIImage imageWithData:[(YMARSSChannel*) self.channels[indexPath.row] image]] ;
   
    
    return cell;
}


@end
