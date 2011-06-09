Spec::Matchers.define :recognize do |env|
  match do |route|
    route.recognize(env)
  end
  
  failure_message_for_should do |route|
    "expected #{route.inspect} to recognize #{env.inspect}"
  end
  
  failure_message_for_should do |route|
    "expected #{route.inspect} not to recognize #{env.inspect}"
  end
  
  description do
    "recognizes #{env.inspect}"
  end
end