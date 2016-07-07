module Markov
  class Parser
    
    attr_reader :source

    def initialize source, options={}
      @source = source
    end
  
    def raw_text
      @raw_text ||= File.read(@source).scrub!
    end

    def tagged_text
      tagger = EngTagger.new
      @tagged_text ||= tagger.get_readable(raw_text)
    end
    
    def groups chunk_size, options={}
      text = options[:tagged] ? tagged_text : raw_text
      words = text.split
      (chunk_size - 1).times { |r,a| words.unshift("\"\"") }

      words.each_cons(chunk_size).to_a.inject([]){ |r,a| 
        r << { 
          prefix: a[0..(chunk_size - 2)],
          suffix: a.last 
        } 
      }
    end

  end
end