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

static NSString * const YMAItemTagXML = @"item";
static NSString * const YMAMediaTagXML = @"media:thumbnail";
static NSString * const YMALogStartParsing = @"Start parsing";
static NSString * const YMAEnclosureTagXML = @"enclosure";
static NSString * const YMAUrlTagXML = @"url";
static NSString * const YMATitleTagXML = @"title";
static NSString * const YMADescriptionTagXML = @"description";
static NSString * const YMALinkTagXML = @"link";
static NSString * const YMACategoryYMALinkTagXML = @"category";
static NSString * const YMAPubDateTagXML = @"pubDate";
static NSString * const YMALogChannelUpdated = @"RSS Channel Updated stop loading %@";
static NSString * const YMALogParsingEnded = @"end parsing";

@interface YMASAXParser ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) YMARSSChannel *rssChannel;
@property (nonatomic, strong) YMARSSItem *rssItem;
@property (nonatomic, strong) NSMutableString *tagInnerText;
@property (nonatomic, assign) BOOL isChannelSection;
@property (nonatomic, strong) NSString *itemImageUrl;

@end;

@implementation YMASAXParser

#pragma mark - Initialization

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

#pragma mark - Methods

- (void)parseChannelWithURL:(NSURL *)url inCoreDataMOChannel:(YMARSSChannel *)channel {
    self.rssChannel = channel;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(YMALogStartParsing);
    self.tagInnerText = [NSMutableString new];
    self.isChannelSection = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //clear string for new loop;
    [self.tagInnerText setString:@""];
    //set item section
    if ([elementName isEqualToString:YMAItemTagXML]) {
        self.isChannelSection = NO;
        self.rssItem = [YMARSSItem MR_createEntityInContext:self.context];
    }
    if ([elementName isEqualToString:YMAEnclosureTagXML] || [elementName isEqualToString:YMAMediaTagXML]) {
        self.itemImageUrl = [attributeDict valueForKey:YMAUrlTagXML];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.tagInnerText appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if (self.isChannelSection) {
        //for channel
        ((void (^)()) @{
                YMATitleTagXML: ^{
                    self.rssChannel.title = self.tagInnerText;
                },
                YMADescriptionTagXML: ^{
                    self.rssChannel.topic = self.tagInnerText;
                },
                YMAUrlTagXML: ^{
                    self.rssChannel.image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.tagInnerText]];
                },
        }[elementName] ?: ^{
        })();
    }
    else {
        //for every tag in item
        ((void (^)()) @{
                YMATitleTagXML: ^{
                    self.rssItem.title = self.tagInnerText;
                },
                YMALinkTagXML: ^{
                    self.rssItem.link = self.tagInnerText;
                },
                YMADescriptionTagXML: ^{
                    self.rssItem.topic = self.tagInnerText;
                },
                YMACategoryYMALinkTagXML: ^{
                    self.rssItem.category = self.tagInnerText;
                },
                YMAPubDateTagXML: ^{
                    self.rssItem.date = [YMADateHelper dateFromRSSString:self.tagInnerText];

                    if (self.rssChannel.lastUpdate) {
                        NSComparisonResult result = [self.rssChannel.lastUpdate compare:self.rssItem.date];
                        if (result == NSOrderedDescending) {
                            NSLog(YMALogChannelUpdated, self.rssChannel.title);
                            self.rssChannel.lastUpdate = [NSDate new];
                            [parser abortParsing];
                        }
                    }
                },
                YMAItemTagXML: ^{
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
    NSLog(YMALogParsingEnded);
}

@end
