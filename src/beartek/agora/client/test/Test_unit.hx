package beartek.agora.client.test;

import beartek.agora.client.test.Test_protocol;
import mohxa.Mohxa;

class Test_unit {
 var b : String = 'hola';

	static function main() {
		var run = new mohxa.Run([ new Test_protocol() ]);

		trace('completed ${run.total} tests, ${run.failed} failures (${run.time}ms)');
  }
}
