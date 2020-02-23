//
//  LBannerView.swift
//  U17
//
//  Created by Lee on 2/23/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

enum PageControlDotStyle {
    case center(bottom: CGFloat), left(left: CGFloat, bottom: CGFloat), right(right: CGFloat, bottom: CGFloat), none
}

protocol Bannerable {
    init(_ url: [URL], config: BannerConfigable)
}
protocol BannerConfigable {
    
    var autoPlay: Bool { get }
    var playDuration: TimeInterval { get }
    var dotPosition: PageControlDotStyle {get}
    var orientation: UIPageViewController.NavigationOrientation {get}
    
}

protocol LBannerViewDelegate: class {
    func didTap(at index: Int)
}

struct DefaultConfig: BannerConfigable {
    var autoPlay: Bool {return true}
    
    var playDuration: TimeInterval {return 4}
    
    var dotPosition: PageControlDotStyle {return .center(bottom: 0)}
    
    var orientation: UIPageViewController.NavigationOrientation {
        return .horizontal
    }
    
    
    
}

class LBannerView: UIView, Bannerable {
    
    private class ImageViewController: UIViewController {
        var imageView: UIImageView!
        
        let url: URL
        
        var didTapCb: (() -> ())?
        
        init(url: URL) {
            self.url = url
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            imageView = UIImageView()
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))
            imageView.kf.setImage(urlString: url.absoluteString)
        }
        
        @objc private func handleGesture() {
            if let didTapCb = didTapCb {
                didTapCb()
            }
        }
    }
    private let urls: [URL]
    private let config: BannerConfigable
    private var currentSelectIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentSelectIndex
        }
    }
    private var vcs: [ImageViewController] = []
    private lazy var pageVc: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: config.orientation, options: nil)
        return vc
    }()
    weak var delegate: LBannerViewDelegate?
    private var timerForMovingCarousel: Timer!
    private var pageControl: UIPageControl!
    
    
    required init(_ urls: [URL], config: BannerConfigable = DefaultConfig()) {
        self.urls = urls
        self.config = config
        super.init(frame: .zero)
        makeImageViewController()
        makeUI()
        makePageControl()
        startTimerForMovingCarousel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTimer() {
        if urls.count > 0 {
            let index = currentSelectIndex + 1 > (urls.count - 1) ? 0 : currentSelectIndex + 1
            pageVc.setViewControllers([vcs[index]], direction: .forward, animated: true) { complete in
                if complete {
                    self.currentSelectIndex = index
                }
            }

        }
        
    }
    
    private func makeUI() {
        
        addSubview(pageVc.view)
        pageVc.delegate = self
        if urls.count > 1 {
            pageVc.dataSource = self
        }
        pageVc.setViewControllers([vcs[0]], direction: .reverse, animated: false, completion: nil)
        pageVc.view.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
    }
    
    func startTimerForMovingCarousel() {
        if self.timerForMovingCarousel == nil && urls.count > 1 && config.autoPlay {
            self.timerForMovingCarousel = Timer.scheduledTimer(timeInterval: config.playDuration, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimerForMovingCarousel() {
        if self.timerForMovingCarousel != nil {
            self.timerForMovingCarousel.invalidate()
            self.timerForMovingCarousel = nil
        }
        
    }
    
    private func makePageControl() {
//        guard config.dotPosition != PageControlDotStyle.none else {return}
        pageControl = UIPageControl()
        pageControl.numberOfPages = urls.count
        addSubview(pageControl)
        
        switch config.dotPosition {
        case .center(let bottom):
            pageControl.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-bottom)
            }
        case let .left(left, bottom):
            pageControl.snp.makeConstraints { make in
                make.left.equalTo(left)
                make.bottom.equalToSuperview().offset(-bottom)
            }
        case let .right(right, bottom):
            pageControl.snp.makeConstraints { make in
                make.left.equalTo(-right)
                make.bottom.equalToSuperview().offset(-bottom)
            }
        default:
            pageControl.removeFromSuperview()
        }
        
    }
    
    private func makeImageViewController() {
        vcs = urls.enumerated().map{
            let index = $0
            let vc = ImageViewController(url: $1)
            vc.didTapCb = {
                self.delegate?.didTap(at: index)
            }
            return vc
        }
    }
    
    
}

extension LBannerView: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController as! LBannerView.ImageViewController) else { return nil }
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else { return vcs.last }
        return vcs[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController as! LBannerView.ImageViewController) else { return nil }
        let afterIndex = index + 1
        guard afterIndex <= vcs.count - 1 else {
            return vcs.first
        }
        return vcs[afterIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.last,
            let index = vcs.firstIndex(of: viewController as! LBannerView.ImageViewController) else {
                return
        }
        currentSelectIndex = index
        
        startTimerForMovingCarousel()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        stopTimerForMovingCarousel()
    }
    
    
}
