//
//  JHProductDetailCellOne.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHProductDetailCellOne : UITableViewCell<UIScrollViewDelegate>
typedef void(^ClickBtnBloc)();
@property(nonatomic, copy)NSDictionary *dataDic;
@property(nonatomic,strong)UIScrollView *top_scrollView;
@property(nonatomic,copy)ClickBtnBloc clickBtnBlock;
@end
