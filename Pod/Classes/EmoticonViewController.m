//
//  EmoticonViewController.m
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import "EmoticonViewController.h"
#import "ZJFlowLayout.h"
#import "ZJEmojiCell.h"
#import "EmoticonPackage.h"

#define kCollectionViewCell @"collectionViewCell"

@interface EmoticonViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,strong) NSArray *emoticonPackages; 
@end

@implementation EmoticonViewController

- (instancetype)initWith:(void (^)(Emoticon *emoticon))completion {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.completion = completion;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [super initWithCoder:coder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark -- 监听方法
- (void)clickItem:(UIBarButtonItem *)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:item.tag];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionLeft) animated:true];
}

#pragma mark -- 搭建界面
- (void)setupUI {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolbar];
    // 自动布局
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false;
    self.toolbar.translatesAutoresizingMaskIntoConstraints = false;
    NSDictionary *viewDict = @{@"collectionView":self.collectionView,@"toolbar":self.toolbar};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[toolbar]-0-|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-[toolbar(44)]-0-|" options:0 metrics:nil views:viewDict]];
    
    [self prepareToolbar];
    [self prepareCollectionView];
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Emoticon *emoticon = [self.emoticonPackages[indexPath.section] emoticons][indexPath.item];
    if (indexPath.section > 0) {
        [EmoticonPackage addFavorites:emoticon];
    }
    self.completion(emoticon);
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView{
    return self.emoticonPackages.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.emoticonPackages[section] emoticons].count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ZJEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
    cell.emoticon = [self.emoticonPackages[indexPath.section] emoticons][indexPath.item];
    return cell;
}

#pragma mark -- 准备控件
// 准备 collectionView
- (void)prepareCollectionView {
    [self.collectionView registerClass:[ZJEmojiCell class] forCellWithReuseIdentifier:kCollectionViewCell];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}
// 准备 toolbar
- (void)prepareToolbar {
    NSArray *titles = [NSArray arrayWithObjects:@"最近",@"默认",@"Emoji",@"浪小花", nil];
    NSMutableArray *items = [NSMutableArray array];
    int index = 0;
    for (NSString *title in titles) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:(UIBarButtonItemStylePlain) target:self action:@selector(clickItem:)];
        item.tag = index++;
        [items addObject:item];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
        [items addObject:flexible];
    }
    [items removeLastObject];
    self.toolbar.items = items;
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[ZJFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (UIToolbar *)toolbar {
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.tintColor = [UIColor darkGrayColor];
    }
    return  _toolbar;
}
- (NSArray *)emoticonPackages {
    if (_emoticonPackages == nil) {
        _emoticonPackages = [EmoticonPackage sharedPackages];
    }
    return _emoticonPackages;
}
@end
