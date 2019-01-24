//
//  JHGroupTableViewCellFour.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupTableViewCellFour.h"

@implementation JHGroupTableViewCellFour
{
     UIView * label_lineTow;//创建分割线
     UILabel  * label_code;//显示劵码的
     UILabel * label_use;//显示是否使用的
}

-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    JHOModel * oModel = model.modelArray[self.indexPath.row-2];
    if (label_lineTow == nil) {
        label_lineTow = [[UIView alloc]init];
        label_lineTow.frame =FRAME(0, 29.5, WIDTH, 0.5);
        label_lineTow.backgroundColor =  [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_lineTow];
    }
    if(label_code == nil){
        label_code = [[UILabel alloc]init];
        label_code.frame = FRAME(15, 5, WIDTH - 80, 20);
        label_code.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_code.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_code];
    }
    if (model.modelArray.count < 10) {
        label_code.text = [NSString stringWithFormat:NSLocalizedString(@"劵码0%ld:%@   x%@", nil),self.indexPath.row - 1,oModel.number,oModel.count];
    }else{
        label_code.text = [NSString stringWithFormat:NSLocalizedString(@"劵码%ld:%@   x%@", nil),self.indexPath.row - 1,oModel.number,oModel.count];
    }
    //显示使用状态的
    if (label_use == nil) {
        label_use = [[UILabel alloc]init];
        label_use.frame = FRAME(WIDTH - 60, 5, 50, 20);
        label_use.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_use.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_use];
        label_use.textAlignment = NSTextAlignmentRight;
    }
    if ([model.order_status isEqualToString:@"0"]&&[model.pay_status isEqualToString:@"0"]) {
        label_use.text = NSLocalizedString(@"未支付", nil);
    }else if ([oModel.status isEqualToString:@"-1"]){
        label_use.text = NSLocalizedString(@"已退款", nil);
    }
    else if([oModel.status isEqualToString:@"1"]){
         label_use.text = NSLocalizedString(@"已使用", nil);
    }
    else if([oModel.status isEqualToString:@"0"]){
        label_use.text = NSLocalizedString(@"未使用", nil);
    }
    
}
@end
