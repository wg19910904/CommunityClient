//
//  KindItemCollectionView.h
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickKindItem)(NSInteger index);

@interface YFKindItemCollectionView : UIView
@property(nonatomic,assign)int colOrLineItems;
@property(nonatomic,assign)int arrCount;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)ClickKindItem clickKindItem;
@property(nonatomic,copy)void(^myBlock)(float contentOffSet);
-(instancetype)initWithFrame:(CGRect)frame isTool:(BOOL)isTool;

@end
