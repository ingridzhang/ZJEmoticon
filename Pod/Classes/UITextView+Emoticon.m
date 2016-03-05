//
//  UITextView+Emoticon.m
//  表情键盘OC
//
//  Created by apple on 15/8/31.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import "UITextView+Emoticon.h"
#import "EmoticonAttachment.h"

@implementation UITextView (Emoticon)

- (NSString *)emoticonText {
    NSAttributedString *attrString = self.attributedText;
    NSMutableString *strM = [[NSMutableString alloc] init];
    [attrString enumerateAttributesInRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        EmoticonAttachment *attach = attrs[@"NSAttachment"];
        if (attach != nil) {
            [strM appendString:attach.chs];
        }else {
            NSString *str = [attrString.string substringWithRange:range];
            [strM appendString:str];
        }
    }];
    return strM;
}

- (void)setEmoticonText:(NSString *)emoticonText {
    self.emoticonText = emoticonText;
}

- (void)insertEmoticon:(Emoticon *)emoticon {
    if (emoticon.removeEmoticon) {
        [self deleteBackward];
        return;
    }
    
    // 插入emoji
    if (emoticon.emoji != nil) {
        [self replaceRange:self.selectedTextRange withText:emoticon.emoji];
        return;
    }
    // 插入表情图片
    if (emoticon.chs != nil) {
        // 1.创建图片属性字符串
        NSAttributedString *imgTxt = [EmoticonAttachment imageText:emoticon font:self.font];
        // 2. 图片文字插入到textView
        // 1> 获取可变的属性文本
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        // 2> 插入图片文字
        [attrString replaceCharactersInRange:self.selectedRange withAttributedString:imgTxt];
        // 3> 使用可变属性文本替换文本视图内容
        // 1) 记录光标位置
        NSRange range = self.selectedRange;
        self.attributedText = attrString;
        self.selectedRange = NSMakeRange(range.location + 1, 0);
        [self.delegate textViewDidChange:self];
    }
}

@end
