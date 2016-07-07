module Markov
  class Generate
  
    attr_reader :length, :weight, :start
  
    def initialize dbname, options={}
      @length = options[:length] || 200
      @weight = options[:weight] || 1.2
      @start = options[:start] || "The"
      @table = options[:table]
      @db = DB.new(dbname: dbname, chunk: options[:chunk] || 4)
    end
    
    def current_word
      @current_word = @word || @start
    end
    
    def next_word
      word  = current_word.match(/^,/) ? "," : current_word.split(",")[0]
      words = lookup(CGI.escape(word), @table)
      index = words[:probability].sample
      @word = CGI.unescape(words[:suffices][index])
    end
    
    def lookup word, table
      @lookup = @db.lookup(word, table)
      {
        suffices: @lookup.map { |s| s[0] },
        probability: @lookup.map.each_with_index { |c,i|
          [ (c[1].to_i ** @weight).round.times.inject([]){ |r,a| r << i } ]
        }.flatten
      }
    end
    
    def text
      (0..@length).inject("#@start "){ |r,a|
        next_word
        r << "#{current_word.match(/^,/) ? "," : current_word.split(",")[0]} "
      }.strip.squeeze(" ").gsub(/\s(\.|\,|:|;|`|'|\?|!)/,"\\1")
    end
   
  end
end
