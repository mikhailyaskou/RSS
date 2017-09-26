//
//  YMAController.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "YMAController.h"
#import "YMASAXParser.h"
#import "YMARSSItem+CoreDataClass.h"
#import "YMARSSChannel+CoreDataClass.h"

static NSString * const YMALogAddNewChannel = @"Channel not added creating new channel";
static NSString * const YMALogChannelLoaded = @"RSS Channel loaded %@: %u";
static NSString * const YMAPredicateSelectedRssItems = @"SELF.channel.link in %@ AND SELF.category in %@";
static NSString * const YMADateFieldNameCoreData = @"date";
static const int YMADeepDuplicateItemsSearch = 2;

@interface YMAController ()

@property (nonatomic, strong) NSDictionary *channelsDescription;
@property (nonatomic, strong) NSDictionary *categoryDescription;

@end

@implementation YMAController

#pragma mark - Initialization

+ (YMAController *)sharedInstance {
    static YMAController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [YMAController new];
    });
    return _sharedInstance;
}

- (NSNumber *)selectedCategoryIndex {
    if (!_selectedCategoryIndex) {
        _selectedCategoryIndex = @(YMAInitialSelectedIndex);
    }
    return _selectedCategoryIndex;
}

- (NSNumber *)selectedChannelIndex {
    if (!_selectedChannelIndex) {
        _selectedChannelIndex = @(YMAInitialSelectedIndex);
    }
    return _selectedChannelIndex;
}

- (NSDictionary *)channelsDescription {
    if (!_channelsDescription) {
        _channelsDescription = @{@0: @[@"http://people.onliner.by/feed",
                @"http://auto.onliner.by/feed", @"http://tech.onliner.by/feed", @"http://realt.onliner.by/feed"],
                @1: @[
                        @"https://news.tut.by/rss/economics.rss", @"https://news.tut.by/rss/society.rss",
                        @"https://news.tut.by/rss/world.rss", @"https://news.tut.by/rss/culture.rss",
                        @"https://news.tut.by/rss/accidents.rss", @"https://news.tut.by/rss/finance.rss", @"https://news.tut.by/rss/realty.rss", @"https://news.tut.by/rss/sport.rss",
                        @"https://news.tut.by/rss/auto.rss"],
                @2: @[@"http://lenta.ru/rss", @"https://lenta.ru/rss/news", @"https://lenta.ru/rss/top7", @"https://lenta.ru/rss/last24",
                        @"https://lenta.ru/rss/articles", @"https://lenta.ru/rss/columns", @"https://lenta.ru/rss/news/russia", @"https://lenta.ru/rss/articles/russia", @"https://lenta.ru/rss/photo", @"https://lenta.ru/rss/photo/russia"]};
    }
    return _channelsDescription;
}

- (NSDictionary *)categoryDescription {
    if (!_categoryDescription) {
        _categoryDescription = @{@0: @[@"Россия", @"Мир", @"Крым", @"Бывший СССР", @"Путешествия", @"В мире",
                @"Происшествия", @"Эксклюзив", @"Кругозор", @"События в мире", @"Городская жизнь", @"Проблемы", @"Новые места", @"Официально"],
                @1: @[@"Люди", @"Мнения", @"Из жизни", @"Интернет и СМИ", @"Культура", @"Социум",
                        @"Силовые структуры", @"Ценности", @"Культпросвет", @"Общество", @"Офтоп", @"Профессионалы", @"Закон и порядок", @"Деревня"],
                @2: @[@"Недвижимость", @"Архитектура", @"Интерьер"],
                @3: @[@"Авто", @"Автобизнес", @"Дорога", @"Аварии", @"Дорожная обстановка",
                        @"Разбор с Красновым"],
                @4: @[@"Наука и техника", @"69-я параллель", @"Наука", @"Гаджеты и вендоры", @"Интернет", @"Технологии"],
                @5: @[@"Бизнес", @"Финансы", @"Деньги и власть", @"Публичный счет", @"Личный счет", @"Цены"],
                @6: @[@"Спорт", @"Хоккей", @"Околоспорт", @"Футбол", @"Теннис"],
        };
    }
    return _categoryDescription;
}

#pragma mark - Methods

- (void)updateSelectedChannelWithCompletionBlock:(nullable void (^)())completion {
    [self updateChannelForIndex:self.selectedChannelIndex withCompletionBlock:completion];
}

- (void)updateSelectedChannel {
    [self updateChannelForIndex:self.selectedChannelIndex];
}

- (void)updateChannelForIndex:(NSNumber *)index {
    [self updateChannelForIndex:index withCompletionBlock:^{
    }];
}

- (void)updateChannelForIndex:(NSNumber *)index withCompletionBlock:(nullable void (^)())completion {
    NSArray *channelLinks = self.channelsDescription[index];
    dispatch_group_t updateGroup = dispatch_group_create();
    dispatch_queue_t globalQueueDefaultPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    for (NSString *link in channelLinks) {
        dispatch_group_async(updateGroup, globalQueueDefaultPriority, ^{
            NSURL *url = [NSURL URLWithString:link];
            [self loadChannelWithURL:url];
        });
    }
    if (completion) {
        dispatch_group_notify(updateGroup, dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)loadChannelWithURL:(NSURL *)url {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        YMARSSChannel *channel = [YMARSSChannel MR_findFirstByAttribute:@"link" withValue:url inContext:localContext];
        if (!channel) {
            channel = [YMARSSChannel MR_createEntityInContext:localContext];
            channel.link = url.absoluteString;
            NSLog(YMALogAddNewChannel);
        }
        YMASAXParser *parser = [[YMASAXParser alloc] initWithContext:localContext];
        [parser parseChannelWithURL:url inCoreDataMOChannel:channel];
        NSLog(YMALogChannelLoaded, url, [channel.items count]);
    }];
}

- (void)applySelectedParameters {
    NSArray *channelLinks = self.channelsDescription[self.selectedChannelIndex];
    NSArray *categoryTags = self.categoryDescription[self.selectedCategoryIndex];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:YMAPredicateSelectedRssItems, channelLinks, categoryTags];
    NSMutableArray<YMARSSItem *> *result = [[YMARSSItem MR_findAllSortedBy:YMADateFieldNameCoreData
                                                                 ascending:NO
                                                             withPredicate:predicate] mutableCopy];
    //remove duplicated news (it happens when one news in few xml files)
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (int i = 0; i < result.count; i++) {
        for (int j = i + 1; j < result.count; j++) {
            if ([result[i].title isEqualToString:result[j].title]) {
                [discardedItems addObject:result[j]];
            }
            //items sorbet by date duplicated items allays placed close to each other
            if (j - i > YMADeepDuplicateItemsSearch) {
                break;
            }
        }
    }
    [result removeObjectsInArray:discardedItems];
    self.rssItems = [result copy];
}

@end
