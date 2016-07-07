require "test_helper"

describe "Markov::DB" do

  before do
    @dbname = "markov_test"
    @source = "test/fixtures/text_sample.txt"
    @parser = Markov::Parser.new(@source)
    @db = Markov::DB.new(dbname: @dbname)
  end

  it "connects to the db" do
    assert @db.send(:connection, "")
  end

  it "makes the word groups from a parser" do
    assert_equal @db.word_groups(@source), 
                 @parser.groups(4)
  end
  
  describe "adding a csv source" do

    before do
      @csv = @db.tmp_csv("testing", @source)
    end
    
    it "makes a temporary csv" do
      assert File.exists?(@csv)
    end
    
    it "imports the temp csv" do
      @db.import("testing", @source)
      @query = "SELECT * FROM word_groups WHERE source = 'testing'"
      assert_equal @db.send(:connection, @query).values.length,
                   @db.word_groups(@source, { tagged: true }).length
    end
    
    it "gets a list of available csv sources" do
      @db.import("testing", @source)
      assert_includes @db.csv_sources, "testing"
    end
    
    after do
      FileUtils.remove_entry(File.dirname(@csv))
    end
    
  end
  
  after do
    @db.send(:connection, 
             "DELETE FROM word_groups 
              WHERE source = 'testing';")
    @db.send(:connection, "TRUNCATE word_groups_jsonb")
  end

end