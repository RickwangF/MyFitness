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
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	self.title = @"合作伙伴";
	
	[self initCooerateTableView];
	
	[self getAllCooperation];
	
	//[self insertData];
    // Do any additional setup after loading the view.
}

#pragma mark - Insert Data

- (void)insertData{
	
	NSString *title = @"全新国产宝马3系长轴距版官图发布";
	NSString *content1 = @"日前，华晨宝马官方发布了全新一代3系长轴距版车型（代号G28）的官图。此次官图仅展示了M运动套件版本车型的造型，其沿用了海外版的设计。根据此前官方透露的信息，新车将于今年5月在华晨宝马铁西工厂正式投产。另据相关消息源透露，全新3系标准轴距版车型也将继续国产。";
	NSString *content2 = @"作为国产长轴距版本，全新3系Li基本沿用了海外版全新3系标准轴距版车型的设计风格，锐利的LED前大灯组与尺寸经过加大的亮黑色双肾式前格栅相接，搭配更加夸张的前包围进气口和更具立体感的线条，营造出了极为动感的车头造型。";
	NSString *content3 = @"虽然经过了加长，但新车侧面比例仍然协调，线条舒展而流畅。相比于现款车型，全新3系Li车型C柱处最新样式的霍夫迈斯特拐角取消了现款长轴距版专属的“小尾巴”造型，不再特殊。而在车尾部分，新车采用了平直锋利的尾灯组轮廓，内部L形的红色灯带营造出了凌厉的视觉效果。与此同时，M套件版本还拥有分色处理的黑色饰板及两侧的通风孔造型，搭配小型扰流板、双边共两出排气布局，视觉效果更为出色。";
	NSString *content4 = @"此前我们已经曝光了新车的申报信息。在尺寸方面，全新3系Li的长宽高分别为4829/1827/1463mm，轴距为2961mm，整体尺寸相较于现款3系长轴距版得到了全面提升。而相比海外版车型，全新3系长轴距版的轴距有着110mm的大幅度增加。";
	NSString *content5 = @"其它配置方面，新车还将根据车型配置的不同，提供普通版前/后包围、镀铬前格栅、车身同色或黑色外后视镜外壳、倒车影像/全景影像、多种样式轮圈以及不同车身标识等。动力方面，目前已经申报的全新3系Li搭载的是B48B20B型2.0T发动机，其最大功率与现款320i/Li同为184马力，但尾标已经变为了325Li。关于全新3系更多动力车型和配置方面的信息，我们也将持续关注。";
	NSString *content6 = @"";
	NSString *imageUrl = @"http://lc-gytbbdn5.cn-n1.lcfile.com/fb17f4c87cf7500fb727.JPG";
	
	AVObject *object = [AVObject objectWithClassName:@"Cooperation"];
	[object setObject:title forKey:@"title"];
	[object setObject:@[content1, content2, content3, content4, content5] forKey:@"content"];
	[object setObject:imageUrl forKey:@"imageUrl"];
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
	cell.titleLabel.text = cooper.title;
	if (cooper.darkImage) {
		cell.titleLabel.textColor = UIColor.whiteColor;
	}
	[cell.topImageView sd_setImageWithURL:[NSURL URLWithString:cooper.imageUrl]];
	return cell;
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
