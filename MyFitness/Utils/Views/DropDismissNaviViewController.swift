//
//  DropDismissNaviViewController.swift
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

import UIKit
import Hero

class DropDismissNaviViewController: UINavigationController {
	
	var dismissGesture: UIPanGestureRecognizer!
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		self.hero.isEnabled = true
		self.modalPresentationStyle = .fullScreen
		self.hero.modalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.zoom, dismissing: HeroDefaultAnimationType.zoomOut)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.hero.isEnabled = true
		self.modalPresentationStyle = .fullScreen
		self.hero.modalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.zoom, dismissing: HeroDefaultAnimationType.zoomOut)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		initDismissGesture()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	// MARK: - Init Gesture
	fileprivate func initDismissGesture() {
		dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissGestureRecognized(_:)))
		self.view.addGestureRecognizer(dismissGesture)
	}
	
	@IBAction func dismissGestureRecognized(_ sender: UIPanGestureRecognizer){
		let translation = sender.translation(in: nil)
		let progress = (translation.y / 2) / self.view.frame.height
		
		if self.viewControllers.count == 1{
			if sender.state == .began{
				self.dismiss(animated: true, completion: nil)
			}
			else if sender.state == .changed{
				Hero.shared.update(progress)
			}
			else if sender.state == .ended || sender.state == .cancelled{
				if sender.velocity(in: nil).y / self.view.frame.height > 0.3 || progress > 0.3{
					Hero.shared.finish(animate: true)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
