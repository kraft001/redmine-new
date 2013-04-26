class Mailreceiver
  def self.receive(config_file)
    emails = YAML::load(open("#{Rails.root}/config/#{config_file}"))[Rails.env]
    shout "Processing config file #{config_file} with #{emails.size} emails"
    emails.each do |email, cfg|
      shout "#{email} handling..."
      protocol_options = {
        :general => cfg.slice(*%w(host port username password)),
        :imap => cfg.slice(*%w(ssl folder move_on_success move_on_failure)),
        :pop3 => cfg.slice(*%w(delete_unprocessed apop))
      }
      options = cfg.slice(*%w(allow_override unknown_user no_permission_check)).symbolize_keys
      options[:issue] = cfg.slice(*%w(project status tracker category priority mail_from assigned_to)).symbolize_keys

      begin
        if %w(imap pop3).include?(cfg['protocol'])
          connection_options =
            protocol_options[:general].
            merge(protocol_options[cfg['protocol'].to_sym]).
            symbolize_keys
          klass = "Redmine::#{cfg['protocol'].upcase}".constantize
          klass.check(connection_options, options)
        else
          MailHandler.receive(STDIN.read, options)
        end
      rescue Exception => e
        puts "Error: #{e.message}"
      end
      shout "#{email} finished"
    end
  end

  def self.shout(string)
    logger.info "#{Time.now.formatted(true)}: #{string}"
  end

  def self.logger
    @logger ||= Logger.new(File.join(Rails.root, 'log', 'scheduler.log'))
    @logger
  end
end
