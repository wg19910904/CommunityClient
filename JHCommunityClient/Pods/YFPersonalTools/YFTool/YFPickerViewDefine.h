//
//  YFPickerViewDefine.h
//  YFTool
//
//  Created by ios_yangfei on 2018/4/23.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#ifndef YFPickerViewDefine_h
#define YFPickerViewDefine_h

typedef enum : NSUInteger {
    YFPickerViewTypeThreeRow,
    YFPickerViewTypeTwoRow,
    YFPickerViewTypeOneRow
} YFPickerViewType;

typedef NS_ENUM(NSUInteger, YFPickerViewShowType) {
    YFPickerViewShowFromBottom,
    YFPickerViewShowFromCenter,
};

typedef NS_ENUM(NSUInteger, YFPickerViewSubViewLocationType) {
    YFPickerViewSubViewLocationTopCenter,
    YFPickerViewSubViewLocationTopLeft,
    YFPickerViewSubViewLocationTopRight,
    YFPickerViewSubViewLocationBottomCenter,
    YFPickerViewSubViewLocationBottomLeft,
    YFPickerViewSubViewLocationBottomRight,
};

#endif /* YFPickerViewDefine_h */
