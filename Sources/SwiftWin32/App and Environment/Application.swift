// Copyright © 2019 Saleem Abdulrasool <compnerd@compnerd.org>
// SPDX-License-Identifier: BSD-3-Clause

/// The centralised point of control and coordination for running applications.
open class Application: Responder {
  internal var information: Information?

  // MARK - Getting the Application Instance

  /// Returns the singleton application instance.
  public static var shared: Application = Application()

  // MARK - Managing the Application's Behaviour

  /// The delegate of the application object.
  public var delegate: ApplicationDelegate?

  // MARK - Getting the Application State

  /// The applications current state or that of its most active scene.
  public internal(set) var state: Application.State

  // MARK - Getting Scene Information

  /// A boolean indicating whether the application may display multiple scenes.
  public var supportsMultipleScenes: Bool {
    information?.scene?.supportsMultipleScenes ?? false
  }

  /// The application's currently connected scenes.
  public internal(set) var connectedScenes: Set<Scene> = []

  /// The sessions whose scenes are either currently active or archived by the
  /// system.
  public internal(set) var openSessions: Set<SceneSession> = []

  // MARK - Getting Application Windows

  /// The application’s visible and hidden windows.
  public internal(set) var windows: [Window]

  /// The application's key window.
  public internal(set) var keyWindow: Window?

  override public required init() {
    self.state = .active
    self.windows = []
    super.init()
  }

  // MARK - Responder Chain Overrides

  override public var next: Responder? {
    // The next responder is the application delegate, but only if the
    // application delegate is an instance of `Responder` and is not a `View`,
    // `ViewController`, or the `Application` object itself.
    if let responder = self.delegate as? Responder,
       !(self.delegate is View), !(self.delegate is ViewController),
       !(self.delegate === self) {
      return responder
    }
    return nil
  }
}

extension Application {
  /// The running states of the application
  public enum State: Int {
    /// The application is running in the foreground and currently receiving
    /// events.
    case active

    /// The application is running in the foreground but is not receiving events.
    case inactive

    /// The application is running in the background.
    case background
  }
}
