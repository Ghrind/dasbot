module Service
  class InvalidServiceError < StandardError

  end

  # A base class for service objects
  #
  # Define a new service class by subclassing Service::Base
  #
  #     class MyService < Service::Base
  #     end
  #
  # Override the #execute private method in order to implement your own logic.
  # The result of the #execute method will be returned along your service instance.
  #
  #     class AddNumbers < Service::Base
  #       def initialize(a, b)
  #         @a = a
  #         @b = b
  #       end
  #
  #       private
  #
  #       def execute
  #         @a + @b
  #       end
  #     end
  #
  #     AddNumbers.run!(3, 2) # => 5
  #     AddNumbers.run(3, 2) # => An instance of AddNumbers
  #     AddNumbers.run(3, 2).result  # => 5
  #
  # You can also implement validation using ActiveModel::Validations
  #
  # If your service is not valid, it will not be executed.
  #
  #     InvalidService.run! # => raises a Service::InvalidServiceError
  #     InvalidService.run!(validate: false) # => Nothing is raised, returns the result of #execute
  #
  #     InvalidService.run # => An instance of AddNumbers
  #     InvalidService.run.valid? # => false
  #     InvalidService.run.result # => nil
  #     InvalidService.run.errors # => An ActiveModel::Errors instance
  class Base

    include ActiveModel::Validations

    attr_reader :result

    def self.run(*args)
      new(*args).run
    end

    def self.run!(*args)
      new(*args).run!
    end

    def run!(validate: true)
      prepare
      fail Service::InvalidServiceError, errors.details.inspect if validate && !valid?
      execute
    end

    def run
      prepare
      if valid?
        @result = execute
        executed!
      end
      self
    end

    # Calling the validation chain should only happen once.
    # If you make changes that may alter the result of #valid?, consider instanciating another
    # service instead of running the same service again.
    #
    # You should never be able to call valid? on a service that has been executed by skipping
    # validations. That means that whenever the service has been executed:
    #   * It has been validated when calling #run
    #   * You can't call valid? on it because you called #run! and didn't get the instance back
    def valid?
      return @_valid unless @_valid.nil?
      @_valid = super
    end

    def executed?
      @executed.present?
    end

    private

    def prepare
    end

    def execute
      # Your service logic goes here
      true
    end

    def executed!
      @executed = true
    end

  end
end
