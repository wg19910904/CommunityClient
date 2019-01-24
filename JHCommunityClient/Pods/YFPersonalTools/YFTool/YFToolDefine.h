//
//  Define.h
//  YFTool
//
//  Created by ios_yangfei on 2018/4/23.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#ifndef Define_h
#define Define_h


#define RandomColor [UIColor colorWithRed:(arc4random()%256 /255.0) green:(arc4random()%256 /255.0) blue:(arc4random()%256/255.0) alpha:1.0]

#define YF_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

// 屏幕宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width

#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define getSize(str,h,font)  [str boundingRectWithSize:CGSizeMake(10000, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size

#endif /* Define_h */
