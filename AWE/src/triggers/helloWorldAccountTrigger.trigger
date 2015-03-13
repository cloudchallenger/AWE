trigger helloWorldAccountTrigger on Account
(before insert) {
MyHelloWorld.addHelloWorld(Trigger.new);
AccountSIC.addHelloSIC(Trigger.new);
}