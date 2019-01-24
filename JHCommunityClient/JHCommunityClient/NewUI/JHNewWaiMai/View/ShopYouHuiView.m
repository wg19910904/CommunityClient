//
//  ShopYouHuiView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "ShopYouHuiView.h"
#import "YFTypeBtn.h"
@interface ShopYouHuiView ()
@property(nonatomic,weak)UIButton *countBtn;// 展开活动的按钮
@end

@implementation ShopYouHuiView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         [self configUI];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
}


-(void)setYouhuiArr:(NSArray *)youhuiArr{
    _youhuiArr = youhuiArr;
    if (youhuiArr.count <= 3) {
        self.countBtn.hidden = YES;
    }else{
        self.countBtn.hidden = NO;
    }
}

@end
