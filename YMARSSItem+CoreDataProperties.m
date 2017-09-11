//
//  YMARSSItem+CoreDataProperties.m
//  RSS
//
//  Created by Mikhail Yaskou on 09.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMARSSItem+CoreDataProperties.h"

@implementation YMARSSItem (CoreDataProperties)

+ (NSFetchRequest<YMARSSItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"YMARSSItem"];
}

@dynamic id;
@dynamic channelid;
@dynamic title;
@dynamic link;
@dynamic date;
@dynamic topic;
@dynamic category;
@dynamic image;
@dynamic channel;

@end
