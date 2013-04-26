require 'rubygems'
require 'rufus/scheduler'
require 'mailreceiver'

scheduler = Rufus::Scheduler.start_new

puts "Scheduler was started at #{Time.now}"

scheduler.every '11m', :allow_overlapping => false, :first_in => '5m' do
  puts "Scheduler run at #{Time.now}"
  Mailreceiver::receive('mail_handler.yml')
end

