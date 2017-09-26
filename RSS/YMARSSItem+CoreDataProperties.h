//
//  YMARSSItem+CoreDataProperties.h
//  
//
//  Created by Mikhail Yaskou on 19.09.17.
//
//

#import "YMARSSItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMARSSItem (CoreDataProperties)

+ (NSFetchRequest<YMARSSItem *> *)fetchRequest;

@property(nullable, nonatomic, copy) NSString *category;
@property(nonatomic) int16_t channelid;
@property(nullable, nonatomic, copy) NSDate *date;
@property(nonatomic) int16_t id;
@property(nullable, nonatomic, copy) NSString *imageUrl;
@property(nullable, nonatomic, copy) NSString *link;
@property(nullable, nonatomic, copy) NSString *title;
@property(nullable, nonatomic, copy) NSString *topic;
@property(nullable, nonatomic, retain) YMARSSChannel *channel;

@end

NS_ASSUME_NONNULL_END
