import RxSwift

protocol Model: class {
    associatedtype VM: Equatable
    associatedtype INTENT: Equatable
    associatedtype ACTION: Equatable
    
    var disposables: CompositeDisposable { get }
    var viewModel: BehaviorSubject<VM> { get }
    var events: PublishSubject<Event> { get }
    var actions: PublishSubject<ACTION> { get }

    /// Attach the model to an intent stream
    ///
    /// Usage:
    ///    override func viewDidLoad() {
    ///        super.viewDidLoad()
    ///        attach(viewModel: model.getViewModel(), actions: model.getActions())
    ///        model.attach(intents: getIntents())
    ///    }
    func attach(intents: Observable<INTENT>)
    
    /// Detach the model from previously attached intent stream
    func detach()
    
    /// Create new model with original viewmodel and
    func reduce(model: VM, event: Event) -> VM
    
    /// Map Intent to Event
    func eventsFrom(intents: Observable<INTENT>) -> Observable<Event>

    /// Map Intent to Action
    func actionsFrom(intents: Observable<INTENT>) -> Observable<ACTION>
}

extension Model {
    func getViewModel() -> Observable<VM> {
        return viewModel.observeOn(MainScheduler.instance)
    }
    
    func getActions() -> Observable<ACTION> {
        return actions.observeOn(MainScheduler.instance)
    }
    
    func detach() {
        disposables.dispose()
    }
    
    func dispatchEvent(event: Event) {
        events.onNext(event)
    }
    
    func makeViewModel(events: Observable<Event>, initialViewModel: VM, reducer: @escaping (VM, Event) -> VM) {
        _ = disposables.insert(self.events
            .scan(initialViewModel, accumulator: reducer)
            .startWith(initialViewModel)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onNext($0)
            }))
        
        _ = disposables.insert(events
            .subscribe(onNext: { [weak self] event in
                self?.events.onNext(event)
            }))
    }
    
    func makeActions(actions: Observable<ACTION>) {
        _ = disposables.insert(actions
            .subscribe(onNext: { [weak self] in
                self?.actions.onNext($0)
            }))
    }
}
