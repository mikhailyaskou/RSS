//
//  YMARSSItem+CoreDataProperties.m
//  
//
//  Created by Mikhail Yaskou on 11.09.17.
//
//

#import "YMARSSItem+CoreDataProperties.h"

@implementation YMARSSItem (CoreDataProperties)

+ (NSFetchRequest<YMARSSItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"YMARSSItem"];
}

@dynamic category;
@dynamic channelid;
@dynamic date;
@dynamic id;
@dynamic imageUrl;
@dynamic link;
@dynamic title;
@dynamic topic;
@dynamic channel;

@end
