module Markov
  class DB
    
    def initialize options={}
      @host = options[:host] || "localhost"
      @user = options[:user] || "postgres"
      @port = options[:port] || 5432
      @dbname = options[:dbname] || ""
      @password = options[:password] || ""
      @chunk = options[:chunk] || 4
    end
    
    def config
      {
        host: @host,
        port: @port,
        user: @user, 
        dbname: @dbname, 
        password: @password
      }
    end

    def word_groups source, options={}
      @word_groups ||= Parser.new(source).groups(@chunk, options)
    end
    
    def split input
      [input].flatten.inject(""){ |r,a|
        r << [CGI.escape(a.split('/')[0]), a.split('/')[1] || "\"\""].join(",")
      } 
    end

    def tmp_csv name, source
      @dir = Dir.mktmpdir
      @path = [@dir, name].join("/")
      @tmp_csv = CSV.open(@path, "wb") do |csv|
        word_groups(source, { tagged: true }).each do |g|
          csv << [
            name,
            "{#{g[:prefix].map { |w| split(w) }.join(",")}}",
            split(g[:suffix])
          ]
        end
      end
      @path
    end
    
    def import name, source
      begin
        @csv = tmp_csv(name, source)
        @query = "COPY word_groups FROM '#{@dir}/#{name}' DELIMITER ',' CSV"
        connection(@query)
      ensure
        @csv && FileUtils.remove_entry(File.dirname(@csv))
        @word_groups = nil
      end
    end
    
    def lookup word, source
      @query = "SELECT suffix, count(*) AS count
                FROM word_groups 
                WHERE prefix[5] = '#{word}'
                AND source = '#{source}'
                GROUP BY suffix"
      connection(@query).values
    end
    
    def csv_sources
      @query = "SELECT DISTINCT source
                FROM word_groups"
      connection(@query).values.flatten
    end

    def json_sources
      @query = "SELECT DISTINCT word_groups->'source'
                FROM word_groups_jsonb"
      connection(@query).values.flatten
    end
    
    private
        
    def connection query=nil
      begin
        conn = PG.connect(config)
        query && conn.exec(query)
      ensure
        conn.close
      end
    end
    
  end
end