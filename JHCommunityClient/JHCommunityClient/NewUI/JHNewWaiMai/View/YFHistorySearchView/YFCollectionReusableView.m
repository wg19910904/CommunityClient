//
//  YFCollectionReusableView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "YFCollectionReusableView.h"

@interface YFCollectionReusableView ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIButton *deleteBtn;
@end

@implementation YFCollectionReusableView

-(instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       [self configUI];
    }
    return self;
}

-(void)configUI{
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = HEX(@"666666", 1.0);
    titleLab.font=[UIFont systemFontOfSize:12];
    self.backgroundColor = BACK_COLOR;
    self.titleLab = titleLab;
    //delete_all
    UIButton *btn = [UIButton new];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    [btn setImage:IMAGE(@"delete_all") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = btn;
    
}

-(void)setTitleStr:(NSString *)titleStr{
    self.titleLab.text = titleStr;
}

-(void)clickDelete{
    if (self.deleteHistory) {
        self.deleteHistory();
    }
}

-(void)setHidden_delete:(BOOL)hidden_delete{
    _hidden_delete = hidden_delete;
    self.deleteBtn.hidden = hidden_delete;
}

@end
