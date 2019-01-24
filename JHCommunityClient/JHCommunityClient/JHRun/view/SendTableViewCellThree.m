//
//  SendTableViewCellThree.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellThree.h"

@implementation SendTableViewCellThree

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.backView == nil) {
        self.backView = [[UIView alloc]init];
        self.backView.frame = CGRectMake(10, 20, WIDTH-20, 140-40);
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        self.textView = [[UITextView alloc]init];
        self.textView.frame = CGRectMake(0, 0, WIDTH-20, 50);
        self.textView.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        self.textView.text = NSLocalizedString(@"请输入要求", nil);
        [self.backView addSubview:self.textView];
        self.addBtn = [[UIButton alloc]init];
        self.addBtn.frame = CGRectMake(5, 55, 40, 40);
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.backView addSubview:self.addBtn];
        self.labBtn = [[UIButton alloc]init];
        self.labBtn.frame = CGRectMake(WIDTH-20 -40, 55, 40, 40);
        [self.labBtn setImage:[UIImage imageNamed:@"lab"] forState:UIControlStateNormal];
        [self.backView addSubview:self.labBtn];
        
        
        
        
    }
    
}

@end
