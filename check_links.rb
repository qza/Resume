require File.expand_path('../resume',__FILE__)
require 'rubygems'
require 'mechanize'
require 'logger'

SFT = " \t ::: \t "

desc "Check published links"
task :check_links do
  
  fday = "%Y-%m-%d"
  ftim = "%H-%M"
  
  @expect = "10 - 2 - 0"
  @res = {
    :valid => [],
    :skipped => [],
    :errors => []
  }
  
  agent = Mechanize.new do |a| 
    a.log = Logger.new("match.log", 'daily')
    a.log.level = Logger::INFO
    a.log.datetime_format = ftim
    a.log.info "\n --------------------------------- \n"  
  end
  
  loc = YAML.load_file('config.yaml')['github']['deploy']
  
  @links = agent.get("http://#{loc}").links
  
  @exclude = ['@','github']
  
  def @exclude.should?(name)
    each do |x|
      return true if name.index(x)      
    end
    false
  end
    
  @links.each do |l|
    if !@exclude.should?(l.text)
      begin
        @head = agent.head(l.href)
        @res[:valid] << l.text
      rescue Net::HTTPNotFound
        @res[:error] << l.text
      end
    else
      @res[:skipped] << l.text
    end
  end

  counts = [@res[:valid].length, @res[:skipped].length, @res[:errors].length]
  
  if counts.join(' - ') == @expect
    agent.log.info " \t RESULTS ARE VALID! "
  elsif counts[2] > 0
    agent.log.error " \t ERROR COUNT #{counts[2]} :: #{@res[:errors]} "  
  else
    agent.log.warn " \t RESULTS :: #{counts} / EXPECTED :: #{@expect}"
  end
  
end