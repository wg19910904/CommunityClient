//
//  JHPublishUsedCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPublishUsedCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UITextField *introLabel;
@property (nonatomic,strong)UIImageView *dirImg;
@property (nonatomic,assign)NSIndexPath *indexPath;
@end
