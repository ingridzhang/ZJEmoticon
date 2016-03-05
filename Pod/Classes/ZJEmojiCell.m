//
//  ZJEmojiCell.m
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import "ZJEmojiCell.h"
#import "Emoticon.h"

@interface ZJEmojiCell ()
@property (nonatomic,strong) UIButton *emojiButton;
@end
@implementation ZJEmojiCell

#pragma mark -- 设置模型数据
- (void)setEmoticon:(Emoticon *)emoticon {
    _emoticon = emoticon;
    [self.emojiButton setImage:[UIImage imageWithContentsOfFile:emoticon.imagePath] forState:(UIControlStateNormal)];
    [self.emojiButton setTitle:emoticon.emoji forState:(UIControlStateNormal)];
    if (emoticon.removeEmoticon) {
        [self.emojiButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:(UIControlStateNormal)];
        [self.emojiButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:(UIControlStateHighlighted)];
    }
}
#pragma mark -- 构造方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [super initWithCoder:coder];
}

#pragma mark -- 搭建界面
- (void)setupUI {
    [self addSubview:self.emojiButton];
}

#pragma mark -- 懒加载
- (UIButton *)emojiButton {
    if (_emojiButton == nil) {
        _emojiButton = [[UIButton alloc] init];
        _emojiButton.backgroundColor = [UIColor whiteColor];
        _emojiButton.userInteractionEnabled = NO;
        _emojiButton.frame = CGRectInset(self.bounds, 4, 4);
    }
    return _emojiButton;
}
@end
