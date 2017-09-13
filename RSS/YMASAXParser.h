//
//  YMASAXParser.h
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMARSSChannel;

@interface YMASAXParser : NSObject <NSXMLParserDelegate>
- (instancetype)initWithContext:(NSManagedObjectContext *)context;

+ (instancetype)parserWithContext:(NSManagedObjectContext *)context;

- (void)parseRSSChannelToCoreDataWithURL:(NSURL *)url;

@end
