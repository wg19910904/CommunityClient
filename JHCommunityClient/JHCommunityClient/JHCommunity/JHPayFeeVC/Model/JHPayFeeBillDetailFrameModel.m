//
//  JHPayFeeBillDetailFrameModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPayFeeBillDetailFrameModel.h"

@implementation JHPayFeeBillDetailFrameModel
- (void)setPayFeeBillListModel:(JHPayFeeBillListModel *)payFeeBillListModel{
    _payFeeBillListModel = payFeeBillListModel;
    CGFloat beginHeight = 105;
    
    if([payFeeBillListModel.wuye_price floatValue] > 0){
        _wuYeFeeHeight = beginHeight;
        beginHeight += 30;
    }
    
    if([payFeeBillListModel.shui_price floatValue] > 0){
        _waterFeeHeight = beginHeight;
        beginHeight += 30;
    }
    
    if([payFeeBillListModel.dian_price floatValue] > 0){
        _dianFeeHeight = beginHeight;
        beginHeight += 30;
    }
    
    if([payFeeBillListModel.ranqi_price floatValue] > 0){
        _gasFeeHeight = beginHeight;
        beginHeight += 30;
    }
    
    if([payFeeBillListModel.chewei_price floatValue] > 0){
        _cheWeiHeight = beginHeight;
        beginHeight += 30;
    }
    
    if(beginHeight == 105){
        _totalViewHeight = 130;
        _rowHeight = 170;
    }else{
        _totalViewHeight = beginHeight + 25;
        _rowHeight = _totalViewHeight + 40;
    }
}
@end
