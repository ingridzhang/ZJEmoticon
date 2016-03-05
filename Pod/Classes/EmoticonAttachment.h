//
//  EmoticonAttachment.h
//  表情键盘OC
//
//  Created by apple on 15/8/31.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoticon.h"

@interface EmoticonAttachment : NSTextAttachment
@property (nonatomic,copy) NSString *chs;
+ (NSAttributedString *)imageText:(Emoticon *)emoticon font:(UIFont *)font;
@end
