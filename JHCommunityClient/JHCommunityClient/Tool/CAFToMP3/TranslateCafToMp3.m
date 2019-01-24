//
//  TranslateCafToMp3.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "TranslateCafToMp3.h"

@implementation TranslateCafToMp3
+(void)translateCafToMp3WithTmpFile:(NSURL *)tmpUrl withMp3Url:(NSURL * )mp3Url withBlock:(void(^)(NSURL * mp3Url))backBlock{
    mp3Url = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"NewMp3.mp3"]];
    @try {
        int read, write;
        
        FILE *pcm = fopen([[tmpUrl absoluteString] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([[mp3Url absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read =(int) fread(pcm_buffer, 2*sizeof(short int),PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        if (backBlock) {
            backBlock(mp3Url);
        }
    }
 
}
@end
