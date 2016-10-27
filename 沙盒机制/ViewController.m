//
//  ViewController.m
//  沙盒机制
//
//  Created by oahgnehzoul on 2016/10/27.
//  Copyright © 2016年 oahgnehzoul. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"homePath:%@",[self getHomePath]);
//    NSLog(@"DocumentPath:%@",[self getDocumentsPath]);
//    NSLog(@"LibraryPath:%@",[self getLibraryPath]);
//    NSLog(@"TmpPath:%@",[self getTmpPath]);
//    [self parsePath];
//    [self createFolder];
    [self createFile];
    [self writeFile];
    [self addFile];
    [self deleteFile];
    [self writeImage];
}

//获取沙盒的路径
- (NSString *)getHomePath {
    NSString *homePath = NSHomeDirectory();
    return homePath;
}

//获取 Documents 路径
- (NSString *)getDocumentsPath {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return docPaths[0];
}

//获取 Library 路径
- (NSString *)getLibraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

//获取 tmp 路径
- (NSString *)getTmpPath {
    return NSTemporaryDirectory();
}


- (void)parsePath {
    NSString *path = @"/data/Containers/Data/Application/test.png";
    NSArray *array = [path pathComponents];
    NSLog(@"pathComponents:%@",array);
    NSString *name = [path lastPathComponent];
    NSLog(@"fileName:%@",name);
    NSString *str = [path stringByDeletingLastPathComponent];
    NSLog(@"lastPath:%@",str);
    NSString *addStr = [str stringByAppendingPathComponent:@"name.txt"];
    NSLog(@"addStr:%@",addStr);
}

- (void)dataChange {
    // NSData -> NSString
    NSString *str1 = @"你好";
    NSData *data = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str2:%@",str2);
//    UIImage *image = [UIImage imageWithData:data];
//    NSData *data2 = UIImagePNGRepresentation(image);
}

// 创建文件夹
- (void)createFolder {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *testPath = [docPath stringByAppendingPathComponent:@"lzh"];
    NSFileManager *manager = [NSFileManager defaultManager];
    // IntermediateDirectories: yes可以覆盖,
    if ([manager createDirectoryAtPath:testPath withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

//创建文件
- (void)createFile {
    NSString *testPath = [[self getDocumentsPath] stringByAppendingPathComponent:@"lzh"];
    NSString *filePath = [testPath stringByAppendingPathComponent:@"我的笔记.txt"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager createFileAtPath:filePath contents:nil attributes:nil]) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

//写入文件
- (void)writeFile {
    NSString *filePath = [[[self getDocumentsPath] stringByAppendingPathComponent:@"lzh"] stringByAppendingPathComponent:@"我的笔记.txt"];
    NSString *content = @"测试2测试3测试4";
    if ([content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        NSLog(@"写入文件成功");
    } else {
        NSLog(@"写入文件失败");
    }
}

//文件是否存在
- (BOOL)fileExist:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return YES;
    } else {
        return NO;
    }
}
//追加
- (void)addFile {
    NSString *docPath = [self getDocumentsPath];
    NSString *testPath = [[docPath stringByAppendingPathComponent:@"lzh"] stringByAppendingPathComponent:@"我的笔记.txt"];
    //打开文件，准备更新
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:testPath];
    [fileHandle seekToEndOfFile];//将节点跳到文件的末尾
    NSString *addStr = @"添加的东西";
    NSData *data = [addStr dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:data];
    [fileHandle closeFile];
}

//删除
- (void)deleteFile {
    NSString *testPath = [[[self getDocumentsPath] stringByAppendingPathComponent:@"lzh"] stringByAppendingPathComponent:@"我的笔记.txt"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([self fileExist:testPath]) {
        if ([manager removeItemAtPath:testPath error:nil]) {
            NSLog(@"文件删除成功");
        } else {
            NSLog(@"文件删除失败");
        }
    }
}

- (void)writeImage {
    UIImage *image = [UIImage imageNamed:@"Bruce.jpg"];
//    NSData *data = UIImagePNGRepresentation(image);
    //UIImageJPEGRepresentation(UIImage * __nonnull image, CGFloat compressionQuality) \
    compressionQuality：压缩质量，0~1,  越大，data越大，质量越高 \
    使用 Png的质量比 JPEG 高
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *path = [[[self getDocumentsPath] stringByAppendingPathComponent:@"lzh"] stringByAppendingPathComponent:@"图片"];
    [data writeToFile:path atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
