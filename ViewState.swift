/// State of a view
///
/// - loading: loading state
/// - empty: empty state
/// - failure: failure state
enum ViewState: Equatable {
    case loading
    case empty
    case failure(message: String)
}
