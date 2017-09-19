//
//  YMAController.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "YMAController.h"
#import "YMARSSChannel+CoreDataClass.h"
#import "YMASAXParser.h"
#import "YMARSSItem+CoreDataClass.h"
#import "Reachability.h"

@interface YMAController ()

@property (nonatomic, strong) NSDictionary *channelsDescription;
@property (nonatomic, strong) NSDictionary *categoryDescription;
@property (nonatomic, strong) NSArray<YMARSSItem *> *privateItems;

@end

@implementation YMAController

+ (YMAController *)sharedInstance {
    static YMAController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [YMAController new];
    });
    return _sharedInstance;
}

- (NSNumber *)selectedCategoryIndex {
    if (!_selectedCategoryIndex){
        _selectedCategoryIndex = @0;
    }
    return _selectedCategoryIndex;
}

- (NSNumber *)selectedChannelIndex {
    if (!_selectedChannelIndex){
       _selectedChannelIndex = @0;
    }
    return _selectedChannelIndex;
}

- (NSDictionary *)channelsDescription {
    if (!_channelsDescription) {
        _channelsDescription = @{   @0: @[@"http://people.onliner.by/feed",
        @"http://auto.onliner.by/feed", @"http://tech.onliner.by/feed", @"http://realt.onliner.by/feed"],
                                     @1 : @[
                        @"https://news.tut.by/rss/economics.rss", @"https://news.tut.by/rss/society.rss",
                        @"https://news.tut.by/rss/world.rss" ,@"https://news.tut.by/rss/culture.rss",
                        @"https://news.tut.by/rss/accidents.rss", @"https://news.tut.by/rss/finance.rss"
                        ,@"https://news.tut.by/rss/realty.rss", @"https://news.tut.by/rss/sport.rss",
                @"https://news.tut.by/rss/auto.rss"],
                                     @2 : @[@"http://lenta.ru/rss"]};
    }
    return _channelsDescription;
}

- (NSDictionary *)categoryDescription{
    if (!_categoryDescription) {
        _categoryDescription = @{ @0: @[@"Россия", @"Мир", @"Крым", @"Бывший СССР", @"Путешествия", @"В мире",
                @"Происшествия", @"Эксклюзив", @"Кругозор", @"События в мире" @"Городская жизнь", @"Проблемы", @"Новые места", @"Официально"],
                @1: @[@"Люди", @"Мнения", @"Из жизни", @"Интернет и СМИ", @"Культура" @"Социум",
                        @"Силовые структуры", @"Ценности", @"Культпросвет", @"Общество", @"Офтоп", @"Профессионалы", @"Закон и порядок", @"Деревня"],
                @2: @[@"Недвижимость", @"Архитектура", @"Интерьер"],
                @3: @[@"Авто", @"Автобизнес", @"Дорога", @"Аварии", @"Дорожная обстановка",
                        @"Разбор с Красновым"],
                @4: @[@"Наука и техника", @"69-я параллель", @"Наука", @"Гаджеты и вендоры", @"Интернет", @"Технологии"],
                @5: @[@"Бизнес", @"Финансы", @"Деньги и власть", @"Публичный счет", @"Личный счет" @"Цены"],
                @6: @[@"Спорт", @"Хоккей", @"Околоспорт", @"Футбол", @"Теннис"],
        };
    }
    return _categoryDescription;
}

- (void)updateChannelForIndex:(NSNumber *) index {
    NSArray *channelLinks = self.channelsDescription[index];
    for (NSString *link in channelLinks){
        NSURL *url = [NSURL URLWithString:link];
        [self loadChannelWithURL:url];
    }
}

- (void)updateSelectedChannel{
    [self updateChannelForIndex:self.selectedChannelIndex];
}

- (void)updateAllChannels {
    for (int i = 0; i<= self.channelsDescription.count; i++) {
        [self updateChannelForIndex:@(i)];
    }
}

- (void) loadChannelWithURL:(NSURL *)url {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        YMARSSChannel *channel = [YMARSSChannel MR_findFirstByAttribute:@"link"
                                                              withValue:url inContext:localContext];
        if (!channel) {
            channel = [YMARSSChannel MR_createEntityInContext:localContext];
            channel.link = url.absoluteString;
            NSLog(@"Channel not added creating new channel");
        }
        YMASAXParser *parser = [[YMASAXParser alloc] initWithContext:localContext];
        [parser parseChannelWithURL:url inCoreDataMOChannel:channel];
        channel.lastUpdate = [NSDate new];
        NSLog(@"RSS Channel loaded %@: %lu", url, [[channel items] count]);
    } completion:^(BOOL success, NSError *error) {
    }];
}

- (NSPredicate *)selectedOptionsPredicate {
    NSString *predicateFormat = @"SELF.channel.link in %@ AND SELF.category in %@";
    NSArray *channelLinks = self.channelsDescription[self.selectedChannelIndex];
    NSArray *categoryTags = self.categoryDescription[self.selectedCategoryIndex];
    return  [NSPredicate predicateWithFormat:predicateFormat, channelLinks, categoryTags];
}

- (void)applySelectedParameters {
    self.rssItems = [YMARSSItem MR_findAllSortedBy:@"date" ascending:NO withPredicate:self.selectedOptionsPredicate];
}

+ (BOOL)isInternetConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
