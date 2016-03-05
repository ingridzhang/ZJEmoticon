//
//  EmoticonPackage.h
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 zhangjing. All rights reserved.
//  表情包模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Emoticon.h"

static NSMutableArray *packages;
@interface EmoticonPackage : NSObject
@property (nonatomic,copy) NSString *id; // 目录名
@property (nonatomic,copy) NSString *groupName; // 分组名
@property (nonatomic,strong) NSMutableArray *emoticons;// 表情数组

- (instancetype)init:(NSString *)id groupName:(NSString *)groupName;
+ (NSMutableArray *)loadEmoticonPackageList;
- (EmoticonPackage *)loadEmoticons;
+ (NSArray *)properties;
+ (NSString *)bundlePath;
+ (NSMutableArray *)sharedPackages;
+ (void)addFavorites:(Emoticon *)emoticon; // 添加"最近"表情包
+ (Emoticon *)emoticon:(NSString *)string; // 查找表情
// 将string生成带表情的属性字符串
+ (NSAttributedString *)emoticonText:(NSString *)string font:(UIFont *)font;
@end
