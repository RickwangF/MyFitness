//
//  CooperationViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "CooperationViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "Cooperation.h"
#import "UIImage+UIColor.h"
#import "AppStyleSetting.h"
#import <SDWebImage//UIImageView+WebCache.h>
#import "CooperationTableCell.h"
#import "CooperationDetailViewController.h"
#import "MyFitness-Swift.h"
#import <Hero/Hero-Swift.h>
#import "HeroIDModel.h"

@interface CooperationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *cooperateTableView;

@property (nonatomic, strong) NSMutableArray<Cooperation*> *cooperArray;

@end

@implementation CooperationViewController

#pragma mark - Init

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (void)initValueProperty{
	_cooperArray = [[NSMutableArray alloc] init];
}

#pragma mark - Lift Circle

- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	self.navigationItem.backBarButtonItem = [UIBarButtonItem new];
	self.title = @"合作伙伴";
	
	[self initCooerateTableView];
	
	[self getAllCooperation];
	
	//[self insertData];
    // Do any additional setup after loading the view.
}

#pragma mark - Insert Data

- (void)insertData{
	NSString *title = @"MyFitness 开发者RickWang";
	NSString *content1 = @"RickWang今年28岁，现居昆明，从事iOS开发一年多，之前有三年的.Net后端开发经验，也参与过一个Android原生项目的开发，有一定的项目管理经验和项目设计经验。";
	NSString *content2 = @"现在，我能熟练使用Swift和Objective-C进行iOS App的开发，在业余时间还学习了使用Vue和Webpack开发WebApp，也成功将公司原生iOS App的一个模块使用WebApp的形式实现了。具体的实现效果请在AppStore中搜索“导游助考宝”，由于公司规模有限，iOS的开发工作也都是我独立完成。";
	NSString *content3 = @"开发MyFitness项目的初衷是为了锻炼自己的Objective-C的编程能力，由于之前学习iOS使用的是Swift语言，后来成功上架的App也是使用的Swift，没有经过实战的编程能力是无法令人信服的，所以利用一个月的业余时间开了这个App。MyFitness没有组件化，没有使用MVP结构，使用的还是经典的MVC结构。项目中使用了一部分的Swift开源库，也做了一定的混编来实现预期效果。";
	NSString *content4 = @"希望在2019年进入到一个更大的公司继续从事并学习iOS开发，Flutter1.0版本已经发布了，新的一年我还将致力于学习和实践跨平台开发和前端工程化，在Facebook重构完ReactNative后，也一定会抽时间跟进学习。";
	NSString *imageUrl = @"http://lc-gytbbdn5.cn-n1.lcfile.com/3c5e606823278a7be9f1.png";
	
	AVObject *object = [AVObject objectWithClassName:@"Cooperation"];
	[object setObject:title forKey:@"title"];
	[object setObject:@[content1, content2, content3, content4] forKey:@"content"];
	[object setObject:imageUrl forKey:@"imageUrl"];
	[object setObject:@(0) forKey:@"orderIndex"];
	[object setObject:@(YES) forKey:@"darkImage"];
	[object saveInBackground];
}

#pragma mark - Init View

- (void)initCooerateTableView{
	_cooperateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
	_cooperateTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	_cooperateTableView.delegate = self;
	_cooperateTableView.dataSource = self;
	_cooperateTableView.rowHeight = 300;
	_cooperateTableView.estimatedRowHeight = 0;
	_cooperateTableView.estimatedSectionHeaderHeight = 0;
	_cooperateTableView.estimatedSectionFooterHeight = 0;
	_cooperateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	if (@available(iOS 11.0, *)) {
		_cooperateTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	UINib *cellNib = [UINib nibWithNibName:@"CooperationTableCell" bundle:NSBundle.mainBundle];
	[_cooperateTableView registerNib:cellNib forCellReuseIdentifier:@"cooperCell"];
	
	[self.view addSubview:_cooperateTableView];
	
	[_cooperateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.bottom.right.equalTo(self.view);
	}];
}

#pragma mark - Request

- (void)getAllCooperation{
	AVQuery *query = [AVQuery queryWithClassName:@"Cooperation"];
	[query orderByAscending:@"orderIndex"];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		
		if (error != nil) {
			[self.view makeToast:error.localizedDescription];
			return;
		}
		
		if (objects == nil || objects.count == 0) {
			[self.view makeToast:@"没有查询到合作对象"];
			return;
		}
		
		for (NSDictionary *object in objects) {
			Cooperation *cooper = [Cooperation cooperationWithDictionary:object];
			[self.cooperArray addObject:cooper];
		}
		
		[self.cooperateTableView reloadData];
	}];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _cooperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	CooperationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cooperCell" forIndexPath:indexPath];
	Cooperation *cooper = _cooperArray[indexPath.row];
	cell.contentView.heroID = [NSString stringWithFormat:@"container%ld", (long)indexPath.row];
	cell.titleLabel.text = cooper.title;
	cell.titleLabel.heroID = [NSString stringWithFormat:@"title%ld", (long)indexPath.row];
	if (cooper.darkImage) {
		cell.titleLabel.textColor = UIColor.whiteColor;
	}
	cell.topImageView.heroID = [NSString stringWithFormat:@"image%ld", (long)indexPath.row];
	[cell.topImageView sd_setImageWithURL:[NSURL URLWithString:cooper.imageUrl]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	Cooperation *cooper = _cooperArray[indexPath.row];
	HeroIDModel *model = [[HeroIDModel alloc] init];
	model.containerId = [NSString stringWithFormat:@"container%ld", (long)indexPath.row];
	model.imageId = [NSString stringWithFormat:@"image%ld", (long)indexPath.row];
	model.titleId = [NSString stringWithFormat:@"title%ld", (long)indexPath.row];
	CooperationDetailViewController *detailVC = [[CooperationDetailViewController alloc] initWithCooperation:cooper HeroId:model];
	DropDismissNaviViewController *naviVC = [[DropDismissNaviViewController alloc] initWithRootViewController:detailVC];
	[self presentViewController:naviVC animated:YES completion:nil];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
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
