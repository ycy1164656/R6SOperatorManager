//
//  GunsViewController.m
//  R6Manager
//
//  Created by 杨成阳 on 2018/9/20.
//  Copyright © 2018年 杨成阳. All rights reserved.
//

#import "GunsViewController.h"

@interface GunsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation GunsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSource = [[NSMutableArray alloc] init];
    
    WEAKSELF
    PFQuery *query = [PFQuery queryWithClassName:@"Gun"];
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
    [cell.imageView setImageWithURL:[NSURL URLWithString:obj[@"image"]] options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur];
    cell.textLabel.text = obj[@"name"];
    cell.detailTextLabel.text = obj[@"desc"];
    [self.view layoutIfNeeded];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
