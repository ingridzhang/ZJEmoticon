//
//  Emoticon.h
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 itcast. All rights reserved.
//  表情模型

#import <Foundation/Foundation.h>

@interface Emoticon : NSObject
@property (nonatomic, copy) NSString *id; // 表情目录
@property (nonatomic, copy) NSString *chs; // 发送给服务器的表情文字
@property (nonatomic, copy) NSString *png; // 本地显示的图片文件名
@property (nonatomic, copy) NSString *imagePath; // 图像路径
@property (nonatomic, copy) NSString *code;// emoji的代码
@property (nonatomic, copy) NSString *emoji; // emoji的字符串
@property (nonatomic, assign) BOOL removeEmoticon; // 删除标记
@property (nonatomic, assign) NSInteger times; // 点击次数

- (instancetype)initWithId:(NSString *)id Dict:(NSDictionary *)dict;
- (instancetype)initWithRemove:(BOOL)remove; // 删除构造方法
+ (instancetype)emoticonWithDict:(NSDictionary *)dict id:(NSString *)id;
+ (NSArray *)properties;
@end
