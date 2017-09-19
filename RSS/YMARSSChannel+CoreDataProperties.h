//
//  YMARSSChannel+CoreDataProperties.h
//  
//
//  Created by Mikhail Yaskou on 19.09.17.
//
//

#import "YMARSSChannel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMARSSChannel (CoreDataProperties)

+ (NSFetchRequest<YMARSSChannel *> *)fetchRequest;

@property (nonatomic) int16_t id;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *topic;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSDate *lastUpdate;
@property (nullable, nonatomic, retain) NSSet<YMARSSItem *> *items;

@end

@interface YMARSSChannel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(YMARSSItem *)value;
- (void)removeItemsObject:(YMARSSItem *)value;
- (void)addItems:(NSSet<YMARSSItem *> *)values;
- (void)removeItems:(NSSet<YMARSSItem *> *)values;

@end

NS_ASSUME_NONNULL_END
