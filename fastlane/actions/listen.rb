# coding: utf-8

module Fastlane
  module Actions
   class ListenAction < Action
     def self.description
        "Runs Listen gem"
     end

     def self.available_options
       [FastlaneCore::ConfigItem.new(key: :watch, type: Array, optional: false),
        FastlaneCore::ConfigItem.new(key: :run, type: Proc, optional: false)
       ]
     end

     def self.run(params)
       require 'listen'
       params[:watch].each do |path|
         UI.message "Watching #{path} 😎."
       end
       args = params[:watch]
       listener = Listen.to(*args) do |modified, added, removed|
         modified.each do |item|
           UI.message "#{item} was modified 🎯"
         end
         added.each do |item|
           UI.message "#{item} was added 🎯."
         end
         removed.each do |item|
           UI.message "#{item} was removed 🎯"
         end
         listener.pause
         begin
           params[:run].call
           listener.start
         rescue
           listener.start
         end
           
       end
       listener.start
       sleep
     end
          
     def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
     end
   end
  end
end
