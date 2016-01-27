//
//  EmoticonViewController.h
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoticon.h"

@interface EmoticonViewController : UIViewController
@property (nonatomic,strong) void (^completion)(Emoticon *emoticon);

- (instancetype)initWith:(void (^)(Emoticon *emoticon))completion;
@end
