import 'package:unittest/unittest.dart';
import 'package:logging/logging.dart';
import 'package:pubsub/Pubsub.dart';
import 'package:pubsub/message.dart';

void main() {
	hierarchicalLoggingEnabled = true;
	Pubsub.logger.level = Level.ALL;


	test('Wildcard Channel Test', () {
		Pubsub.publish('whatever', 'test passed');
		cb(PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
		}
		Function c1 = expectAsync1(cb);
		Pubsub.subscribe('*', c1);
		Pubsub.unsubscribe('*', c1);
	});

	test('Single Channel Test', () {
		Pubsub.subscribe('single', expectAsync1((PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
		}));
		Pubsub.publish('single', 'test passed');
	});

	test('Multiple Channel Test', () {
		Pubsub.subscribe('first second', expectAsync1((PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
		}, count: 2));
		Pubsub.publish('first', 'test passed');
		Pubsub.publish('second', 'test passed');
	});

	test('Simple Hierarchical Channel Test', () {
		Pubsub.subscribe('simple.hierarchical', expectAsync1((PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
		}));
		Pubsub.publish('simple.hierarchical', 'test passed');
	});

	test('Complex Hierarchical Channel Test', () {
		Pubsub.subscribe('Complex', expectAsync1((PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
		}));
		Pubsub.publish('Complex.hierarchical', 'test passed');
	});

	test('Multiple publishes before subscribe only get latest message Test', () {
		Pubsub.publish('multiple-messages', '1');
		Pubsub.publish('multiple-messages', 2);
		Pubsub.publish('multiple-messages', '3');
		Pubsub.publish('multiple-messages', 'test passed');
		Pubsub.subscribe('multiple-messages', expectAsync1((PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
		}));
	});

	test('Multiple arguments Test', () {
		Pubsub.subscribe('multi-args', expectAsync1((PubsubMessage msg){
			expect(msg.arguments[0], equals('test passed'));
			expect(msg.arguments[1], equals(1));
			expect(msg.arguments[2], equals(2));
			expect(msg.arguments[3], orderedEquals([3, 4, 5]));
		}));
		Pubsub.publish('multi-args', 'test passed', 1, 2, [3, 4, 5]);
	});
}