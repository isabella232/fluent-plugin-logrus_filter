require 'fluent/filter'

module Fluent
  class LogrusFilter < Filter
    # Register this filter as "passthru"
    Fluent::Plugin.register_filter('log', self)

    # config_param works like other plugins

    def configure(conf)
      super
      # do the usual configuration here
    end

    def start
      super
      # This is the first method to be called when it starts running
      # Use it to allocate resources, etc.
    end

    def shutdown
      super
      # This method is called when Fluentd is shutting down.
      # Use it to free up resources, etc.
    end

    def filter(tag, time, record)
      # This method implements the filtering logic for individual filters
      # It is internal to this class and called by filter_stream unless
      # the user overrides filter_stream.
      #
      # Since our example is a pass-thru filter, it does nothing and just
      # returns the record as-is.
      # If returns nil, that records are ignored.
      #
      #
      metadata = Hash.new
      re = /((\w+)=(\S+)) ?/
      record['log'].scan(re) do |match|
        if match.length == 3
          if  match[1] != "time" || match[1] != "msg"
            metadata[match[1]] = match[2]
          end
        end
      end
      if not metadata.empty?
        record = record.merge(metadata)
      end
      record
    end
  end
end
