library angular2.src.core.compiler.view_listener;

import "package:angular2/di.dart" show Injectable;
import "view.dart" as viewModule;

/**
 * Listener for view creation / destruction.
 */
@Injectable()
class AppViewListener {
  viewCreated(viewModule.AppView view) {}
  viewDestroyed(viewModule.AppView view) {}
}
