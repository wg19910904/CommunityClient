//
//  JHTouSuCellOne.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTouSuCellOne : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,assign)NSIndexPath *indexPath;
@end
