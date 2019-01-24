//
//  JHGroupCellLast.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupCellLast.h"
#import <Masonry.h>
#import "UIImage+MDQRCode.h"
@implementation JHGroupCellLast{
    UIView * view;
    UIImageView * imageView;
}


-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if ([_model.pay_status isEqualToString:@"0"]) {
        
    }else{
        JHOModel * oModel = model.modelArray[0];
        if (view == nil) {
            view = [[UIView alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(0);
                make.right.offset(-0);
                make.bottom.offset(-15);
            }];
            imageView = [[UIImageView alloc]init];
            imageView.frame = FRAME((WIDTH- 160)/2, 10, 160, 160);
            imageView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
            imageView.layer.borderWidth = 1;
            if ([model.order_status isEqualToString:@"8"] || [oModel.status isEqualToString:@"1"]||[oModel.status isEqualToString:@"-1"]) {
                imageView.alpha = 0.2;
            }
            else{
                imageView.alpha = 1;
            }
            [view addSubview:imageView];
            imageView.image = [UIImage mdQRCodeForString:oModel.number size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
            
        }
        
    }

}
@end
