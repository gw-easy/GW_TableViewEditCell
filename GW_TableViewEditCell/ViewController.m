//
//  ViewController.m
//  GW_TableViewEditCell
//
//  Created by zdwx on 2018/12/29.
//  Copyright © 2018 DoubleK. All rights reserved.
//

#import "ViewController.h"
#import "GW_EditCell/GW_EditCell.h"
#import "TestModel.h"
@interface ViewController ()<GW_EditCellDelegate>

@property (nonatomic, strong)NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _datas = [NSMutableArray arrayWithArray:[TestModel getAllDatas]];
    [self.tableView reloadData];
}

//MARK: editcell-delegate
-(void)editCell:(GW_EditCell *)editCell atIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index{
    switch (index-100) {
        case 0:
            
            break;
        case 1:
            [self.datas removeObjectAtIndex:indexPath.row];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case 2:
            
            break;
        default:
            break;
    }
}


-(BOOL)editCell:(GW_EditCell *)editCell canSwipeRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %4 == 0) {
        return NO;
    }
    return YES;
}


-(NSArray<UIButton *> *)editCell:(GW_EditCell *)editCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestModel *model = [_datas objectAtIndex:indexPath.row];
    
    switch (model.message_id) {
        case 0:{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 120, editCell.frame.size.height);
            btn.backgroundColor = [UIColor redColor];
            [btn setTitle:@"test1" forState:UIControlStateNormal];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(CGRectGetMaxX(btn.bounds), 0, 60, editCell.frame.size.height);
            btn2.backgroundColor = [UIColor greenColor];
            [btn2 setTitle:@"删除" forState:UIControlStateNormal];
            return @[btn, btn2];
        }
            break;
        case 1:{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 60, editCell.frame.size.height);
            btn.backgroundColor = [UIColor blueColor];
            [btn setTitle:@"test2" forState:UIControlStateNormal];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(CGRectGetMaxX(btn.bounds), 0, 60, editCell.frame.size.height);
            btn2.backgroundColor = [UIColor yellowColor];
            [btn2 setTitle:@"c删除" forState:UIControlStateNormal];
            return @[btn, btn2];
        }
            break;
        case 2:{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 60, editCell.frame.size.height);
            btn.backgroundColor = [UIColor brownColor];
            [btn setTitle:@"test3" forState:UIControlStateNormal];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(CGRectGetMaxX(btn.bounds), 0, 60, editCell.frame.size.height);
            btn2.backgroundColor = [UIColor orangeColor];
            [btn2 setTitle:@"删除" forState:UIControlStateNormal];
            return @[btn, btn2];
        }
            break;
            
        default:
            return @[];
            break;
    }
    
    
}


#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestModel *model = [_datas objectAtIndex:indexPath.row];
    GW_EditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewCell"];
    if (!cell) {
        cell = [[GW_EditCell alloc] initWithStyle:0 reuseIdentifier:@"TestTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    cell.textLabel.text = model.name;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    TMExpandViewController *vc = [TMExpandViewController new];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
