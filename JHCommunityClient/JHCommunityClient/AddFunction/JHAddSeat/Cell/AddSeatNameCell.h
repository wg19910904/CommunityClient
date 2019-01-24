//
//  AddSeatNameCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAddSeatModel.h"
#import "HZQButton.h"
@protocol AddSeatNameCellDelegate<NSObject>
-(void)choseSex:(NSInteger)tag;
@end
@interface AddSeatNameCell : UITableViewCell
@property(nonatomic,strong)JHAddSeatModel *model;
@property(nonatomic,strong)UITextField * textField_input;
@property(nonatomic,assign)id<AddSeatNameCellDelegate>delegate;
@end
