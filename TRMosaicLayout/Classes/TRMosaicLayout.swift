//
//  TRMosaicLayout.swift
//  Pods
//
//  Created by Vincent Le on 7/1/16.
//
//

import UIKit

public enum TRMosaicCellType {
    case Big
    case Small
}

public protocol TRMosaicLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:NSIndexPath) -> TRMosaicCellType
    
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets
    
    func heightForSmallMosaicCell() -> CGFloat
}

public class TRMosaicLayout: UICollectionViewLayout {
    
    public var delegate:TRMosaicLayoutDelegate!
    
    var columnHeightsInSection:[CGFloat] = [0, 0, 0]
    
    var cachedCellLayoutAttributes = [NSIndexPath:UICollectionViewLayoutAttributes]()
    
    let numberOfColumnsInSection = 3
    
    var contentWidth:CGFloat {
        get { return collectionView!.bounds.size.width }
    }
    
    // MARK: UICollectionViewLayout Implementation
    
    override public func prepareLayout() {
        super.prepareLayout()
        
        resetLayoutState()
        
        // Queue containing cells that have yet to be added due to column constraints
        var smallCellIndexPathBuffer = [NSIndexPath]()
        
        var lastBigCellOnLeftSide = false
        
        // Loops through all items in the first section, this layout has only one section
        for cellIndex in 0..<collectionView!.numberOfItemsInSection(0) {
            
            let cellIndexPath = NSIndexPath(forItem: cellIndex, inSection: 0)
            let cellType:TRMosaicCellType = mosaicCellType(index: cellIndexPath)
          
            if cellType == .Big {
                addBigCellLayout(atIndexPath: cellIndexPath, atColumn: lastBigCellOnLeftSide ? 1 : 0)
                lastBigCellOnLeftSide = !lastBigCellOnLeftSide
            } else if cellType == .Small {
                smallCellIndexPathBuffer.append(cellIndexPath)
                if smallCellIndexPathBuffer.count >= 2 {
                    let column = indexOfShortestColumn()
                    
                    addSmallCellLayout(atIndexPath: smallCellIndexPathBuffer[0], atColumn: column)
                    addSmallCellLayout(atIndexPath: smallCellIndexPathBuffer[1], atColumn: column)
                    
                    smallCellIndexPathBuffer.removeAll()
                }
            }
        }
        
        if !smallCellIndexPathBuffer.isEmpty {
            addSmallCellLayout(atIndexPath: smallCellIndexPathBuffer[0], atColumn: indexOfShortestColumn())
            smallCellIndexPathBuffer.removeAll()
        }
    }
    
    /**
     Returns the entire content view of the collection view
     */
    override public func collectionViewContentSize() -> CGSize {
        let height = columnHeightsInSection.sort().last
        guard let _ = height else {
           return CGSizeMake(contentWidth, 0)
        }
        return CGSizeMake(contentWidth, height!)
    }
    
