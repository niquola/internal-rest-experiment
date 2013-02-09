require 'rspec'
libpath = File.expand_path('../../lib', __FILE__)
$:.unshift(libpath) unless $:.include?(libpath)
require 'scheduling'
