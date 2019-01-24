//
//  TakeawayOrderProgressCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "TakeawayOrderProgressCellOne.h"

@implementation TakeawayOrderProgressCellOne
{
   
    UIView * label_line;//创建分割线
    UILabel * label_progress;//显示订单的进度的
}

-(void)setModel:(JHTakewayProgressModel *)model{
    _model = model;
    if(self.btn == nil){
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 115, 10, 100, 40);
        self.btn.layer.cornerRadius = 2;
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.borderColor = [UIColor orangeColor].CGColor;
        self.btn.layer.borderWidth = 1;
        [self.btn setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:self.btn];
    }
    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0&&[model.online_pay integerValue]==1){
        self.btn.hidden = NO;
    }else{
        self.btn.hidden = YES;
    }
    
    if(label_line == nil){
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
        label_line.backgroundColor =[UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    if(label_progress == nil){
        label_progress =[[UILabel alloc]init];
        label_progress.frame = FRAME(15, 10, WIDTH - 120, 40);
        label_progress.numberOfLines = 2;
        label_progress.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label_progress];
    }
    NSString * string = [NSString stringWithFormat:@"%@(%@)\n%@",model.order_status_label,[self returnTimeWithNum:model.dateline],model.order_status_warning];
    NSRange range = [string rangeOfString:model.order_status_label];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:string];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:range];
    label_progress.text = string;
    label_progress.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_progress.font = [UIFont systemFontOfSize:13];
    label_progress.attributedText = attributed;
    
}
-(NSString *)returnTimeWithNum:(NSString *)dateline{
    NSInteger num = [dateline integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}

@end
