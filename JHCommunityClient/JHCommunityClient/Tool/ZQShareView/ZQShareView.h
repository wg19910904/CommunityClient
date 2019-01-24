//
//  ZQShareView.h
//  PopUpView
//
//  Created by 洪志强 on 17/5/2.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@interface ZQShareView : UIControl
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,copy)NSString *shareStr;
@property(nonatomic,copy)NSString *shareTitle;
@property(nonatomic,copy)NSString *shareUrl;
@property(nonatomic,copy)NSString *shareImgName;
@property(nonatomic,copy)NSString * hiden_QQ;
/**
 *  分享的是不是网络图片
 */
@property(nonatomic,assign)BOOL isUrlImg;

#pragma mark ====== 小程序分享需要 =======
@property(nonatomic,assign)BOOL is_miniProgrammar;// 是不是小程序分享
@property(nonatomic,copy)NSString *pagePath;// 小程序分享的页面路径
@property(nonatomic,copy)NSString *userName;// 小程序的原始id
@property(nonatomic,strong)UIImage *mini_shareImg;// 分享的图片

#pragma mark ====== 新增属性 =======  2018 06 01
/*
 @"share_content"
 @"share_photo"
 @"share_url"
@"share_title"
 */
@property (nonatomic,strong)NSDictionary *shareDic;//分享的相关数据
@property (nonatomic,strong)UIButton *shareBnt;//分享按钮
@property (nonatomic,strong)UIButton *collectBnt;//收藏按钮
@property (nonatomic,strong)NSString *can_id;//店家或者人员id
@property (nonatomic,strong)NSString *type;//类型 type店铺为1 人员为 2
- (void)addShareBntAndCollectionBntWithVC:(JHBaseVC *)vc withId:(NSString *)can_id type:(NSString *)type;
- (void)addShareBntAndCollectionBntWithVC:(JHBaseVC *)vc withView:(UIView *)view withId:(NSString *)can_id type:(NSString *)type;
- (void)getCollectButtonSelected;




-(instancetype)init;
/**
 展示的动画
 */
-(void)showAnimation;

@end
