//
//  EmoticonAttachment.m
//  表情键盘OC
//
//  Created by apple on 15/8/31.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "EmoticonAttachment.h"

@implementation EmoticonAttachment
+ (NSAttributedString *)imageText:(Emoticon *)emoticon font:(UIFont *)font {
    // 1.创建图片属性字符串
    EmoticonAttachment *atta = [[EmoticonAttachment alloc] init];
    atta.chs = emoticon.chs;
    atta.image = [UIImage imageWithContentsOfFile:emoticon.imagePath];
    CGFloat h = font.lineHeight;
    atta.bounds = CGRectMake(0, -4, h, h);
    NSMutableAttributedString *imgTxt =[[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:atta]];
    [imgTxt addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 1)];
    return imgTxt;
}
@end
