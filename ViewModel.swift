/**
 ViewModel flow from the model to the view.
 
 Example:
 In order to see network data for a screen, model would make a new viewmodel with the corresponding event, and that view model would be rendered in the view.
 */
protocol ViewModel: Equatable {}
