# encoding: utf-8

# # # # #
# require 'irbtools' in your .irbrc
# but you could also require 'irbtools/configure' and then call Irbtools.init to modify the loaded libraries
# see the README file for more information

begin
  require 'zucker/alias_for'
  require 'zucker/env'       # Info, OS, RubyVersion, RubyEngine
rescue LoadError
  raise "Sorry, the irbtools couldn't load, because the zucker gem is not available"
end

# # # # #
# define module methods
module Irbtools
  @lib_hooks = Hash.new{|h,k| h[k] = [] }
  @libs = [] # %w[rubygems]
  @libs_in_proc = []
  @packages = []
  @railsrc = '~/.railsrc'
  @welcome_message = "Welcome to IRB. You are using #{ RUBY_DESCRIPTION }. Have fun ;)"

  class << self
    # message to display when starting. Set to nil to disable
    attr_accessor :welcome_message

    # lets you define the path to the irbrc or deactivate this feature with nil
    attr_accessor :railsrc

    # an array of the libraries which get loaded at start
    attr_accessor :libs
    aliases_for :libs, :libraries, :gems
    aliases_for :libs=, :libraries=, :gems=

    # an array of the libraries which get loaded everytime a new subirb starts (IRB.conf[:IRB_RC])
    attr_accessor :libs_in_proc
    aliases_for :libs_in_proc, :libraries_in_proc, :gems_in_proc
    aliases_for :libs_in_proc=, :libraries_in_proc=, :gems_in_proc=

    # an array of extension packages which get loaded (e.g. irbtools-more)
    attr_accessor :packages

    # add a library. the block gets executed, when the library was loaded.
    # if the second param is true, it's hooked in into IRB.conf[:IRB_RC] instead of the start.
    def add_library(lib, in_proc = false, &block)
      libs = in_proc ? @libs_in_proc : @libs
      libs << lib.to_s unless libs.include? lib.to_s

      @lib_hooks[lib.to_s] << block if block_given?
    end
    aliases_for :add_library, :add_lib, :add_gem

    # don't load a specific library
    def remove_library(lib)
      @libs.delete lib.to_s
      @libs_in_proc.delete lib.to_s
      @lib_hooks.delete lib.to_s
    end
    aliases_for :remove_library, :remove_lib, :remove_gem

    # add extensions packages
    def add_package(pkg)
      @packages << pkg.to_s
    end

    # remove extension package
    def remove_package(pkg)
      @packages.delete pkg.to_s
    end


    def library_loaded(lib) #:nodoc:
      @lib_hooks[lib.to_s].each{ |hook| hook.call }
    end
    private :library_loaded

    # loads all the stuff ;)
    def init
      require File.expand_path( '../irbtools.rb', File.dirname(__FILE__) )
    end
    alias start init
  end

  VERSION = ( File.read File.expand_path( '../../VERSION', File.dirname(__FILE__)) ).chomp
end

# # # # #
# libraries
require File.expand_path( 'libraries.rb', File.dirname(__FILE__) )

# J-_-L