    /**
     Returns all layout attributes within the given rectangle
     */
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        cachedCellLayoutAttributes.forEach {
            if CGRectIntersectsRect(rect, $1.frame) {
                attributesInRect.append($1)
            }
        }
        return attributesInRect
    }
    
    // MARK: Layout
    
    /**
     Configures the layout for cell type: Big
     Adds the new layout to cache
     Updates the column heights for each effected column
     */
    func addBigCellLayout(atIndexPath indexPath:NSIndexPath, atColumn column:Int) {
        let cellHeight = layoutAttributes(withCellType: .Big, indexPath: indexPath, atColumn: column)
        
        updateColumnHeights(atColumn: column, withHeight: cellHeight)
        updateColumnHeights(atColumn: column + 1, withHeight: cellHeight)
    }
    
    /**
     Configures the layout for cell type: Small
     Adds the new layout to cache
     Updates the column heights for each effected column
     */
    func addSmallCellLayout(atIndexPath indexPath:NSIndexPath, atColumn column:Int) {
        let cellHeight = layoutAttributes(withCellType: .Small, indexPath: indexPath, atColumn: column)
        
        updateColumnHeights(atColumn: column, withHeight: cellHeight)
    }
    
    /**
     Creates layout attribute with the given parameter and adds it to cache
     
     - parameter type:      Cell type
     - parameter indexPath: Index of cell
     - parameter column:    Index of column
     
     - returns: new cell height from layout
     */
    func layoutAttributes(withCellType type:TRMosaicCellType, indexPath:NSIndexPath, atColumn column:Int) -> CGFloat {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let frame = mosaicCellRect(withType: type, atIndexPath: indexPath, atColumn: column)
        
        layoutAttributes.frame = frame
        
        let cellHeight = layoutAttributes.frame.size.height + insetForMosaicCell().top
        
        cachedCellLayoutAttributes[indexPath] = layoutAttributes
        
        return cellHeight
    }
    
    /**
     Updates the specific column with the new height
     
     - parameter column: Specific column
     - parameter height: New height
     */
    func updateColumnHeights(atColumn column:Int, withHeight height: CGFloat) {
        columnHeightsInSection[column] += height
    }
    
    // MARK: Cell Sizing
    
    /**
     Creates the bounding rectangle for the given cell type
     
     - parameter type:      Cell type
     - parameter indexPath: Index of cell
     - parameter column:    Index of column
     
     - returns: Bounding rectangle
     */
    func mosaicCellRect(withType type: TRMosaicCellType, atIndexPath indexPath:NSIndexPath, atColumn column:Int) -> CGRect {
        var cellHeight = cellContentHeightFor(mosaicCellType: type)
        var cellWidth = cellContentWidthFor(mosaicCellType: type)
        
        var originX = CGFloat(column) * (contentWidth / CGFloat(numberOfColumnsInSection))
        var originY = columnHeightsInSection[column]
        
        let sectionInset = insetForMosaicCell()
        
        originX += sectionInset.left
        originY += sectionInset.top
        
        cellWidth -= sectionInset.right
        cellHeight -= sectionInset.bottom
        
        return CGRectMake(originX, originY, cellWidth, cellHeight)
    }
    
    /**
     Calculates height for the given cell type
     
     - parameter cellType: Cell type
     
     - returns: Calculated height
     */
    func cellContentHeightFor(mosaicCellType cellType:TRMosaicCellType) -> CGFloat {
        let height = delegate.heightForSmallMosaicCell()
        if cellType == .Big {
            return height * 2
        }
        return height
    }
    
    /**
     Calculates width for the given cell type
     
     - parameter cellType: Cell type
     
     - returns: Calculated width
     */
    func cellContentWidthFor(mosaicCellType cellType:TRMosaicCellType) -> CGFloat {
        let width = contentWidth / 3
        if cellType == .Big {
            return width * 2
        }
        return width
    }
    
    // MARK: Orientation
    
    /**
     Determines if a layout update is needed when the bounds have been changed
     
     - returns: True if layout needs update
     */
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let currentBounds:CGRect = self.collectionView!.bounds
        
        if CGSizeEqualToSize(currentBounds.size, newBounds.size) {
            self.prepareLayout()
            return true
        }
        
        return false
    }
    
    // MARK: Delegate Wrappers
    
    /**
     Returns the cell type for the specified cell at index path
     
     - returns: Cell type
     */
    func mosaicCellType(index indexPath:NSIndexPath) -> TRMosaicCellType {
        return delegate.collectionView(collectionView!, mosaicCellSizeTypeAtIndexPath:indexPath)
    }
    
    /**
     - returns: Returns the UIEdgeInsets that will be used for every cell as a border
     */
    func insetForMosaicCell() -> UIEdgeInsets {
        return delegate.collectionView(collectionView!, layout: self, insetAtSection: 0)
    }
}

extension TRMosaicLayout {
    
    // MARK: Helper Functions
    
    /**
     - returns: The index of the column with the smallest height
     */
    func indexOfShortestColumn() -> Int {
        var index = 0
        for i in 1..<columnHeightsInSection.count {
            if columnHeightsInSection[i] < columnHeightsInSection[index] {
                index = i
            }
        }
        return index
    }
    
    /**
     Resets the layout cache and the heights array
     */
    func resetLayoutState() {
        columnHeightsInSection = [0, 0, 0]
        cachedCellLayoutAttributes = [NSIndexPath:UICollectionViewLayoutAttributes]()
    }
}