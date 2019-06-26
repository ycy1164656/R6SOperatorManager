//
//  ViewController.m
//  R6Manager
//
//  Created by 杨成阳 on 2018/9/20.
//  Copyright © 2018年 杨成阳. All rights reserved.
//

#import "ViewController.h"
#import "XMLDictionary.h"

@interface ViewController ()
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *dataSource1;
@end

@implementation ViewController


- (void)createXLSFileWithArray:(NSArray *)arr keyArr:(NSArray *)keyArr columnArr:(NSArray *)columnArr {
    // 创建存放XLS文件数据的数组
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // 第一行内容
    for (int i  = 0; i < columnArr.count; i ++) {
        [xlsDataMuArr addObject:columnArr[i]];
    }
 
    // 100行数据
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dic = arr[i];
        for (int j = 0; j < keyArr.count; j++) {
            [xlsDataMuArr addObject:dic[keyArr[j]]];
        }
        
//         [xlsDataMuArr addObject:dic[@"u_id"]];
//        [xlsDataMuArr addObject:dic[@"cor_num"]];
//        [xlsDataMuArr addObject:dic[@"cor_balance"]];
//        [xlsDataMuArr addObject:dic[@"cor_time"]];
       
    }
    // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
    NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
    // 字符串转换为可变字符串，方便改变某些字符
    NSMutableString *muStr = [fileContent mutableCopy];
    // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
    NSMutableArray *subMuArr = [NSMutableArray array];
    for (int i = 0; i < muStr.length; i ++) {
        NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
        if (range.length == 1) {
            [subMuArr addObject:@(range.location)];
        }
    }
    // 替换末尾\t
    for (NSUInteger i = 0; i < subMuArr.count; i ++) {
#warning  下面的6是列数，根据需求修改
        if ( i > 0 && (i% keyArr.count == 0) ) {
            [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
        }
    }
    // 文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"/Documents/export.xls"];
    NSLog(@"文件路径：\n%@",filePath);
    // 生成xls文件
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] init];
    _dataSource1 = [[NSMutableArray alloc] init];
    
    
    NSString *filePath = [[NSBundle mainBundle ] pathForResource:@"teacherData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *guns = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"%@",guns);
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
 
    for (int i = 0; i < guns.count; i ++) {
        NSDictionary *dic = guns[i];
        if ([dic[@"cor_num"] integerValue] == 7) {
            bool only7 = true;
            for (NSDictionary *tempDic in guns) {
                if ([tempDic[@"datatime"] isEqualToString:dic[@"datatime"]]&& [[tempDic[@"u_id"] description] isEqualToString:[dic[@"u_id"] description]]&&[tempDic[@"u_name"] isEqualToString:dic[@"u_name"]] && [tempDic[@"cor_num"] integerValue] != 7) {
                    only7 = false;
                }
            }
            if (only7) {
                [results addObject:dic];
            }
        }
    }
    NSLog(@"%@",results);
    
    
//    for (int i = 0; i < guns.count; i++) {
//        NSDictionary *dic = guns[i];
//        if (tempDic) {
//            NSDate *temDate = [NSDate dateWithString:tempDic[@"cor_time"] format:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *dicDate = [NSDate dateWithString:dic[@"cor_time"] format:@"yyyy-MM-dd HH:mm:ss"];
//            if ([[tempDic[@"cor_num"] description] isEqualToString:[dic[@"cor_num"] description]]&&[[tempDic[@"u_id"] description] isEqualToString:[dic[@"u_id"] description]]&&[[tempDic[@"cor_balance"] description] isEqualToString:[dic[@"cor_balance"] description]] && [dicDate timeIntervalSinceDate:temDate] < 10.) {
//                [results addObject:@[tempDic,dic]];
//            }
//        }
//
//        tempDic = dic;
//    }
    
    [self createXLSFileWithArray:results keyArr:@[@"u_name",@"cor_num",@"datatime"] columnArr:@[@"姓名",@"金额",@"时间"]];
//    NSLog(@"%@",results);
    
    
//    WEAKSELF
//    PFQuery *query = [PFQuery queryWithClassName:@"Gun"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (objects.count) {
//             [blockSelf.dataSource addObjectsFromArray:objects];
//            PFQuery *query1 = [PFQuery queryWithClassName:@"Equipment"];
//            [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//                if (objects.count) {
//                    [blockSelf.dataSource1 addObjectsFromArray:objects];
//                    [blockSelf getLater];
//                }
//            }];
//
//         }
//    }];
//
//
//
////    PFQuery *query1 = [PFQuery queryWithClassName:@"Operator"];
////    [query1 includeKey:@"Maingun"];
////    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
////        if (objects.count) {
////
////        }
////    }];
//
//    NSString *filePath = [[NSBundle mainBundle ] pathForResource:@"qiang_copy1" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSDictionary *guns = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"%@",guns);
//    NSArray *gunarray = guns[@"RECORDS"];
//
//    NSMutableArray *newGuns = [NSMutableArray array];
//    for (NSDictionary *dic in gunarray) {
//        NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        for (NSString *key in dic.allKeys) {
//            if ([key isEqualToString:@"Barrel"] || [key isEqualToString:@"Sight"]|| [key isEqualToString:@"Grip"]|| [key isEqualToString:@"Under Barrel"]) {
//                NSArray *barrel = [dic[key] componentsSeparatedByString:@"]"];
//                NSMutableArray *newStrings = [NSMutableArray array];
//                for (NSString *string in barrel) {
//                    NSMutableString *newstring = [NSMutableString stringWithString:string];
//                    if ([newstring containsString:@"['"]) {
//                         [newstring deleteCharactersInRange:[string rangeOfString:@"['"]];
//                    }
//                    if ([newstring containsString:@"'"]) {
//                         [newstring deleteCharactersInRange:[newstring rangeOfString:@"'"]];
//                    }
//
//                    if (newstring.length) {
//                        [newStrings addObject:newstring];
//                    }
//
//                }
//                [newdic setObject:newStrings forKey:key];
//            }
//
//            if ([key isEqualToString:@"URL"]) {
//                NSString *newurl = [dic[key] substringWithRange:NSMakeRange(2, [dic[key] length] - 4)];
//                [newdic setObject:newurl forKey:key];
//            }
//        }
//        [newGuns addObject:newdic];
//    }
//
////    for (NSDictionary *dic in newGuns) {
////
////        PFObject *gameScore = [PFObject objectWithClassName:@"Gun"];
////        gameScore[@"rate"] = dic[@"Rate of fire"];
////        gameScore[@"size"] = dic[@"Magazine size"];
////        gameScore[@"total"] = dic[@"Total ammunition"];
////        gameScore[@"typeName"] = dic[@"类型"];
////        gameScore[@"barrel"] = dic[@"Barrel"];
////        gameScore[@"name"] = dic[@"Name"];
////        gameScore[@"damage"] = dic[@"Damage"];
////        gameScore[@"desc"] = dic[@"介绍"];
////        gameScore[@"grip"] = dic[@"Grip"];
////        gameScore[@"firemode"] = dic[@"Firing mode(s)"];
////        gameScore[@"image"] = dic[@"URL"];
////        gameScore[@"sight"] = dic[@"Sight"];
////        gameScore[@"underBarrel"] = dic[@"Under Barrel"];
////        [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////            if (succeeded) {
////                // The object has been saved.
////            } else {
////                // There was a problem, check error.description
////            }
////        }];
////    }
//
//
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//
//
//-(void)getLater{
//    NSString *oPath = [[NSBundle mainBundle ] pathForResource:@"man_copy1" ofType:@"json"];
//    NSData *odata = [NSData dataWithContentsOfFile:oPath];
//    NSDictionary *operators = [NSJSONSerialization JSONObjectWithData:odata options:kNilOptions error:nil];
//    NSArray *gunarray = operators[@"RECORDS"];
//    NSLog(@"%@",operators);
//
//
//
//    NSMutableArray *newArr = [NSMutableArray array];
//    for (NSDictionary *dic in gunarray) {
//        NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        for (NSString *key in dic.allKeys) {
//            NSMutableString *newString = [NSMutableString stringWithString:dic[key]];
//            if ([key isEqualToString:@"Affiliation"]) {
//                if ([newString containsString:@"['"]) {
//                    [newString deleteCharactersInRange:[newString rangeOfString:@"['"]];
//                }
//                if ([newString containsString:@"']"]) {
//                    [newString deleteCharactersInRange:[newString rangeOfString:@"']"]];
//                }
//                [newdic setObject:newString forKey:key];
//            }
//            if ([key isEqualToString:@"Background"]) {
//                if ([newString containsString:@"===Background==="]) {
//                    [newString deleteCharactersInRange:[newString rangeOfString:@"===Background==="]];
//                }
//                [newdic setObject:newString forKey:key];
//            }
//            if ([key isEqualToString:@"Name"]) {
//                if ([newString containsString:@"['"]) {
//                    [newString deleteCharactersInRange:[newString rangeOfString:@"['"]];
//                }
//                if ([newString containsString:@"']"]) {
//                    [newString deleteCharactersInRange:[newString rangeOfString:@"']"]];
//                }
//                [newdic setObject:newString forKey:key];
//            }
//
//            if ([key isEqualToString:@"Weapons-Primary"]) {
//                NSMutableArray *primary = [NSMutableArray array];
//                for (PFObject *obj in _dataSource) {
//                    if ([[newString lowercaseString] containsString:[obj[@"name"] lowercaseString]]) {
//                        [primary addObject:obj];
//                    }
//                }
//                [newdic setObject:primary forKey:key];
//            }
//            if ([key isEqualToString:@"Weapons-Secondary"]) {
//                NSMutableArray *primary = [NSMutableArray array];
//                for (PFObject *obj in _dataSource) {
//                    if ([[newString lowercaseString] containsString:[obj[@"name"] lowercaseString]]) {
//                        [primary addObject:obj];
//                    }
//                }
//                [newdic setObject:primary forKey:key];
//            }
//            if ([key isEqualToString:@"Equipment"]) {
//                NSMutableArray *primary = [NSMutableArray array];
//                for (PFObject *obj in _dataSource1) {
//                    if ([[newString lowercaseString] containsString:[obj[@"name"] lowercaseString]]) {
//                        [primary addObject:obj];
//                    }
//                }
//                [newdic setObject:primary forKey:key];
//            }
//            if ([key isEqualToString:@"Unique Gadget-description"]) {
//                if ([newString containsString:@"|description="]) {
//                    [newString deleteCharactersInRange:[newString rangeOfString:@"|description="]];
//                }
//
//                [newdic setObject:newString forKey:key];
//            }
//
//
//        }
//        [newArr addObject:newdic];
//    }
//    NSLog(@"%@",newArr);
//
//
//    for (NSDictionary *dic in newArr) {
//
//        PFObject *gameScore = [PFObject objectWithClassName:@"Operator"];
//        gameScore[@"name"] = dic[@"type"];
//        gameScore[@"logoUrl"] = dic[@"logourl"];
//        gameScore[@"team"] = dic[@"Team"];
//        gameScore[@"bodyUrl"] = dic[@"manurl"];
//        gameScore[@"Maingun"] = dic[@"Weapons-Primary"];
//        gameScore[@"Secondgun"] = dic[@"Weapons-Secondary"];
//        gameScore[@"Intro"] = dic[@"Background"];
//        gameScore[@"Ability"] = dic[@"Unique Gadget-description"];
//#warning 修改
//        if ([dic[@"type"] isEqualToString:@"Kaid"]) {
//            gameScore[@"armor"] = @"3";
//            gameScore[@"speed"] = @"1";
//        }else{
//            gameScore[@"armor"] = @"2";
//            gameScore[@"speed"] = @"2";
//        }
//
//        gameScore[@"equipment"] = dic[@"Equipment"];
//        gameScore[@"realName"] = dic[@"Name"];
//        gameScore[@"Affiliation"] = dic[@"Affiliation"];
//        [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                // The object has been saved.
//            } else {
//                // There was a problem, check error.description
//            }
//        }];
//    }

    
    
    
}

- (IBAction)uploadNow:(id)sender {
    
    PFObject *obj = [PFObject objectWithClassName:@"Video"];
    
    [obj setObject:@"守成为大佬的之前你需要知道的事【KB呆又呆】" forKey:@"title"];
    [obj setObject:@"https://www.bilibili.com/video/av10595535" forKey:@"url"];
    [obj setObject:@"https://i1.hdslb.com/bfs/archive/5d4d866189cebe0cdf8966b1494fd72d480878fd.jpg" forKey:@"imageUrl"];
    [obj setObject:@"Common" forKey:@"mapName"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved!!!!!!!!");
        }
    }];
    
    
}
- (IBAction)gunClicked:(id)sender {
    
    [self.navigationController pushViewController:GetViewController(@"GunsViewController") animated:YES];
    
}
- (IBAction)gotoOperatorPanel:(id)sender {
    
    [self.navigationController pushViewController:GetViewController(@"OperatorViewController") animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
