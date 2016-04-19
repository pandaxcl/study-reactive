//
//  ViewController.m
//  study-reactive-login
//
//  Created by 熊 春雷 on 16/4/15.
//  Copyright © 2016年 pandaxcl. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSUInteger, Gender) {
    Gender_UNKNOWN,
    Gender_MALE,
    Gender_FEMALE,
};

@interface Person: NSObject
@property(copy)   NSString*  name;  // 姓名
@property(assign) Gender     gender;// 性别
@property(assign) NSUInteger age;   // 年龄
@end

@implementation Person

-(instancetype)initWithName:(NSString*)name gender:(Gender)gender age:(NSUInteger)age
{
    self = [super init];
    if (self) {
        self.name = name;
        self.gender = gender;
        self.age = age;
    }
    return self;
}

@end

#pragma mark -

@interface Model: NSObject
@property(strong) NSMutableArray<Person*>*persons;
@end

@implementation Model

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.persons = [[NSMutableArray<Person*> alloc] init];
        
        [self.persons addObjectsFromArray: @[
                                             [[Person alloc] initWithName:@"陈一" gender:Gender_MALE   age:33],
                                             [[Person alloc] initWithName:@"黄二" gender:Gender_FEMALE age:27],
                                             [[Person alloc] initWithName:@"张三" gender:Gender_MALE   age:20],
                                             [[Person alloc] initWithName:@"李四" gender:Gender_FEMALE age:22],
                                             [[Person alloc] initWithName:@"王五" gender:Gender_MALE   age:38],
                                             [[Person alloc] initWithName:@"赵六" gender:Gender_FEMALE age:25],
                                             [[Person alloc] initWithName:@"钱七" gender:Gender_MALE   age:23],
                                             [[Person alloc] initWithName:@"孙八" gender:Gender_MALE   age:40],
                                             [[Person alloc] initWithName:@"杨九" gender:Gender_MALE   age:43],
                                             [[Person alloc] initWithName:@"吴十" gender:Gender_FEMALE age:36],
                                             ]];
    }
    return self;
}

@end

#pragma mark -

@interface PersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_photo;
@property (weak, nonatomic) IBOutlet UITextField *textField_name;
@property (weak, nonatomic) IBOutlet UITextField *textField_gender;
@property (weak, nonatomic) IBOutlet UITextField *textField_age;

@property(strong) Person*person;
@end

@implementation PersonTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //RAC(self, textField_name.text) = [self.person rac_valuesForKeyPath:@"name" observer:self];
        RAC(self, textField_name.text) = [self rac_valuesForKeyPath:@"person.name" observer:self];
        RAC(self, textField_gender.text) = [[self rac_valuesForKeyPath:@"person.gender" observer:self] map:^id(NSNumber* value) {
            NSString*gender = @"未知性别";
            if ([value unsignedIntegerValue] == Gender_MALE) gender = @"男";
            if ([value unsignedIntegerValue] == Gender_FEMALE) gender = @"女";
            return [NSString stringWithFormat:@"性别：%@", gender];
        }];
        RAC(self, textField_age.text) = [[self rac_valuesForKeyPath:@"person.age" observer:self] map:^id(NSNumber* value) {
            return [NSString stringWithFormat:@"年龄：%@", value];
        }];
        RAC(self, imageView_photo.image) = [[self rac_valuesForKeyPath:@"person.gender" observer:self] map:^id(NSNumber* value) {
            UIImage*gender = [UIImage imageNamed:@"gender_unknown"];
            if ([value unsignedIntegerValue] == Gender_MALE) gender = [UIImage imageNamed:@"gender_male"];
            if ([value unsignedIntegerValue] == Gender_FEMALE) gender = [UIImage imageNamed:@"gender_female"];
            return gender;
        }];
    }
    return self;
}

@end

#pragma mark -

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong) Model*model;
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.model = [Model new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*reuseIdentifier = @"搞什么灰机";
    PersonTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.person = [self.model.persons objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.persons count];
}

@end
