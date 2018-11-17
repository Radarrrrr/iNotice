//
//  ToDoCell.h
//  Radar Use
//
//  Created by Radar on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define to_do_cell_height 60.0


@interface ToDoCell : UITableViewCell {

	UILabel *_descLabel;
    UILabel *_dateLabel;
    
    UILabel *_indexLabel;
}



#pragma mark -
#pragma mark in use functions



#pragma mark -
#pragma mark out use functions
- (void)setCellData:(id)data; //data is ToDoInfo
- (void)setCellIndexPath:(NSIndexPath*)indexPath;



@end
