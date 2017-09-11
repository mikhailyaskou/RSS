//
//  YMASAXParser.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import "YMASAXParser.h"
#import "YMARSSChannel+CoreDataProperties.h"
#import "YMARSSItem+CoreDataProperties.h"
#import "YMADateHelper.h"


@interface YMASAXParser ()

@property(nonatomic, strong) YMARSSChannel *rssChannel;
@property(nonatomic, strong) YMARSSItem *rssItem;
@property(nonatomic, strong) NSMutableString *tagInnerText;
@property(nonatomic, assign) BOOL isChannelSection;
@property(nonatomic, strong) NSString *itemImageUrl;

@end;

@implementation YMASAXParser

- (instancetype)init {
    self = [super init];
    if (self) {
        _rssChannel = [YMARSSChannel MR_createEntity];
    }
    return self;
}


- (instancetype)initWithRssChannel:(YMARSSChannel *)rssChannel {
    self = [super init];
    if (self) {
        _rssChannel = rssChannel;
    }
    return self;
}

+ (instancetype)parserWithRssChannel:(YMARSSChannel *)rssChannel {
    return [[self alloc] initWithRssChannel:rssChannel];
}

- (void)parseRSSChannelToCoreDataWithURL:(NSURL *)url {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    BOOL result = [parser parse];
    self.isChannelSection = YES;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.tagInnerText = [NSMutableString new];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //clear string for new loop;
    [self.tagInnerText setString:@""];
    //set item section
    if ([elementName isEqualToString:@"item"]) {
        self.isChannelSection = NO;
        self.rssItem = [YMARSSItem MR_createEntity];
    }

    if ([elementName isEqualToString:@"enclosure"] || [elementName isEqualToString:@"media"]) {
        self.itemImageUrl = [attributeDict valueForKey:@"url"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.tagInnerText appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (self.isChannelSection) {
        //for channel
        ((void (^)())@{
                @"title": ^{
                    self.rssChannel.title = self.tagInnerText;
                },
                @"link": ^{
                    self.rssChannel.link = self.tagInnerText;
                },
                @"description": ^{
                    self.rssChannel.topic = self.tagInnerText;
                 },
                @"url": ^{
                    self.rssChannel.image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.tagInnerText]];
                },
        }[elementName]?: ^{
        })();

    } else {
        //for every tag in item
        ((void (^)()) @{
                @"title": ^{
                    self.rssItem.title = self.tagInnerText;
                },
                @"link": ^{
                    self.rssItem.link = self.tagInnerText;
                },
                @"description": ^{
                    self.rssItem.topic = self.tagInnerText;
                },
                @"category": ^{
                    self.rssItem.category = self.tagInnerText;
                },
                @"pubDate": ^{
                    self.rssItem.date = [YMADateHelper dateFromRSSString:self.tagInnerText];
                },
                @"item": ^{
                    self.rssItem.imageUrl = self.itemImageUrl;
                    [self.rssChannel addItemsObject:self.rssItem];
                },
        }[elementName] ?: ^{
        })();

    }
}

@end
