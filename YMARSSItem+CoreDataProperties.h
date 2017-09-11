//
//  YMARSSItem+CoreDataProperties.h
//  RSS
//
//  Created by Mikhail Yaskou on 09.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMARSSItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMARSSItem (CoreDataProperties)

+ (NSFetchRequest<YMARSSItem *> *)fetchRequest;

@property (nonatomic) int16_t id;
@property (nonatomic) int16_t channelid;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *topic;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, retain) NSObject *image;
@property (nullable, nonatomic, retain) YMARSSChannel *channel;

@end

NS_ASSUME_NONNULL_END
