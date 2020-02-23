//
//  LARefresh.swift
//  Lark
//
//  Created by ZengFanyi on 2019/4/4.
//  Copyright © 2019 曾凡怡. All rights reserved.
//
import MJRefresh

class LARefreshHeader : MJRefreshNormalHeader {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.arrowView.image = UIImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var state: MJRefreshState {
        didSet{
            labelLeftInset = 0
            stateLabel.text = ""
            lastUpdatedTimeLabel.text = ""
        }
    }
}
class LARefreshFooter : MJRefreshAutoStateFooter {
    override var state: MJRefreshState {
        didSet{
            switch state {
            case .noMoreData:
                stateLabel.text = ""
            default:
                stateLabel.text = ""
            }
        }
    }
}
