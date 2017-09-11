//
//  YMARSSChannel+CoreDataProperties.h
//  RSS
//
//  Created by Mikhail Yaskou on 09.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMARSSChannel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMARSSChannel (CoreDataProperties)

+ (NSFetchRequest<YMARSSChannel *> *)fetchRequest;

@property (nonatomic) int16_t id;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *topic;
@property (nullable, nonatomic, retain) NSObject *image;
@property (nullable, nonatomic, retain) NSSet<YMARSSItem *> *items;

@end

@interface YMARSSChannel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(YMARSSItem *)value;
- (void)removeItemsObject:(YMARSSItem *)value;
- (void)addItems:(NSSet<YMARSSItem *> *)values;
- (void)removeItems:(NSSet<YMARSSItem *> *)values;

@end

NS_ASSUME_NONNULL_END
