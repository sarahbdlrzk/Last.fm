//
//  SongViewModel.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 13..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

class SongViewModel: CollectionViewViewModel<SongCell, Track> {
    
    override func config(cell: SongCell, data: Track, indexPath: IndexPath, grid: Grid) {
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.textLabel.text = data.name
        if let duration = data.duration {
            let strDuration = String(duration)
            cell.detailTextLabel.text = strDuration
        }
    }
    
    override func size(data: Track, indexPath: IndexPath, grid: Grid, view: UIView) -> CGSize {
        return grid.size(for: view, height: 44, items: grid.columns)
    }
}
