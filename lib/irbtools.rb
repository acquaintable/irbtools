# encoding: utf-8

# # # # #
# require 'irbtools' in your .irbrc
# see the README file for more information

require File.expand_path('irbtools/configure', File.dirname(__FILE__) )

# # # # #
# load libraries
remember_verbose_and_debug = $VERBOSE, $DEBUG
$VERBOSE = $DEBUG = false

Irbtools.libraries.each{ |lib|
  begin
    require lib.to_s

    Irbtools.send :library_loaded, lib

  rescue LoadError => err
    if err.to_s =~ /irb_rocket/ && RubyEngine.mri?
      warn "Couldn't load the irb_rocket gem.
You can install it with: gem install irb_rocket --source http://merbi.st"
    else
      warn "Couldn't load an irb library: #{err}"
    end
  end
}

$VERBOSE, $DEBUG = remember_verbose_and_debug

# # # # #
# general shortcuts & helper methods
File.expand_path('irbtools/general', File.dirname(__FILE__) )

# # # # #
# irb options
IRB.conf[:AUTO_INDENT]  = true                 # simple auto indent
IRB.conf[:EVAL_HISTORY] = 42424242424242424242 # creates the special __ variable
IRB.conf[:SAVE_HISTORY] = 2000                 # how many lines will go to ~/.irb_history

# prompt
IRB.conf[:PROMPT].merge!({:IRBTOOLS => {
  :PROMPT_I => ">> ",    # normal
  :PROMPT_N => "|  ",    # indenting
  :PROMPT_C => "(>>) ",  # continuing a statement
  :PROMPT_S => "%l> ",   # continuing a string
  :RETURN   => "=> %s \n",
  :AUTO_INDENT => true,
}})

IRB.conf[:PROMPT_MODE] = :IRBTOOLS

# # # # #
# misc
Object.const_set 'RV', RubyVersion  rescue nil
Object.const_set 'RE', RubyEngine   rescue nil

# # # # #
# workarounds
File.expand_path('irbtools/workarounds', File.dirname(__FILE__) )

# # # # #
# done :)
puts "Welcome to IRB. You are using #{ RUBY_DESCRIPTION }. Have fun ;)"

# J-_-L
