//
//  ViewController.m
//  06-网易新闻
//
//  Created by apple on 15/1/21.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "ViewController.h"
#import "WSYNetworkTools.h"
#import "SingleModel.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *newsList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self loadData];
}

- (void)loadData {
    
    [[[WSYNetworkTools sharedNetworkTools] GET:@"/nc/article/list/T1348649580692/0-20.html" parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
//        NSLog(@"%@", responseObject);
        
        // 将字典中的第一项内容(数组)拿出来，直接使用字符串不够灵活
//        NSLog(@"%@", responseObject[@"T1348647853363"]);
        //
        // NSEnumerator 是一个计数器，苹果 forin 底层就使用的 NSEnumerator 的 nextObject 方法
        NSString *key = [responseObject.keyEnumerator nextObject];
        // 获取数组
//        NSLog(@"%@", responseObject[key]);
        
        /**
         字典转模型
         */
        // 调试第0项信息
        [self logInfoWithDict:responseObject[key][18]];
        NSArray *dataList = responseObject[key];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dataList.count];
        [dataList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"==== %tu", idx);
            
//            [arrayM addObject:[SingleModel singleModelWithDict:obj]];
        }];
        self.newsList = arrayM;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }] resume];
}

// 输出字典的信息
- (void)logInfoWithDict:(NSDictionary *)dict {
    
    NSMutableString *strM = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"%@ %@", key, [obj class]);
        
        NSString *clsName = NSStringFromClass([obj class]);
        if ([clsName isEqualToString:@"__NSCFString"] | [clsName isEqualToString:@"__NSCFConstantString"]) {
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n", key];
        } else if ([clsName isEqualToString:@"__NSCFArray"]) {
            [strM appendFormat:@"@property (nonatomic, strong) NSArray *%@;\n", key];
        } else if ([clsName isEqualToString:@"__NSCFNumber"]) {
            [strM appendFormat:@"@property (nonatomic, copy) NSNumber *%@;\n", key];
        } else if ([clsName isEqualToString:@"__NSCFBoolean"]) {
            [strM appendFormat:@"@property (nonatomic, assign) BOOL %@;\n", key];
        }
    }];
    NSLog(@"\n%@", strM);
}

@end
