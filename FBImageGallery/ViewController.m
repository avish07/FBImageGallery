//
//  ViewController.m
//  FBImageGallery
//
//  Created by gh on 4/13/17.
//  Copyright © 2017 Slack. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController (){
    NSMutableArray *imgsArr, *captionsArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    imgsArr = [[NSMutableArray alloc] init];
    captionsArr = [[NSMutableArray alloc] init];
    
    
    imgsArr = [@[@"https://www.gstatic.com/webp/gallery/1.jpg", @"https://www.gstatic.com/webp/gallery/2.jpg", @"https://www.gstatic.com/webp/gallery/3.jpg", @"https://www.gstatic.com/webp/gallery/4.jpg", @"https://www.gstatic.com/webp/gallery3/5.png"] mutableCopy];
    
    for (int i = 1; i <= 7; i++) {
        [captionsArr addObject:[NSString stringWithFormat:@"Image%d", i]];
    }
    
    [collectionObj setDataSource:self];
    [collectionObj setDelegate:self];
    [collectionObj reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self addNotification];
    [super viewWillAppear:animated];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GalleryClosed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageScroll:) name:@"GalleryClosed" object:nil];
}

-(void)imageScroll:(NSNotification *)notify{
    [collectionObj scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[notify.object integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

#pragma mark - UICollectionView datasource and delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width, collectionView.frame.size.height);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imgsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdentifier = @"ImageCollectionCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        __weak UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:1];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity startAnimating];
        [activity setFrame:CGRectMake(self.view.bounds.size.width/2 - activity.frame.size.width / 2, img.frame.origin.y + (collectionView.frame.size.height / 2), activity.frame.size.width, activity.frame.size.height)];
        [activity setHidesWhenStopped:true];
        [img addSubview:activity];
        [img setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imgsArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"default_propertyImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [activity stopAnimating];
            [img setImage:image];
            NSLog(@"success");
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [activity stopAnimating];
            NSLog(@"failure");
        }];
        
        [img setupImageViewerWithDatasource:self initialIndex:indexPath.item onOpen:^{
            
            // write code when image is opened
            
        } onClose:^{
            // wirte code when image is closed
            
        }];
        
        return cell;
}


#pragma mark - MHFaceBookViewer Protocol

-(NSInteger)numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer{
    return imgsArr.count;
}

-(UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return [UIImage imageNamed:@"default_propertyImage"];
}

-(NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"captionNotification" object:nil userInfo:@{@"caption": captionsArr[index], @"imageIndex": [NSString stringWithFormat:@"%ld", (long)index + 1], @"imagesCount": [NSString stringWithFormat:@"%lu", (unsigned long)imgsArr.count]}];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@", imgsArr[index]]];
}


@end
