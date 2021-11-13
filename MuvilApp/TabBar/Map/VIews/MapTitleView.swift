//
//  MapTitleView.swift
//  MuvilApp
//
//  Created by Fernando Perez on 11/7/21.
//

import UIKit

class MapTitleView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 8
    }
}
