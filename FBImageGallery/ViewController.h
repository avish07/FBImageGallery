//
//  ViewController.h
//  FBImageGallery
//
//  Created by gh on 4/13/17.
//  Copyright © 2017 Slack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MHFacebookImageViewerDatasource>{
    __weak IBOutlet UICollectionView *collectionObj;
}


@end

