//
//  UITextView+Emoticon.h
//  表情键盘OC
//
//  Created by apple on 15/8/31.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoticon.h"

@interface UITextView (Emoticon)
@property (nonatomic,copy) NSString *emoticonText;
- (void)insertEmoticon:(Emoticon *)emoticon;
@end
