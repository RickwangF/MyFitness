//
//  RootNaviViewController.swift
//  GuideExamAppIos
//
//  Created by Rick Wang on 2018/5/31.
//  Copyright © 2018年 KMZJ. All rights reserved.
//

import UIKit
import Hero

/*
 导游助考宝项的根导航控制器
 在第一次启动应用的时候，根导航中嵌入的是引导页，登录过后回到首页
 不是第一次启动应用的话，根导航中嵌入的是TabbarController
 根导航中设置了一个屏幕边框侧滑的手势识别器，用于为Present打开的ViewController添加侧滑返回功能
 而侧滑返回的转场动画由Hero来实现，动画效果和系统内置的Push和Pull一样
 */
class RootNaviViewController: UINavigationController{
    
    public var edgeSwipeRecognizer: UIScreenEdgePanGestureRecognizer!
    var disableTransition: Bool = false
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.hero.isEnabled = true
        self.modalPresentationStyle = .fullScreen
        self.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
    }
    
    // 通过该方法初始化的导航控制器都没有对侧滑手势识别器进行初始化
    init(rootViewController: UIViewController, disableTransition: Bool){
        super.init(rootViewController: rootViewController)
        self.disableTransition = disableTransition
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 禁用手势侧滑
        if disableTransition{
            return
        }
        
        edgeSwipeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeSwipped(_:)))
        edgeSwipeRecognizer.edges = .left
        self.view.addGestureRecognizer(edgeSwipeRecognizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if edgeSwipeRecognizer != nil{
            self.view.removeGestureRecognizer(edgeSwipeRecognizer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edgeSwipped(_ sender: UIScreenEdgePanGestureRecognizer){
        let translation = sender.translation(in: nil)
        let progress = translation.x / 2 / self.view.bounds.width
        if self.viewControllers.count > 1{
            if sender.state == .began{
                self.popViewController(animated: true)
            }
            else if sender.state == .changed{
                Hero.shared.update(progress)
            }
            else if sender.state == .ended || sender.state == .cancelled{
                if sender.velocity(in: nil).x / self.view.bounds.width > 0.3 || progress > 0.3{
                    Hero.shared.finish()
                }
                else{
                    Hero.shared.cancel()
                }
            }
        }
        else if self.viewControllers.count == 1{
            if sender.state == .began{
                self.dismiss(animated: true, completion: nil)
            }
            else if sender.state == .changed{
                Hero.shared.update(progress)
            }
            else if sender.state == .ended || sender.state == .cancelled{
                if sender.velocity(in: nil).x / self.view.bounds.width > 0.3 || progress > 0.3{
                    Hero.shared.finish()
                }
                else{
                    Hero.shared.cancel()
                }
            }
        }
        else{
            return
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
