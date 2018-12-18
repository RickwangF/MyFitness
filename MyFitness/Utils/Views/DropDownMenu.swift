//
//  DropDownMenu.swift
//  MyFitness
//
//  Created by Rick Wang on 2018/12/17.
//  Copyright © 2018 KMZJ. All rights reserved.
//

import UIKit
import DropDown

class DropDownMenu: DropDown {
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUpUI()
	}
	
	fileprivate func setUpUI() {
		DropDown.appearance().cellHeight = 52.5
		DropDown.appearance().shadowColor = UIColor(white: 1.0, alpha: 0)
		DropDown.appearance().shadowOffset = CGSize(width: 0, height: 0)
		DropDown.appearance().selectedTextColor = UIColor(red: 240.0/255, green: 200.0/255, blue: 0, alpha: 1.0)
		DropDown.appearance().cornerRadius = 0
		DropDown.appearance().selectionBackgroundColor = UIColor.white;
	}
	
	@objc public func setAnchorView(_ anchorView: AnchorView){
		self.anchorView = anchorView
	}
	
	@objc public func setWidth(_ width: CGFloat){
		self.width = width
	}
	
	@objc public func setDataSource(_ source: [String]){
		self.dataSource = source
	}
	
	@objc public func setDirectionBottom(){
		self.direction = .bottom
	}
	
	@objc public func setSelectionCallback(_ callback: SelectionClosure?){
		self.selectionAction = callback
	}

	@objc public func setBottomOffset(_ offset: CGPoint){
		self.bottomOffset = offset
	}
	
	@objc public func showMenu(){
		self.show()
	}
	
}
