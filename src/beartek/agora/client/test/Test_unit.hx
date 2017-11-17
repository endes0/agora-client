package beartek.agora.client.test;

import beartek.agora.client.test.Test_protocol;
import beartek.agora.client.test.Test_server;
import mohxa.Mohxa;

class Test_unit {

	static function main() {
		var run = new mohxa.Run([
      #if dummy_server
      new Test_protocol()
      #else
      new Test_server('localhost:8080')
      #end
      ]);

		trace('completed ${run.total} tests, ${run.failed} failures (${run.time}ms)');
  }
}
