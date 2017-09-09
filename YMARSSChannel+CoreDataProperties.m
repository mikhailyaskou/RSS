//
//  YMARSSChannel+CoreDataProperties.m
//  RSS
//
//  Created by Mikhail Yaskou on 09.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMARSSChannel+CoreDataProperties.h"

@implementation YMARSSChannel (CoreDataProperties)

+ (NSFetchRequest<YMARSSChannel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"YMARSSChannel"];
}

@dynamic id;
@dynamic title;
@dynamic link;
@dynamic url;
@dynamic topic;
@dynamic image;
@dynamic items;

@end
