//
//  KCWebController.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/12/8.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

open class KCWebViewController : UIViewController {
    open var url : URL!
    open let webView = UIWebView()
    
    open var loadViewAction : (UIViewController)->() = { _ in
    }
    
    public init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.init(white: 241.0/255, alpha: 1)        
        loadViewAction(self)
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        webView.loadRequest(URLRequest.init(url: url))
    }
}
