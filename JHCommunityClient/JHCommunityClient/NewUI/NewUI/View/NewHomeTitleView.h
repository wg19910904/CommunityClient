//
//  NewHomeTitleView.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewHomeTitleView : UIControl
+(NewHomeTitleView *)showViewWithTitle:(NSString *)title
                                 frame:(CGRect )frame
                              withView:(UINavigationItem *)view;

@property(nonatomic,copy)NSString *titleText;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@property(nonatomic,strong)UIColor *bg_color;

@end
