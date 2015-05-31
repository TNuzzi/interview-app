//
//  ListTableViewCell.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/23/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    // Make image view round
    [self.image.layer setCornerRadius:25];
    [self.image.layer setMasksToBounds:YES];
}
@end
