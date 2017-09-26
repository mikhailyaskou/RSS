//
//  YMASAXParser.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord.h>
#import "YMASAXParser.h"
#import "YMARSSChannel+CoreDataProperties.h"
#import "YMARSSItem+CoreDataProperties.h"
#import "YMADateHelper.h"


@interface YMASAXParser ()

@property(nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic, strong) YMARSSChannel *rssChannel;
@property(nonatomic, strong) YMARSSItem *rssItem;
@property(nonatomic, strong) NSMutableString *tagInnerText;
@property(nonatomic, assign) BOOL isChannelSection;
@property(nonatomic, strong) NSString *itemImageUrl;

@end;

@implementation YMASAXParser

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

+ (instancetype)parserWithContext:(NSManagedObjectContext *)context {
    return [[self alloc] initWithContext:context];
}

- (void)parseChannelWithURL:(NSURL *)url inCoreDataMOChannel:(YMARSSChannel *)channel {
    self.rssChannel = channel;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"Start parsing");
    self.tagInnerText = [NSMutableString new];
    self.isChannelSection = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //clear string for new loop;
    [self.tagInnerText setString:@""];
    //set item section
    if ([elementName isEqualToString:@"item"]) {
        self.isChannelSection = NO;
        self.rssItem = [YMARSSItem MR_createEntityInContext:self.context];
    }
    if ([elementName isEqualToString:@"enclosure"] || [elementName isEqualToString:@"media:thumbnail"]) {
        self.itemImageUrl = [attributeDict valueForKey:@"url"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.tagInnerText appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if (self.isChannelSection) {
        //for channel
        ((void (^)()) @{
                @"title": ^{
                    self.rssChannel.title = self.tagInnerText;
                },
                @"description": ^{
                    self.rssChannel.topic = self.tagInnerText;
                },
                @"url": ^{
                    self.rssChannel.image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.tagInnerText]];
                },
        }[elementName] ?: ^{
        })();
    }
    else {
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

                    if (self.rssChannel.lastUpdate) {
                        NSComparisonResult result = [self.rssChannel.lastUpdate compare:self.rssItem.date];
                        if (result == NSOrderedDescending) {
                            NSLog(@"RSS Channel Updated stop loading %@", self.rssChannel.title);
                            self.rssChannel.lastUpdate = [NSDate new];
                            [parser abortParsing];
                        }
                    }
                },
                @"item": ^{
                    self.rssItem.imageUrl = self.itemImageUrl;
                    self.itemImageUrl = nil;
                    [self.rssChannel addItemsObject:self.rssItem];
                },
        }[elementName] ?: ^{
        })();
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.rssChannel.lastUpdate = [NSDate new];
    NSLog(@"end parsing");
}

@end
