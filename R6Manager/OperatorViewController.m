//
//  OperatorViewController.m
//  R6Manager
//
//  Created by 杨成阳 on 2018/9/20.
//  Copyright © 2018年 杨成阳. All rights reserved.
//

#import "OperatorViewController.h"

@interface OperatorViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation OperatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSource = [[NSMutableArray alloc] init];
    
    WEAKSELF
    PFQuery *query = [PFQuery queryWithClassName:@"Operator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count) {
            [blockSelf.dataSource addObjectsFromArray:objects];
            [blockSelf.tableView reloadData];
        }
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cid = @"cid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
    }
    PFObject *obj = _dataSource[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:obj[@"logoUrl"]] options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur];
    cell.textLabel.text = obj[@"name"];
    cell.detailTextLabel.text = obj[@"Intro"];
    [self.view layoutIfNeeded];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PFObject *obj = _dataSource[indexPath.row];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:obj[@"videos"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"【闻香识】《彩虹六号：围攻》用twitch对敌人进行惨绝人寰的电疗五杀" forKey:@"title"];
    [dic setObject:@"https://www.bilibili.com/video/av22602759" forKey:@"url"];
    [dic setObject:@"https://ss1.baidu.com/70cFfyinKgQFm2e88IuM_a/forum/pic/item/d058ccbf6c81800ac41d7e8bbd3533fa838b47bf.jpg" forKey:@"imageUrl"];
//    [arr addObject:[dic modelToJSONString]];
    [arr addObject:dic];
    obj[@"videos"] = arr;
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved!!!!!!!!");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
