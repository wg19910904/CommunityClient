//
//  YFButton.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBtnLeft : UIButton
@property(nonatomic,strong)UIFont *titleFont;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,assign)float adjustImgMargin;
@property(nonatomic,assign)float adjustTielLeftMargin;
@property(nonatomic,assign)BOOL ignoreTextRight;
/**
 *  调整控件的中子view的左右边距
 */
@property(nonatomic,assign)float adjustW;

@end
