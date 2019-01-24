//
//  YFTextView.h
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTextView : UIView
@property(nonatomic,copy)NSString *placeholderStr;
@property(nonatomic,assign)float textFont;
@property(nonatomic,assign)int maxCount;
@property(nonatomic,copy)NSString *inputText;
@property(nonatomic,strong)UIColor *placeholderColor;
@property(nonatomic,assign)float placeholderFont;
@property(nonatomic,assign)BOOL hiddenCountLab;
@property(nonatomic,assign)BOOL showsVerticalScrollIndicator;

@property(nonatomic,assign)BOOL showPlaceholdInVerticalCenter;

/**
 *  清除textview的输入文字
 */
-(void)clearText;
@end
