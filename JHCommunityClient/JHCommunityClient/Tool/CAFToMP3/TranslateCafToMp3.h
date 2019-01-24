//
//  TranslateCafToMp3.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <lame/lame.h>
@interface TranslateCafToMp3 : NSObject
/**
 *  格式转化
 *
 *  @param tmpUrl    需要传入录音的临时URL
 *  @param mp3Url    需要传入存储MP3的URL
 *  @param backBlock 转化完成后将url传回控制器
 */
+(void)translateCafToMp3WithTmpFile:(NSURL *)tmpUrl withMp3Url:(NSURL * )mp3Url withBlock:(void(^)(NSURL * mp3Url))backBlock;
@end
