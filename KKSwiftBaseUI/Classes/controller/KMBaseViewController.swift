//
//  KMBaseViewController.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/7.
//

import Foundation
import EmptyStateKit
import KKSwiftLib

open class KMBaseViewController: UIViewController,KMNavBarDelegate{
    
    deinit {
        print(NSStringFromClass(object_getClass(self) ?? KMBaseViewController.self)+"dealloc")
    }
    
    open weak var navBar:KMNavBar?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.KM_loadNavigationBar()
        self.KM_loadViews()
        self.KM_layoutConstraints()
    }
    
    open override var prefersStatusBarHidden: Bool{
        return false
    }
    
    open func KM_loadNavigationBar(){
        let v = KMNavBar.init()
        v.delegate = self
        v.setNavTitle(title: self.title ?? "")
        self.view.addSubview(v)
        self.navBar = v
        
        var isfullScreen = false
        if self.presentingViewController != nil{
            
            if #available(iOS 13.0, *){
                
                if self.navigationController != nil{
                    if self.navigationController?.modalPresentationStyle.rawValue != 0{
                        isfullScreen = false
                    }else{
                        isfullScreen = true
                    }
                }else{
                    
                    if self.modalPresentationStyle.rawValue != 0{
                        isfullScreen = false
                    }else{
                        isfullScreen = true
                    }
                }
            }else{
                isfullScreen = true
            }
        }else{
            isfullScreen = true
        }
        if isfullScreen {
            self.navBar?.snp.makeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.height.equalTo(NAV_HEIGHT)
            })
        }else{
            self.navBar?.navigationView?.snp.remakeConstraints({ (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(54)
            })
            self.navBar?.snp.remakeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.height.equalTo(54)
            })
        }
    }
    
    // MARK: ????????????????????????
    
    open func popGestureEnabled() -> Bool{
        return true
    }
    
    // MARK: ???????????????style

    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    open func KM_loadViews(){
        self.view.backgroundColor = UIColor.white
    }
    
    open func KM_layoutConstraints(){
        
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    open func KM_navBarLeftButtonClicked(sender: KMNavButton?) {
        navigationServices.pop(animated: true)
        print("KM_navBarLeftButtonClicked")
    }
    
    open func KM_navBarRightButtonClicked(sender: KMNavButton?) {
        print("KM_navBarRightButtonClicked")
    }
    
    open func KM_navBarTitleControlClicked(sender: UIControl?) {
        print("KM_navBarTitleControlClicked")
    }
    
}


extension KMlistViewController:EmptyStateDataSource{
    
    open func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage? {
        switch state as! MainState {
        case .noInternet: return UIImage(named: "Empty Inbox _Outline")
        case .noSearch: return UIImage(named: "Empty Inbox _Outline")

        }
    }

    open func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .noInternet:  return ""
        case .noSearch:  return ""

        }
    }

    open func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .noInternet: return "Start creating your document library"
        case .noSearch: return "Start creating your document library"
        }
    }

    open func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .noInternet: return ""
        case .noSearch: return ""
        }
    }
    
}

open class KMlistViewController: KMBaseViewController, UITableViewDataSource ,UITableViewDelegate{
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UITableViewCell.init()
    }
    
    open var dataArray:Array<Any>?
    open weak var tableView:UITableView?
    
    open override func KM_loadViews() {
        super.KM_loadViews()
        do{
            let tb = UITableView.init()
            tb.dataSource = self
            tb.delegate = self
            tb.estimatedRowHeight = 200//???????????????????????????
            tb.rowHeight = UITableView.automaticDimension
            tb.separatorStyle = .none
            self.view .addSubview(tb)
            self.tableView = tb
        }
    }
    
    open override func KM_layoutConstraints() {
        super.KM_layoutConstraints()
        self.tableView?.snp.makeConstraints({ make in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
}
 
open class KMAlertController: UIAlertController {
     
    override open func viewDidLoad() {
        super.viewDidLoad()
         
        //?????????????????????????????????????????????
        let titleFont = UIFont.systemFont(ofSize: 20)
        let titleAttribute = NSMutableAttributedString.init(string: self.title!)
        titleAttribute.addAttributes([NSAttributedString.Key.font:titleFont,
                                      NSAttributedString.Key.foregroundColor:UIColor.black],
                                     range:NSMakeRange(0, (self.title?.count)!))
        self.setValue(titleAttribute, forKey: "attributedTitle")
         
        //????????????????????????????????????
        let messageFontDescriptor = UIFontDescriptor.init(fontAttributes: [
            UIFontDescriptor.AttributeName.family:"Arial",
            UIFontDescriptor.AttributeName.name:"Arial-ItalicMT",
            ])
         
        let messageFont = UIFont.init(descriptor: messageFontDescriptor, size: 13.0)
        let messageAttribute = NSMutableAttributedString.init(string: self.message!)
        messageAttribute.addAttributes([NSAttributedString.Key.font:messageFont,
                                        NSAttributedString.Key.foregroundColor:UIColor.black],
                                    range:NSMakeRange(0, (self.message?.count)!))
        self.setValue(messageAttribute, forKey: "attributedMessage")
    }
     
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


open class KMNavigationController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    var interfaceStyle:KMInterfaceStyle = .light{
        didSet{
            
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: interfaceStyle.rawValue) ?? .light
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    var panGesture : UIPanGestureRecognizer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        self.setNavigationBarHidden(true, animated: false)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.interfaceStyle = .light
        self.interactivePopGestureRecognizer?.isEnabled = false
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture!)
        panGesture?.delegate = self
        self.delegate = self
        
        
    }
    @objc func handlePanGesture(_ panGesture : UIPanGestureRecognizer) {
        self.interactivePopGestureRecognizer?.delegate?.perform((Selector(("handleNavigationTransition:"))), with: panGesture)
        
        if panGesture.state == UIGestureRecognizer.State.began {
        }
        else if panGesture.state == UIGestureRecognizer.State.ended{
        }
    }
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer.view == self.view && gestureRecognizer.location(in: view).x < (KMDistanceToStart == 0 ? UIScreen.main.bounds.width : KMDistanceToStart)) {
            
            if let controller = self.visibleViewController{
                if controller is KMBaseViewController && self.viewControllers.count > 1{
                    let vc = controller as! KMBaseViewController
                    return vc.popGestureEnabled()
                }
            }
        }
        return false
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) || otherGestureRecognizer.isKind(of: NSClassFromString("UIPanGestureRecognizer")!) || otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPagingSwipeGestureRecognizer")!) {
            let aView = otherGestureRecognizer.view
            if aView!.isKind(of: UIScrollView.self) {
                let sv = aView as! UIScrollView
                if sv.contentOffset.x == 0 {
                    if otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) && otherGestureRecognizer.state != .began {
                        return false
                    }
                    return true
                }
            }
            return false
        }
        return true
    }
    
    //MARK: UINavigationControllerDelegate
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print(viewController.self)
        
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print(viewController.self)
    }
}
