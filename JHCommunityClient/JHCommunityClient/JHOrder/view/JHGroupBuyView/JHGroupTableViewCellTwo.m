//
//  JHGroupTableViewCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupTableViewCellTwo.h"

@implementation JHGroupTableViewCellTwo
{
    UIView * label_lineOne;//创建分割线
    UILabel * label_title;//团购劵
    UILabel * label_time;//显示有效期的
    
}

-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    //创建第一根分割线
    if(label_lineOne == nil){
        label_lineOne = [[UIView alloc]init];
        label_lineOne.frame = FRAME(0, 49.5, WIDTH, 0.5);
        label_lineOne.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_lineOne];
    }
    //创建显示团购卷
    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(15, 5, WIDTH/2, 20);
        label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_title.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_title];
    }
    if ([model.type isEqualToString:@"tuan"]) {
        label_title.text = NSLocalizedString(@"团购劵", nil);
    }else if ([model.type isEqualToString:@"quan"]){
        label_title.text = NSLocalizedString(@"代金劵", nil);
    }
    
    //显示有效期的
    if(label_time == nil){
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(15, 25, WIDTH, 20);
        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_time.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_time];
    }
    if (model.modelArray.count != 0) {
        JHOModel * oModel = model.modelArray[0];
        label_time.text = [NSString stringWithFormat:NSLocalizedString(@"有效期至:%@", nil),oModel.ltime?oModel.ltime:NSLocalizedString(@"无", nil) ];
    }else{
        if ([model.pay_status integerValue] == 0 && [model.order_status integerValue] != -1) {
           label_time.text = NSLocalizedString(@"等待用户支付", nil);
        }else if([model.order_status integerValue] == -1){
            label_time.text = NSLocalizedString(@"用户已经取消该订单", nil);
        }
        
    }
}
@end
