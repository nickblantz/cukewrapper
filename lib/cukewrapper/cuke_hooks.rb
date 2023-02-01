# frozen_string_literal: true

require 'cucumber'

Before { Cukewrapper::Runtime.register_world(self) }
Before(&Cukewrapper::Runtime.before_scenario)
Given(Cukewrapper::Runtime::STEP_PATTERN, &Cukewrapper::Runtime.step_handler)
After(&Cukewrapper::Runtime.after_scenario)
