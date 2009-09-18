#!/usr/bin/env ruby
require 'rubygems'

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')

require 'optiflag'
require 'daemons'
require 'xmpp4r'
require 'xmpp4r/muc'
require 'socket'

module DBChecker extend OptiFlagSet
  flag "e"
  flag "c"
  flag "v"

  and_process!
end

RAILS_ENV = ARGV.flags.e ||= 'development'

company_id = ARGV.flags.c
customer_visit_id = ARGV.flags.v

options = {
  :dir_mode   => :normal,
  :dir        => File.dirname(__FILE__) + '/../log',
  :multiple   => true,
  :mode       => :load,
  :backtrace  => true,
  :monitor    => false,
  :log_output => true
}

def log(message)
  puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{message}"
end

def commands_hash(support_options)
  res = {}
  support_options.each do |so|
    res[so.control] = so
  end
  res
end

SUPPORT_BOT_JID = "supportbot"
SERVER = "drop.io"

Daemons.run_proc("support_bot_#{customer_visit_id}", options) do      
  require RAILS_ROOT + '/config/environment'
    
  log "Started up support_bot in #{RAILS_ENV} for company_id #{company_id} and customer_visit_id #{customer_visit_id}"

  company = Company.find(company_id) rescue nil
  log "Could not find company with id #{company_id}..." and exit(1) if !company
  
  customer_visit = CustomerVisit.find(customer_visit_id) rescue nil
  log "Could not find customer visit with id #{customer_visit_id}" and exit(1) if !customer_visit
  
  drop_name = customer_visit.drop_name
  chat_password = customer_visit.chat_password
  
  my_nick = company.support_bot_nick || SupportAction::DEFAULT_SUPPORT_BOT_NICK
  error_response = company.support_bot_error_response || SupportAction::DEFAULT_SUPPORT_BOT_ERROR_RESPONSE
  
  current_support_action = company.support_actions.root.first
  current_support_options = current_support_action.support_options
  current_valid_commands = commands_hash(current_support_options) 
   
  client = Jabber::Client::new("#{SUPPORT_BOT_JID}@#{SERVER}")
  client.connect
  client.auth_anonymous_sasl
  client.send(Jabber::Presence.new.set_type(:available))
  
  kill_switch = false
  auto_kill_time = 2.hours.from_now
  
  muc = Jabber::MUC::SimpleMUCClient.new(client)
  muc.on_message { |time,nick,text|
      log "GOT MESSAGE: "  + (time || Time.new).strftime('%I:%M') + " <#{nick}> #{text}"
      
      if nick != my_nick 
        command = text.strip
        
        res = ""
        
        begin
          if command == SupportAction::START_OVER_COMMAND
            current_support_action = company.support_actions.root.first
            current_support_options = current_support_action.support_options
            current_valid_commands = commands_hash(current_support_options) 
          
            res += current_support_action.act(customer_visit)
          elsif current_valid_commands.keys.include?(command)
            current_support_action = current_valid_commands[command].target_support_action
            current_support_options = current_support_action.support_options
            current_valid_commands = commands_hash(current_support_options) 
          
            res += current_support_action.act(customer_visit)
          else
            res += error_response
          end
        rescue
          res += "Woops, something went wrong. Please try visiting #{company.name}'s customer service page again, and start over."
        end
        
        begin 
          muc.say(res)
          # the bot is no longer needed
          muc.exit and kill_switch = true if current_support_action.action_type == SupportAction::Actions::HELP
        rescue Exception => e
          log "ERROR: #{e.message}"
          exit(1)
        end
     end
  }    
  inited = false
  muc.on_join { |time, nick|
    if( nick.match("Guest") && !inited)
      inited = true
      log "this is probably the other guy so lets kick this thing off..."
      muc.say(current_support_action.act(customer_visit))
    end
  }
  muc.join(Jabber::JID.new("#{drop_name}@conference.#{SERVER}/#{my_nick}"),chat_password)
  
  while Time.now < auto_kill_time && !kill_switch
    sleep(1000)
  end
  
  log "DEAD"
end


