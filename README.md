# TextViewsInsideListViews

## Project Overview.

This project shows different approaches of lists in UIKit. You could use tables or collections views. Well, you could also go deeper and use scrolls and even generic views.

Current implementation is focused on comparison between tables and collections.

## The main screen

Main screen has following tabs:

- TableView
- TableVC (TableViewController)
- CollectionView
- CollectionVC (CollectionViewController)

### TableView

The common approach with `UITableView`, which was added to controller's view.

### TableVC (TableViewController)

The approach with `UITableViewController`, which was added to parent controller and its view (`tableView`) was added to parent controller's view.

### CollectionView

The common approach with `UICollectionView`, which was added to controller's view.
This approarch uses `UICompositionalLayout.list`

### CollectionVC (CollectionViewController)

The common appoarch with `UICollectionViewController`, which was added to parent controller and its view (`collectionView`) was added to parent controller's view.

### User Experience

- Cell is growing on typing.
- Insert new cell on pressing Enter in prevous cell textView.
- Focus is set in inserted cell.

### Our tasks

We would like to investigate and fix several issues.

- [ ] Check that cell's layout is not cropped after insertion.
- [ ] Check that cell is inserted at correct position if user press enter quickly.
- [ ] Check that cell is focused without animation after tapping on cell (not on textView ).