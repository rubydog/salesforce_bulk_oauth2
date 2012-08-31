require 'net/https'
require 'rubygems'
require 'xmlsimple'
require 'csv'
require "#{File.dirname(File.expand_path(__FILE__))}/salesforce_bulk/version"
require "#{File.dirname(File.expand_path(__FILE__))}/salesforce_bulk/job"
require "#{File.dirname(File.expand_path(__FILE__))}/salesforce_bulk/connection"
require 'databasedotcom'

module SalesforceBulk
  class Api

    @@SALESFORCE_API_VERSION = '23.0'

    def initialize(options)
      client = databasedotcom_client(options[:token], options[:instance_url])
      @connection = SalesforceBulk::Connection.new(@@SALESFORCE_API_VERSION,client)
    end
    
    def databasedotcom_client(token, instance_url)
      client = Databasedotcom::Client.new("#{Rails.root}/config/databasedotcom.yml")
      client.authenticate :token => token, :instance_url => instance_url
      client
    end

    def upsert(sobject, records, external_field)
      self.do_operation('upsert', sobject, records, external_field)
    end

    def update(sobject, records)
      self.do_operation('update', sobject, records, nil)
    end
    
    def create(sobject, records)
      self.do_operation('insert', sobject, records, nil)
    end

    def delete(sobject, records)
      self.do_operation('delete', sobject, records, nil)
    end

    def query(sobject, query)
      self.do_operation('query', sobject, query, nil)
    end

    #private

    def do_operation(operation, sobject, records, external_field)
      job = SalesforceBulk::Job.new(operation, sobject, records, external_field, @connection)

      # TODO: put this in one function
      job_id = job.create_job()
      if(operation == "query")
        batch_id = job.add_query()
      else
        batch_id = job.add_batch()
      end
      job.close_job()

      while true
        state = job.check_batch_status()
        #puts "\nstate is #{state}\n"
        if state != "Queued" && state != "InProgress"
          break
        end
        sleep(2) # wait x seconds and check again
      end

      if state == 'Completed'
        return job.get_batch_result()
      else
        return ["error"]
      end

    end

  end  # End class
end
