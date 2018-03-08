//
//  KCTextController.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/12/8.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

open class KCTextController : UIViewController {
    open let textView = UITextView()
    var loadViewAction : ((KCTextController)->())?
    
    open class func showContent(_ content: String
            , showAction: (KCTextController)->()
            , loadViewAction: ((KCTextController)->())?=nil) {
        let controller = KCTextController(content: content)
        controller.loadViewAction = loadViewAction
        showAction(controller)
    }
    
    open class func showAttributedContent(_ attributedContent: NSAttributedString
            , showAction: (KCTextController)->()
            , loadViewAction: ((KCTextController)->())?=nil) {
        let controller = KCTextController(attributedContent: attributedContent)
        controller.loadViewAction = loadViewAction
        showAction(controller)
    }
    
    public init(content: String) {
        super.init(nibName: nil, bundle: nil)
        textView.text  = content
    }
    
    public init(attributedContent: NSAttributedString) {
        super.init(nibName: nil, bundle: nil)
        textView.attributedText = attributedContent
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.init(white: 241.0/255, alpha: 1)
        self.setNavTitle(self.title ?? "", titleColor: UIColor.white)        
        
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.black
        textView.isEditable = false
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        loadViewAction?(self)
    }
}
