//
//  EmoticonPackage.m
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "EmoticonPackage.h"
#import <objc/runtime.h>
#import "Emoticon.h"
#import "EmoticonAttachment.h"

@implementation EmoticonPackage

- (instancetype)init:(NSString *)id groupName:(NSString *)groupName {
    if (self = [super init]) {
        self.id = id;
        self.groupName = groupName;
    }
    return self;
}

+ (NSArray *)properties {
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(list[i]);
        [arrayM addObject:[NSString stringWithUTF8String:name]];
    }
    free(list);
    return arrayM.copy;
}

- (NSString *)description {
    NSArray *properties = [EmoticonPackage properties];
    NSDictionary *dict = [self dictionaryWithValuesForKeys:properties];
    return [NSString stringWithFormat:@"<%@: %p> %@",self.class, self, dict];
}

+ (NSString *)bundlePath {
    NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Emoticons.bundle"];
    return bundlePath;
}

+ (NSMutableArray *)sharedPackages {
    if (packages == nil) {
        packages = [self loadEmoticonPackageList];
    }
    return packages;
}

// 加载"最近"表情包
+ (void)addFavorites:(Emoticon *)emoticon {
    if (emoticon.removeEmoticon) {
        return;
    }
    EmoticonPackage *p = [EmoticonPackage sharedPackages][0];
    NSMutableArray *arrayM = p.emoticons;
    [arrayM removeLastObject];
    emoticon.times++;
    BOOL contains = [arrayM containsObject:emoticon];
    if (!contains) {
        [arrayM addObject:emoticon];
    }
    // 数组排序
    arrayM = [arrayM sortedArrayUsingComparator:^NSComparisonResult(Emoticon * obj1, Emoticon * obj2) {
        NSComparisonResult result = [[NSNumber numberWithInteger:obj2.times] compare:[NSNumber numberWithInteger:obj1.times]];
        return result;
    }].mutableCopy;
    if (!contains) {
        [arrayM removeLastObject];
    }
    [arrayM addObject:[[Emoticon alloc] initWithRemove:true]];
    p.emoticons = arrayM;
}

// 加载表情包
+ (NSMutableArray *)loadEmoticonPackageList {
    NSString *path = [[self bundlePath] stringByAppendingPathComponent:@"emoticons.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *list = dict[@"packages"];
    NSMutableArray *arrayM = [NSMutableArray array];
    EmoticonPackage *zuijin = [[[EmoticonPackage alloc] init:@"" groupName:@"最近"] appendEmptyEmoticons];
    [arrayM addObject:zuijin];
    for (NSDictionary *dict in list) {
        EmoticonPackage *obj = [[[[EmoticonPackage alloc] init:dict[@"id"] groupName:@""] loadEmoticons] appendEmptyEmoticons];
        [arrayM addObject:obj];
    }
    return arrayM;
}

// 查找表情
+ (Emoticon *)emoticon:(NSString *)string {
    Emoticon *emoticon = nil;
    // 遍历所有表情包的表情数组
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs CONTAINS %@",string];
    for (EmoticonPackage *p in [EmoticonPackage sharedPackages]) {
        emoticon = [[p.emoticons filteredArrayUsingPredicate:predicate] lastObject];
        if (emoticon != nil) {
            break;
        }
    }
    return emoticon;
}

// 将string 生成带表情的属性字符串
+ (NSAttributedString *)emoticonText:(NSString *)string font:(UIFont *)font {
    // 需求
    // 1.使用表情字符串获得对应的表情
    // 2.提取 string 中的表情字符串，用正则
    NSString *pattern = @"\\[.*?\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    // 开始匹配，matchesInString 在字符串中做任意多的匹配
    NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    int count = (int)results.count;
    NSMutableAttributedString *strM = [[NSMutableAttributedString  alloc] initWithString:string];
    while (count > 0) {
        NSTextCheckingResult *result = results[--count];
        NSRange range = [result rangeAtIndex:0];
        NSString *emStr = [string substringWithRange:range];
        Emoticon *emoticon = [EmoticonPackage emoticon:emStr];
        if (emoticon != nil) {
            NSAttributedString *attrStr = [EmoticonAttachment imageText:emoticon font:font];
            [strM replaceCharactersInRange:range withAttributedString:attrStr];
        }
    }
    return strM;
}

// 加载表情
- (EmoticonPackage *)loadEmoticons {
    NSString *path = [[[EmoticonPackage bundlePath] stringByAppendingPathComponent:self.id] stringByAppendingPathComponent:@"info.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.groupName = dict[@"group_name_cn"];
    NSMutableArray *array = dict[@"emoticons"];
    self.emoticons = [NSMutableArray array];
    int index = 0;
    for (NSDictionary *dict in array) {
        Emoticon *obj = [Emoticon emoticonWithDict:dict id:self.id];
        if (index == 20) {
        Emoticon *o = [[Emoticon alloc] initWithRemove:true];
            [self.emoticons addObject:o];
            index = 0;
        }
        [self.emoticons addObject:obj];
        index ++;
    }
    return self;
}

// 添加空白表情
- (EmoticonPackage *)appendEmptyEmoticons {
    if (self.emoticons.count == 0) {
        self.emoticons = [NSMutableArray array];
    }
    int count = self.emoticons.count % 21;
    if (count > 0 || self.emoticons.count == 0) {
        for (int i = count; i < 20; i++) {
            [self.emoticons addObject:[[Emoticon alloc] initWithRemove:false]];
        }
        [self.emoticons addObject:[[Emoticon alloc] initWithRemove:true]];
    }
    return self;
}
@end
