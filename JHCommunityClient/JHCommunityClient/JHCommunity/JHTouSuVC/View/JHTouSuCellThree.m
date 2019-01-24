//
//  JHTouSuCellThree.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTouSuCellThree.h"
#import "MyTapGesture.h"
#import "AppDelegate.h"
#import "DisplayImageInView.h"
#define  space (WIDTH - 105) / 4
@implementation JHTouSuCellThree
{
    UIView *_backView;
    UIView *_bottomLine;
    UIView *_leftLine;
    UIView *_rightLine;
    DisplayImageInView *_displayView;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACK_COLOR;
    }
    return self;
}
#pragma mark--====初始化子控件
- (void)initSubViews{
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = - 15;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
    
    _leftLine = [UIView new];
    _leftLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:_leftLine];
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.width.offset = 0.5;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    
    _rightLine = [UIView new];
    _rightLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:_rightLine];
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.width.offset = 0.5;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    _imgBackView = [UIView new];
    [_backView addSubview:_imgBackView];
    _imgBackView.backgroundColor = [UIColor whiteColor];
    [_imgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.width.offset = WIDTH - 60;
        make.top.offset = 5;
        make.height.offset = space;
    }];
    _addImgBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImgBnt setBackgroundImage:IMAGE(@"add") forState:UIControlStateNormal];
}
- (void)setImgArray:(NSArray *)imgArray imgDataArray:(NSArray *)imgDataArray{
    _imgArray = [imgArray mutableCopy];
    _imgDataArray = [imgDataArray mutableCopy];
    for(UIView *view in _imgBackView.subviews){
        [view removeFromSuperview];
    }
    if(imgArray.count >= 4){
        [_addImgBnt removeFromSuperview];
    }else{
        [_imgBackView addSubview:_addImgBnt];
        _addImgBnt.frame = FRAME(imgArray.count * (15 + space), 0, space, space);
    }
    for(int i = 0; i < imgArray.count; i ++){
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(i * (space + 15),0, space, space)];
        img.image = imgArray[i];
        img.userInteractionEnabled = YES;
        MyTapGesture *imgTap = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
        imgTap.tag = i + 1;
        [img addGestureRecognizer:imgTap];
        [_imgBackView addSubview:img];
    }
}

#pragma mark==============
- (void)tapImage:(MyTapGesture *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消了");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"查看原图", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(_displayView == nil)
        {
            _displayView = [[DisplayImageInView alloc] init];
            [ _displayView showInViewWithImageArray:_imgArray withIndex:sender.tag withBlock:^{
                [_displayView removeFromSuperview];
                _displayView = nil;
            }];
        }
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_imgArray removeObjectAtIndex:sender.tag - 1];
        [_imgDataArray removeObjectAtIndex:sender.tag - 1];
        if(self.refreshImgCellBlock){
            self.refreshImgCellBlock([_imgArray copy],[_imgDataArray copy]);
        }
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
