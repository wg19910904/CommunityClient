//
//  NewHomeTitleView.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "NewHomeTitleView.h"
@interface NewHomeTitleView()
@property(nonatomic,strong)UIImageView *leftImgV;//左边的图片
//@property(nonatomic,strong)UIImageView *rightImgV;//右边的图片
@property(nonatomic,strong)UIButton *searchT;//显示地址
@property(nonatomic,strong) NewHomeTitleView *currentView;
@end

@implementation NewHomeTitleView

+(NewHomeTitleView *)showViewWithTitle:(NSString *)title
                              frame:(CGRect )frame
                           withView:(UINavigationItem *)view{
    
    NewHomeTitleView *currentView = [[NewHomeTitleView alloc]init];
    currentView.frame = frame;
    currentView.layer.cornerRadius = frame.size.height/2;
    currentView.layer.masksToBounds = YES;
    currentView.backgroundColor = HEX(@"eeeeee", 0.6);
    //左边的图片
    [currentView leftImgV];
    [currentView searchT];
    //右边的图片
//    [currentView rightImgV];
    //显示地址
//    currentView.addressLabel.text = title;
    currentView.intrinsicContentSize = frame.size;
    view.titleView = currentView;
    return currentView;
}
-(UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]init];
        _leftImgV.image = IMAGE(@"address_search");
        [self addSubview:_leftImgV];
        [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset =  11;
            make.width.offset = 17;
            make.height.offset = 17;
            make.top.offset = 5;
        }];
    }
    return _leftImgV;
   
}
-(void)setBg_color:(UIColor *)bg_color{
    _bg_color = bg_color;
    self.backgroundColor = bg_color;
}
//-(UIButton*)searchT{
//    if (!_searchT) {
//        _searchT = [[UIButton alloc]init];
//        [self addSubview:_searchT];
//        [_searchT mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.right.offset = 0;
//            make.left.offset = 30;
//        }];
//    }
//    return _searchT;
//    
//}
@end
