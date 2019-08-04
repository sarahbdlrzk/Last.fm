//
//  CollectionViewModel.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 13..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

class CollectionViewModel: CollectionViewViewModel<CollectionCell, CollectionViewSource> {

    override func config(cell: CollectionCell, data: CollectionViewSource, indexPath: IndexPath, grid: Grid) {
        cell.source = data
    }

    override func size(data: CollectionViewSource, indexPath: IndexPath, grid: Grid, view: UIView) -> CGSize {
        return grid.size(for: view, height: 180, items: grid.columns)
    }
}
