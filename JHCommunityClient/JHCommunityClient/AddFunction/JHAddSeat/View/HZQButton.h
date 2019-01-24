//
//  HZQButton.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZQButton : UIButton
/**
 *  左边是图片,右边是字
 *
 *  @param title         显示的文字
 *  @param selecterImage 选中时image
 *  @param defaultImage  普通是的image
 *
 *  @return 返回对象
 */
-(instancetype)initWithText:(NSString *)title
              selecterImage:(UIImage *)selecterImage
               defaultImage:(UIImage *)defaultImage;
@end
