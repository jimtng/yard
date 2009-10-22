require 'rake'
require 'rake/tasklib'

module YARD
  module Rake
    
    # The rake task to run {CLI::Yardoc} and generate documentation.
    class YardocTask < ::Rake::TaskLib
      # The name of the task
      # @return [String] the task name
      attr_accessor :name
      
      # Options to pass to {CLI::Yardoc}
      # @return [Hash] the options passed to the commandline utility
      attr_accessor :options
      
      # The Ruby source files (and any extra documentation files separated by '-')
      # to process
      # @return [Array<String>] a list of files
      attr_accessor :files
      
      # Runs a +Proc+ before the task
      # @return [Proc] a proc to call before running the task
      attr_accessor :before
      
      # Runs a +Proc+ after the task
      # @return [Proc] a proc to call after running the task
      attr_accessor :after

      # Creates a new task with name +name+.
      # 
      # @param [String, Symbol] name the name of the rake task
      # @yield a block to allow any options to be modified on the task
      # @yieldparam [YardocTask] _self the task object to allow any parameters
      #   to be changed.
      def initialize(name = :yard)
        @name = name
        @options = []
        @files = []
        
        yield self if block_given?
        self.options +=  ENV['OPTS'].split(/[ ,]/) if ENV['OPTS'] 
        self.files   += ENV['FILES'].split(/[ ,]/) if ENV['FILES']
        
        define
      end
      
      protected
      
      # Defines the rake task
      # @return [nil] 
      def define
        desc "Generate YARD Documentation"
        task(name) do
          before.call if before.is_a?(Proc)
          YARD::CLI::Yardoc.run *(options + files) 
          after.call if after.is_a?(Proc)
        end
      end
    end
  end
end