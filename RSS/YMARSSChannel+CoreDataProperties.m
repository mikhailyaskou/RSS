//
//  YMARSSChannel+CoreDataProperties.m
//  
//
//  Created by Mikhail Yaskou on 19.09.17.
//
//

#import "YMARSSChannel+CoreDataProperties.h"

@implementation YMARSSChannel (CoreDataProperties)

+ (NSFetchRequest<YMARSSChannel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"YMARSSChannel"];
}

@dynamic id;
@dynamic image;
@dynamic lastUpdate;
@dynamic link;
@dynamic title;
@dynamic topic;
@dynamic url;
@dynamic items;

@end
