//
//  Emoticon.m
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "Emoticon.h"
#import <objc/runtime.h>
#import "EmoticonPackage.h"

@implementation Emoticon

// emoji字符串
- (void)setCode:(NSString *)code {
     unsigned value = 0;
    [[NSScanner scannerWithString:code] scanHexInt:&value];
    char chars[4];
    int len = 4;
    chars[0] = (value >> 24) & (1 << 24) - 1;
    chars[1] = (value >> 16) & (1 << 16) - 1;
    chars[2] = (value >> 8) & (1 << 8) - 1;
    chars[3] = value & (1 << 8) - 1;
    self.emoji = [[NSString alloc] initWithBytes:chars length:len encoding:NSUTF32StringEncoding];
    
}
// 图像路径
- (NSString *)imagePath {
    if (self.chs == nil) {
        return @"";
    }
    return [[[EmoticonPackage bundlePath] stringByAppendingPathComponent:self.id] stringByAppendingPathComponent:self.png];
}

- (instancetype)initWithRemove:(BOOL)remove {
    if (self = [super init]) {
        self.removeEmoticon = remove;
    }
    return self;
}

- (instancetype)initWithId:(NSString *)id Dict:(NSDictionary *)dict {
    self.id = id;
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)emoticonWithDict:(NSDictionary *)dict id:(NSString *)id {
    return [[self alloc] initWithId:id Dict:dict];
}
- (void)setValue:(nullable id)value forUndefinedKey:(nonnull NSString *)key {}

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
    NSArray *properties = [Emoticon properties];
    NSDictionary *dict = [self dictionaryWithValuesForKeys:properties];
    return [NSString stringWithFormat:@"<%@: %p> %@",self.class, self, dict];
}
@end
